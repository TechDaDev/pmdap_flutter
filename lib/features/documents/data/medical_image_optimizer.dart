import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import 'documents_api.dart' show medicalUploadContentType;

/// A prepared medical upload: either the untouched original or an optimized
/// app-private derivative.
///
/// Privacy rule: this object NEVER carries patient data. It holds paths, byte
/// counts and dimensions only — the fields required for a safe upload.
class MedicalUploadAsset {
  const MedicalUploadAsset({
    this.uploadPath,
    this.uploadBytesData,
    required this.originalBytes,
    required this.uploadBytes,
    required this.originalWidth,
    required this.originalHeight,
    required this.uploadWidth,
    required this.uploadHeight,
    required this.mimeType,
    required this.optimized,
    required this.temporary,
    required this.prepareElapsedMs,
  });

  /// Path to upload (mobile: temp optimized copy, or the untouched original).
  final String? uploadPath;

  /// Bytes to upload (web: dart:io File paths are unavailable). Exactly one of
  /// [uploadPath] / [uploadBytesData] is set per platform.
  final Uint8List? uploadBytesData;
  final int originalBytes;
  final int uploadBytes;
  final int originalWidth;
  final int originalHeight;
  final int uploadWidth;
  final int uploadHeight;

  /// `image/jpeg`, `image/png`, `application/pdf` or
  /// `application/octet-stream` for unrecognized input.
  final String mimeType;
  final bool optimized;

  /// True when [uploadPath] is an app-private temp derivative owned by this
  /// optimizer (must be cleaned up after the upload flow finishes).
  final bool temporary;
  final int prepareElapsedMs;

  /// Uploadable pixel count after optimization (used for client prevalidation).
  int? get uploadPixels =>
      (uploadWidth > 0 && uploadHeight > 0) ? uploadWidth * uploadHeight : null;

  /// True when this asset carries in-memory bytes (web upload path).
  bool get hasBytes => uploadBytesData != null;
}

/// Source image is too large for this device to prepare safely.
class MedicalImageTooLargeException implements Exception {
  const MedicalImageTooLargeException();
}

/// Optimization failed and a safe fallback was not possible.
class MedicalImagePrepareException implements Exception {
  const MedicalImagePrepareException();
}

/// Client-side medical image optimizer policy.
///
/// PDFs are NEVER touched. JPEG re-encoded; PNG resized losslessly (no blind
/// PNG→JPEG conversion — transparency/line-art can matter). Only optimize when
/// the source actually exceeds a threshold, otherwise upload the original.
abstract class MedicalImageOptimizer {
  /// Optimize when the source is larger than this on either edge (px).
  ///
  /// Benchmark-verified on a real 41MP lab report: at 3200 the backend OCR
  /// retained only ~77% of recoverable text vs 100% at 3600 (2400:77%,
  /// 2800:79%, 4000:79%, 4800:76% — higher res over-segments). 3600 is the
  /// smallest edge with full content retention (97/97 lines) while staying
  /// ~9MP (under the 20MP backend OCR ceiling) at ~1MB.
  static const int maxLongEdge = 3600;

  /// JPEG re-encode quality (ignored for lossless PNG). q90 preserved all
  /// content; q85 dropped lines, q92 added <1% for +10% bytes.
  static const int jpegQuality = 90;

  /// Also optimize when the source exceeds this size even if small enough.
  static const int optimizeSizeThresholdBytes = 4 * 1024 * 1024;

  /// Hard source-pixel ceiling consistent with backend safety. Above this we
  /// refuse to prepare rather than risk decoding an absurd image into heap
  /// (device protection). Backend MEDICAL_IMAGE_MAX_PIXELS stays authoritative.
  static const int sourcePixelSafetyLimit = 96_000_000;

  /// Backend MEDICAL_FILE_MAX_BYTES — server stays authoritative.
  static const int serverMaxBytes = 25 * 1024 * 1024;

  /// Backend MEDICAL_IMAGE_MAX_PIXELS — server stays authoritative.
  static const int serverMaxPixels = 64_000_000;

  /// Inspect + (if beneficial) optimize a medical source.
  ///
  /// Never upscales, never modifies the source, never writes to public
  /// storage. Returns an [MedicalUploadAsset] whose [uploadPath] is the file
  /// that should actually be uploaded.
  Future<MedicalUploadAsset> prepare(String sourcePath);

  /// Delete a temporary optimized derivative (no-op for originals).
  Future<void> disposeTemporary(MedicalUploadAsset asset);
}

/// Dimensions read straight from a JPEG/PNG header — no full decode.
typedef ImageHeader = ({int width, int height});

