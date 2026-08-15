import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/features/documents/data/medical_image_optimizer.dart';

/// Minimal-but-parseable PNG bytes (signature + IHDR with the requested
/// dimensions + IEND). The optimizer only reads the header, never decodes,
/// so a header fixture is sufficient and keeps tests fast.
List<int> buildPng(int width, int height) {
  final ihdr = <int>[
    (width >> 24) & 0xff,
    (width >> 16) & 0xff,
    (width >> 8) & 0xff,
    width & 0xff,
    (height >> 24) & 0xff,
    (height >> 16) & 0xff,
    (height >> 8) & 0xff,
    height & 0xff,
    8, // bit depth
    2, // color type RGB
    0, // compression
    0, // filter
    0, // interlace
  ];
  List<int> chunk(String type, List<int> data) => [
    (data.length >> 24) & 0xff,
    (data.length >> 16) & 0xff,
    (data.length >> 8) & 0xff,
    data.length & 0xff,
    ...type.codeUnits,
    ...data,
  ];
  return [
    0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, // PNG signature
    ...chunk('IHDR', ihdr),
    ...chunk('IEND', const []),
  ];
}

/// Minimal JPEG with a real SOF0 segment carrying [width]x[height] so the
/// header parser can read dimensions without a full valid JPEG body.
List<int> buildJpeg(int width, int height) {
  return [
    0xff, 0xd8, // SOI
    0xff, 0xe0, 0x00, 0x10, // APP0
    0x4a, 0x46, 0x49, 0x46, 0x00, 0x01, 0x01, 0x00, 0x00, 0x01, 0x00, 0x01,
    0x00, 0x00, 0x00, 0x00,
    0xff, 0xc0, 0x00, 0x11, 0x08, // SOF0 (precision 8)
    (height >> 8) & 0xff, height & 0xff,
    (width >> 8) & 0xff, width & 0xff,
    0x03, 0x01, 0x22, 0x00, 0x02, 0x11, 0x01, 0x03, 0x11, 0x01,
    0xff, 0xd9, // EOI
  ];
}

File _writeTemp(String dir, String name, List<int> bytes) {
  final f = File('$dir/$name');
  f.writeAsBytesSync(bytes);
  return f;
}

