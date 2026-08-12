import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

/// Supported identity image formats.
enum IdentityImageFormat { jpeg, png }

/// Thrown when a local identity image is not a readable JPEG/PNG.
///
/// Carries a stable [code] ('unsupported_format') so the UI can show a
/// localized message instead of a raw technical error.
class IdentityImageException implements Exception {
  const IdentityImageException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'IdentityImageException($code)';
}

/// A local identity image prepared for multipart upload: correct filename
/// extension plus an explicit MIME content type.
class IdentityImagePart {
  const IdentityImagePart({
    required this.path,
    required this.filename,
    required this.contentType,
  });

  final String path;
  final String filename;
  final MediaType contentType;
}

/// Detect the real image format from magic header bytes.
///
/// Accepts JPEG and PNG only. Never trusts the filename extension — a PNG
/// renamed to `.jpg` is still detected as PNG and sent as `image/png`.
IdentityImageFormat? detectIdentityImageFormat(Uint8List bytes) {
  if (bytes.length < 8) return null;
  // JPEG: FF D8 FF
  if (bytes[0] == 0xff && bytes[1] == 0xd8 && bytes[2] == 0xff) {
    return IdentityImageFormat.jpeg;
  }
  // PNG: 89 50 4E 47 0D 0A 1A 0A
  if (bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4e &&
      bytes[3] == 0x47 &&
      bytes[4] == 0x0d &&
      bytes[5] == 0x0a &&
      bytes[6] == 0x1a &&
      bytes[7] == 0x0a) {
    return IdentityImageFormat.png;
  }
  return null;
}

/// Inspect a local identity image (magic header) and prepare it for upload.
///
/// Returns a part with a correct filename (`front.jpg` / `front.png`) and an
/// explicit `image/jpeg` / `image/png` content type. Throws
/// [IdentityImageException] when the file is not a real JPEG or PNG.
Future<IdentityImagePart> identityImagePart(
  String path, {
  String side = 'image',
}) async {
  final raf = File(path).openSync();
  try {
    final head = raf.readSync(12);
    final format = detectIdentityImageFormat(Uint8List.fromList(head));
    if (format == null) {
      throw const IdentityImageException(
        'unsupported_format',
        'Identity images must be JPEG or PNG.',
      );
    }
    final ext = format == IdentityImageFormat.jpeg ? 'jpg' : 'png';
    final mime = format == IdentityImageFormat.jpeg
        ? 'image/jpeg'
        : 'image/png';
    return IdentityImagePart(
      path: path,
      filename: '$side.$ext',
      contentType: MediaType.parse(mime),
    );
  } finally {
    raf.closeSync();
  }
}

/// Build a Dio [MultipartFile] for an identity image with an explicit content
/// type and a correct filename.
///
/// The SAME helper must be used for extraction, final submit and replacement
/// so extraction and submission can never disagree about the image format.
Future<MultipartFile> identityMultipartFile(
  String path, {
  String side = 'image',
}) async {
  final part = await identityImagePart(path, side: side);
  return MultipartFile.fromFile(
    part.path,
    filename: part.filename,
    contentType: part.contentType,
  );
}