/// Reads JPEG/PNG dimensions from the file header (cheap, O(1)).
///
/// Returns null when the header cannot be parsed or the format is not
/// JPEG/PNG. PDFs are not inspected here.
ImageHeader? readImageDimensions(String path) {
  try {
    final raf = File(path).openSync();
    try {
      // Read up to 1 MB of the header. JPEG SOF can sit far past byte 64 when
      // a large APP1/EXIF thumbnail precedes it (typical for phone photos);
      // PNG IHDR is always at offset 16, so this is plenty for both.
      final len = raf.lengthSync();
      final head = raf.readSync(len < (1024 * 1024) ? len : (1024 * 1024));
      // PNG: IHDR width/height at fixed offsets 16..23 (big-endian).
      if (head.length >= 24 &&
          head[0] == 0x89 &&
          head[1] == 0x50 &&
          head[2] == 0x4e &&
          head[3] == 0x47) {
        return (
          width:
              (head[16] << 24) | (head[17] << 16) | (head[18] << 8) | head[19],
          height:
              (head[20] << 24) | (head[21] << 16) | (head[22] << 8) | head[23],
        );
      }
      // JPEG: scan markers for a SOF segment (C0..C3, C5..C7, C9..CB, CD..CF).
      // SOF payload: 1 byte precision, 2 bytes height, 2 bytes width.
      if (head.length >= 4 &&
          head[0] == 0xff &&
          head[1] == 0xd8 &&
          head[2] == 0xff) {
        var offset = 2;
        while (offset + 9 <= head.length) {
          if (head[offset] != 0xff) {
            offset++;
            continue;
          }
          // Skip fill bytes.
          while (offset < head.length && head[offset] == 0xff) {
            offset++;
          }
          if (offset >= head.length) break;
          final marker = head[offset];
          offset++;
          if (marker == 0xd8 || marker == 0xd9 || marker == 0x01) {
            continue;
          }
          // Standalone markers with no length.
          if (marker >= 0xd0 && marker <= 0xd7) {
            continue;
          }
          if (offset + 2 > head.length) break;
          final segLen = (head[offset] << 8) | head[offset + 1];
          if (segLen < 2) break;
          final isSof =
              (marker >= 0xc0 && marker <= 0xc3) ||
              (marker >= 0xc5 && marker <= 0xc7) ||
              (marker >= 0xc9 && marker <= 0xcb) ||
              (marker >= 0xcd && marker <= 0xcf);
          if (isSof && offset + 7 <= head.length) {
            final height = (head[offset + 3] << 8) | head[offset + 4];
            final width = (head[offset + 5] << 8) | head[offset + 6];
            if (width > 0 && height > 0) {
              return (width: width, height: height);
            }
            return null;
          }
          offset += segLen;
        }
      }
    } finally {
      raf.closeSync();
    }
  } catch (_) {
    return null;
  }
  return null;
}

/// Aspect-preserving target size bounded by [maxLongEdge]; never upscales.
ImageHeader targetDimensions({
  required int width,
  required int height,
  required int maxLongEdge,
}) {
  final longest = math.max(width, height);
  if (longest <= maxLongEdge) return (width: width, height: height);
  final scale = maxLongEdge / longest;
  var tw = (width * scale).round();
  var th = (height * scale).round();
  if (tw < 1) tw = 1;
  if (th < 1) th = 1;
  return (width: tw, height: th);
}

/// Decides whether an image benefits from optimization.
bool shouldOptimizeMedicalImage({
  required int width,
  required int height,
  required int bytes,
  int maxLongEdge = MedicalImageOptimizer.maxLongEdge,
  int sizeThreshold = MedicalImageOptimizer.optimizeSizeThresholdBytes,
}) {
  return math.max(width, height) > maxLongEdge || bytes > sizeThreshold;
}

/// Signature of the native encode step, injectable for tests.
typedef ImageCompressCall =
    Future<File?> Function({
      required String sourcePath,
      required String targetPath,
      required int minWidth,
      required int minHeight,
      required int quality,
      required CompressFormat format,
    });

/// Native-codec optimizer (flutter_image_compress). Decode/resize/encode runs
/// on the native thread, so the Dart UI thread is never blocked.
class NativeMedicalImageOptimizer implements MedicalImageOptimizer {
  NativeMedicalImageOptimizer({
    String? temporaryDirectoryOverride,
    ImageCompressCall? compressOverride,
  }) : _temporaryDirectoryOverride = temporaryDirectoryOverride,
       _compressOverride = compressOverride;