void main() {
  late Directory tempDir;
  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('opt_test');
  });
  tearDown(() {
    try {
      tempDir.deleteSync(recursive: true);
    } catch (_) {}
  });

  group('readImageDimensions', () {
    test('reads PNG dimensions from header', () {
      final f = _writeTemp(tempDir.path, 'a.png', buildPng(3024, 4032));
      final dims = readImageDimensions(f.path);
      expect(dims, isNotNull);
      expect(dims!.width, 3024);
      expect(dims.height, 4032);
    });

    test('reads JPEG dimensions from SOF segment', () {
      final f = _writeTemp(tempDir.path, 'a.jpg', buildJpeg(5360, 7728));
      final dims = readImageDimensions(f.path);
      expect(dims, isNotNull);
      expect(dims!.width, 5360);
      expect(dims.height, 7728);
    });

    test('reads JPEG dims even when a large APP1/EXIF precedes SOF', () {
      // Phone photos carry a big EXIF thumbnail before the SOF segment; the
      // SOF lands far past byte 64. Regression: header read must not truncate.
      final bigApp1 = <int>[
        0xff, 0xe1, // APP1 marker
        (0x0800 >> 8) & 0xff,
        0x0800 & 0xff, // segment length 2048
        ...List.filled(2048 - 2, 0x42),
      ];
      final jpeg = <int>[
        0xff,
        0xd8, // SOI
        ...bigApp1,
        ...buildJpeg(5360, 7728).sublist(2), // APP0 + SOF + EOI after SOI
      ];
      final f = _writeTemp(tempDir.path, 'exif.jpg', jpeg);
      final dims = readImageDimensions(f.path);
      expect(dims, isNotNull);
      expect(dims!.width, 5360);
      expect(dims.height, 7728);
    });

    test('returns null for PDF', () {
      final f = _writeTemp(tempDir.path, 'a.pdf', [
        0x25,
        0x50,
        0x44,
        0x46,
        ...List.filled(20, 0x30),
      ]);
      expect(readImageDimensions(f.path), isNull);
    });

    test('returns null for missing file', () {
      expect(readImageDimensions('${tempDir.path}/nope.jpg'), isNull);
    });
  });

  group('targetDimensions', () {
    test('portrait downscaled to max long edge, aspect preserved', () {
      final t = targetDimensions(width: 5360, height: 7728, maxLongEdge: 3200);
      // 3200 / 7728 * 5360 ≈ 2219
      expect(t.width, 2219);
      expect(t.height, 3200);
      expect((t.width / t.height - 5360 / 7728).abs(), lessThan(0.001));
    });

    test('landscape downscaled, aspect preserved', () {
      final t = targetDimensions(width: 7728, height: 5360, maxLongEdge: 3200);
      expect(t.width, 3200);
      expect(t.height, 2219);
    });

    test('never upscales', () {
      final t = targetDimensions(width: 1000, height: 800, maxLongEdge: 3200);
      expect(t.width, 1000);
      expect(t.height, 800);
    });

    test('exact edge unchanged', () {
      final t = targetDimensions(width: 3200, height: 2400, maxLongEdge: 3200);
      expect(t.width, 3200);
      expect(t.height, 2400);
    });
  });

  group('shouldOptimizeMedicalImage', () {
    test('large dimensions -> optimize', () {
      expect(
        shouldOptimizeMedicalImage(width: 5360, height: 7728, bytes: 9_800_000),
        isTrue,
      );
    });

    test('small image -> no optimize', () {
      expect(
        shouldOptimizeMedicalImage(width: 1200, height: 1600, bytes: 400_000),
        isFalse,
      );
    });

    test('size over threshold -> optimize even if small', () {
      expect(
        shouldOptimizeMedicalImage(width: 2000, height: 1500, bytes: 6_000_000),
        isTrue,
      );
    });

    test('small dims and small bytes -> no optimize', () {
      expect(
        shouldOptimizeMedicalImage(width: 2000, height: 1500, bytes: 3_000_000),
        isFalse,
      );
    });
  });

  group('NativeMedicalImageOptimizer.prepare', () {
    NativeMedicalImageOptimizer optimizer({
      void Function(int minWidth, int minHeight)? onCompress,
    }) {
      return NativeMedicalImageOptimizer(
        temporaryDirectoryOverride: tempDir.path,
        compressOverride:
            ({
              required String sourcePath,
              required String targetPath,
              required int minWidth,
              required int minHeight,
              required int quality,
              required CompressFormat format,
            }) async {
              onCompress?.call(minWidth, minHeight);
              final bytes = format == CompressFormat.png
                  ? buildPng(minWidth, minHeight)
                  : buildJpeg(minWidth, minHeight);
              _writeTemp(tempDir.path, 'out.tmp', bytes);
              File(targetPath).writeAsBytesSync(bytes);
              return File(targetPath);
            },
      );
    }

    test('PDF is never optimized', () async {
      final src = _writeTemp(tempDir.path, 'doc.pdf', [
        0x25,
        0x50,
        0x44,
        0x46,
        0x2d,
        0x31,
        0x2e,
        0x34,
        ...List.filled(100, 0x30),
      ]);
      final asset = await optimizer().prepare(src.path);
      expect(asset.optimized, isFalse);
      expect(asset.temporary, isFalse);
      expect(asset.mimeType, 'application/pdf');
      expect(asset.uploadPath, src.path);
    });

    test('small JPEG -> upload original untouched', () async {
      final src = _writeTemp(tempDir.path, 'small.jpg', [
        ...buildJpeg(1200, 1600),
        ...List.filled(2000, 0),
      ]);
      final asset = await optimizer().prepare(src.path);
      expect(asset.optimized, isFalse);
      expect(asset.temporary, isFalse);
      expect(asset.uploadPath, src.path);
      expect(asset.originalWidth, 1200);
      expect(asset.originalHeight, 1600);
    });

    test('large JPEG -> resized to max long edge, temp derivative', () async {
      int? calledW, calledH;
      final src = _writeTemp(tempDir.path, 'big.jpg', [
        ...buildJpeg(4000, 3000),
        ...List.filled(4000, 0),
      ]);
      final opt = optimizer(
        onCompress: (w, h) {
          calledW = w;
          calledH = h;
        },
      );
      final asset = await opt.prepare(src.path);
      expect(asset.optimized, isTrue);
      expect(asset.temporary, isTrue);
      expect(asset.uploadPath, isNot(src.path));
      expect(asset.mimeType, 'image/jpeg');
      expect(asset.originalWidth, 4000);
      expect(asset.originalHeight, 3000);
      // Long edge bounded by the policy max.
      expect(calledW, lessThanOrEqualTo(MedicalImageOptimizer.maxLongEdge));
      expect(calledH, lessThanOrEqualTo(MedicalImageOptimizer.maxLongEdge));
      expect(asset.uploadWidth, calledW);
      expect(asset.uploadHeight, calledH);
      // Aspect preserved.
      final srcRatio = 4000 / 3000;
      final outRatio = asset.uploadWidth / asset.uploadHeight;
      expect((outRatio - srcRatio).abs(), lessThan(0.001));

      // disposeTemporary deletes the derivative.
      expect(File(asset.uploadPath).existsSync(), isTrue);
      await opt.disposeTemporary(asset);
      expect(File(asset.uploadPath).existsSync(), isFalse);
    });

    test(
      'PNG -> resized losslessly (png format, no quality lossy path)',
      () async {
        // Pad so the source is larger than the (tiny) header-only optimized
        // derivative; otherwise the bigger-than-original fallback would fire.
        final src = _writeTemp(tempDir.path, 'big.png', [
          ...buildPng(4000, 3000),
          ...List.filled(500, 0),
        ]);
        final asset = await optimizer().prepare(src.path);
        expect(asset.optimized, isTrue);
        expect(asset.temporary, isTrue);
        expect(asset.mimeType, 'image/png');
        expect(
          asset.uploadWidth,
          lessThanOrEqualTo(MedicalImageOptimizer.maxLongEdge),
        );
      },
    );

    test('optimized larger than original -> falls back to original', () async {
      final src = _writeTemp(tempDir.path, 'big2.jpg', [
        ...buildJpeg(4000, 3000),
        ...List.filled(60, 0),
      ]);
      final opt = NativeMedicalImageOptimizer(
        temporaryDirectoryOverride: tempDir.path,
        compressOverride:
            ({
              required String sourcePath,
              required String targetPath,
              required int minWidth,
              required int minHeight,
              required int quality,
              required CompressFormat format,
            }) async {
              // Simulate a "compression" that produced a LARGER file.
              _writeTemp(tempDir.path, 'out.tmp', List.filled(100_000, 7));
              final f = File(targetPath);
              f.writeAsBytesSync(List.filled(100_000, 7));
              return f;
            },
      );
      final asset = await opt.prepare(src.path);
      expect(asset.optimized, isFalse);
      expect(asset.uploadPath, src.path);
    });

    test(
      'source beyond safety pixel limit -> MedicalImageTooLargeException',
      () async {
        final src = _writeTemp(
          tempDir.path,
          'huge.jpg',
          buildJpeg(12_000, 9_000),
        ); // 108MP > 96MP
        await expectLater(
          optimizer().prepare(src.path),
          throwsA(isA<MedicalImageTooLargeException>()),
        );
      },
    );

    test('size over threshold optimizes even when dims small', () async {
      int? calledW, calledH;
      final src = _writeTemp(tempDir.path, 'fat.jpg', [
        ...buildJpeg(1000, 800),
        ...List.filled(5 * 1024 * 1024, 0),
      ]);
      final opt = optimizer(
        onCompress: (w, h) {
          calledW = w;
          calledH = h;
        },
      );
      final asset = await opt.prepare(src.path);
      expect(asset.optimized, isTrue);
      expect(calledW, 1000); // no resize needed, but re-encode happened
      expect(calledH, 800);
    });

    test('optimized PNG has correct aspect target', () async {
      final src = _writeTemp(tempDir.path, 'p.png', [
        ...buildPng(5360, 7728),
        ...List.filled(500, 0),
      ]);
      final asset = await optimizer().prepare(src.path);
      final longest = math.max(asset.uploadWidth, asset.uploadHeight);
      expect(longest, lessThanOrEqualTo(MedicalImageOptimizer.maxLongEdge));
      final srcRatio = 5360 / 7728;
      final outRatio = asset.uploadWidth / asset.uploadHeight;
      expect((outRatio - srcRatio).abs(), lessThan(0.001));
    });
  });
}