  final String? _temporaryDirectoryOverride;
  final ImageCompressCall? _compressOverride;

  Future<Directory> _tempRoot() async {
    final base =
        _temporaryDirectoryOverride ?? (await getTemporaryDirectory()).path;
    final dir = Directory('$base/medical_prepare');
    await dir.create(recursive: true);
    return dir;
  }

  String _tempName(String mimeType) {
    final ext = mimeType == 'image/png' ? 'png' : 'jpg';
    final rnd = math.Random.secure().nextInt(0x7fffffff).toRadixString(36);
    return 'medical_upload_${DateTime.now().microsecondsSinceEpoch}_$rnd.$ext';
  }

  @override
  Future<MedicalUploadAsset> prepare(String sourcePath) async {
    final sw = Stopwatch()..start();
    final originalBytes = File(sourcePath).lengthSync();
    final mimeType =
        medicalUploadContentType(sourcePath)?.mimeType ??
        'application/octet-stream';

    // PDF: never optimized.
    if (mimeType == 'application/pdf') {
      return MedicalUploadAsset(
        uploadPath: sourcePath,
        originalBytes: originalBytes,
        uploadBytes: originalBytes,
        originalWidth: 0,
        originalHeight: 0,
        uploadWidth: 0,
        uploadHeight: 0,
        mimeType: mimeType,
        optimized: false,
        temporary: false,
        prepareElapsedMs: sw.elapsedMilliseconds,
      );
    }

    // Unsupported input: leave untouched; the server rejects with a clear
    // message.
    if (mimeType != 'image/jpeg' && mimeType != 'image/png') {
      return MedicalUploadAsset(
        uploadPath: sourcePath,
        originalBytes: originalBytes,
        uploadBytes: originalBytes,
        originalWidth: 0,
        originalHeight: 0,
        uploadWidth: 0,
        uploadHeight: 0,
        mimeType: mimeType,
        optimized: false,
        temporary: false,
        prepareElapsedMs: sw.elapsedMilliseconds,
      );
    }

    final header = readImageDimensions(sourcePath);
    final width = header?.width ?? 0;
    final height = header?.height ?? 0;
    final pixels = width > 0 && height > 0 ? width * height : 0;

    // Device protection: refuse absurd sources before decoding.
    if (pixels > MedicalImageOptimizer.sourcePixelSafetyLimit) {
      throw const MedicalImageTooLargeException();
    }

    final shouldOptimize =
        (width > 0 &&
            height > 0 &&
            shouldOptimizeMedicalImage(
              width: width,
              height: height,
              bytes: originalBytes,
            )) ||
        (width == 0 &&
            originalBytes > MedicalImageOptimizer.optimizeSizeThresholdBytes);

    if (!shouldOptimize) {
      _logPrepare(
        originalBytes: originalBytes,
        uploadBytes: originalBytes,
        original: (width, height),
        upload: (width, height),
        optimized: false,
        elapsedMs: sw.elapsedMilliseconds,
      );
      return MedicalUploadAsset(
        uploadPath: sourcePath,
        originalBytes: originalBytes,
        uploadBytes: originalBytes,
        originalWidth: width,
        originalHeight: height,
        uploadWidth: width,
        uploadHeight: height,
        mimeType: mimeType,
        optimized: false,
        temporary: false,
        prepareElapsedMs: sw.elapsedMilliseconds,
      );
    }

    final target = (width > 0 && height > 0)
        ? targetDimensions(
            width: width,
            height: height,
            maxLongEdge: MedicalImageOptimizer.maxLongEdge,
          )
        : (
            width: MedicalImageOptimizer.maxLongEdge,
            height: MedicalImageOptimizer.maxLongEdge,
          );

    final root = await _tempRoot();
    final tempPath = '${root.path}/${_tempName(mimeType)}';
    final format = mimeType == 'image/png'
        ? CompressFormat.png
        : CompressFormat.jpeg;

    final File? written;
    try {
      written = await _compress(
        sourcePath: sourcePath,
        targetPath: tempPath,
        minWidth: target.width,
        minHeight: target.height,
        quality: MedicalImageOptimizer.jpegQuality,
        format: format,
      );
    } catch (_) {
      throw const MedicalImagePrepareException();
    }

    final outFile = File(tempPath);
    if (written == null || !outFile.existsSync() || outFile.lengthSync() == 0) {
      // Try to fall back to the original if it would still pass server limits.
      if (_originalWithinServerLimits(bytes: originalBytes, pixels: pixels)) {
        _logPrepare(
          originalBytes: originalBytes,
          uploadBytes: originalBytes,
          original: (width, height),
          upload: (width, height),
          optimized: false,
          elapsedMs: sw.elapsedMilliseconds,
        );
        return MedicalUploadAsset(
          uploadPath: sourcePath,
          originalBytes: originalBytes,
          uploadBytes: originalBytes,
          originalWidth: width,
          originalHeight: height,
          uploadWidth: width,
          uploadHeight: height,
          mimeType: mimeType,
          optimized: false,
          temporary: false,
          prepareElapsedMs: sw.elapsedMilliseconds,
        );
      }
      throw const MedicalImagePrepareException();
    }

    final uploadBytes = outFile.lengthSync();

    // If optimization made things bigger, keep the original.
    if (uploadBytes >= originalBytes) {
      await _deleteQuiet(tempPath);
      _logPrepare(
        originalBytes: originalBytes,
        uploadBytes: originalBytes,
        original: (width, height),
        upload: (width, height),
        optimized: false,
        elapsedMs: sw.elapsedMilliseconds,
      );
      return MedicalUploadAsset(
        uploadPath: sourcePath,
        originalBytes: originalBytes,
        uploadBytes: originalBytes,
        originalWidth: width,
        originalHeight: height,
        uploadWidth: width,
        uploadHeight: height,
        mimeType: mimeType,
        optimized: false,
        temporary: false,
        prepareElapsedMs: sw.elapsedMilliseconds,
      );
    }

    // Read actual optimized dimensions from the temp file header.
    final outHeader = readImageDimensions(tempPath);
    final outWidth = outHeader?.width ?? target.width;
    final outHeight = outHeader?.height ?? target.height;

    _logPrepare(
      originalBytes: originalBytes,
      uploadBytes: uploadBytes,
      original: (width, height),
      upload: (outWidth, outHeight),
      optimized: true,
      elapsedMs: sw.elapsedMilliseconds,
    );

    return MedicalUploadAsset(
      uploadPath: tempPath,
      originalBytes: originalBytes,
      uploadBytes: uploadBytes,
      originalWidth: width,
      originalHeight: height,
      uploadWidth: outWidth,
      uploadHeight: outHeight,
      mimeType: mimeType,
      optimized: true,
      temporary: true,
      prepareElapsedMs: sw.elapsedMilliseconds,
    );
  }

  @override
  Future<void> disposeTemporary(MedicalUploadAsset asset) async {
    if (!asset.temporary || asset.uploadPath == null) return;
    await _deleteQuiet(asset.uploadPath!);
  }

  Future<File?> _compress({
    required String sourcePath,
    required String targetPath,
    required int minWidth,
    required int minHeight,
    required int quality,
    required CompressFormat format,
  }) {
    final override = _compressOverride;
    if (override != null) {
      return override(
        sourcePath: sourcePath,
        targetPath: targetPath,
        minWidth: minWidth,
        minHeight: minHeight,
        quality: quality,
        format: format,
      );
    }
    return _nativeCompress(
      sourcePath: sourcePath,
      targetPath: targetPath,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
      format: format,
    );
  }

  Future<File?> _nativeCompress({
    required String sourcePath,
    required String targetPath,
    required int minWidth,
    required int minHeight,
    required int quality,
    required CompressFormat format,
  }) async {
    // flutter_image_compress 2.x returns a cross_file XFile; normalize to File.
    final out = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
      format: format,
      // Bake EXIF orientation into the pixels; output is physically upright
      // and carries no residual orientation tag.
      autoCorrectionAngle: true,
      keepExif: false,
    );
    return out == null ? null : File(out.path);
  }

  bool _originalWithinServerLimits({required int bytes, required int pixels}) {
    if (bytes > MedicalImageOptimizer.serverMaxBytes) return false;
    if (pixels > MedicalImageOptimizer.serverMaxPixels) return false;
    return true;
  }

  Future<void> _deleteQuiet(String path) async {
    try {
      final f = File(path);
      if (await f.exists()) await f.delete();
    } catch (_) {
      // Best-effort cleanup.
    }
  }

  void _logPrepare({
    required int originalBytes,
    required int uploadBytes,
    required (int, int) original,
    required (int, int) upload,
    required bool optimized,
    required int elapsedMs,
  }) {
    if (!kDebugMode) return;
    debugPrint(
      'medical_prepare original_bytes=$originalBytes '
      'upload_bytes=$uploadBytes original=${original.$1}x${original.$2} '
      'upload=${upload.$1}x${upload.$2} optimized=$optimized '
      'elapsed_ms=$elapsedMs',
    );
  }
}
