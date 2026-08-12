import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/features/identity/data/identity_image_part.dart';

void main() {
  group('detectIdentityImageFormat', () {
    test('detects JPEG from FF D8 FF magic', () {
      final bytes = Uint8List.fromList([
        0xff,
        0xd8,
        0xff,
        0xe0,
        0x00,
        0x10,
        0x4a,
        0x46,
        0x49,
        0x46,
        0x00,
        0x01,
      ]);
      expect(detectIdentityImageFormat(bytes), IdentityImageFormat.jpeg);
    });

    test('detects PNG from 89 50 4E 47 magic', () {
      final bytes = Uint8List.fromList([
        0x89,
        0x50,
        0x4e,
        0x47,
        0x0d,
        0x0a,
        0x1a,
        0x0a,
        0x00,
        0x00,
        0x00,
        0x0d,
      ]);
      expect(detectIdentityImageFormat(bytes), IdentityImageFormat.png);
    });

    test('rejects short buffers', () {
      expect(
        detectIdentityImageFormat(Uint8List.fromList([0xff, 0xd8])),
        isNull,
      );
      expect(detectIdentityImageFormat(Uint8List(0)), isNull);
    });

    test('rejects non-JPEG/PNG (GIF/HEIC/text)', () {
      expect(
        detectIdentityImageFormat(
          Uint8List.fromList([
            0x47,
            0x49,
            0x46,
            0x38,
            0x39,
            0x61,
            0x01,
            0x00,
            0x01,
            0x00,
            0x00,
            0x00,
          ]),
        ),
        isNull,
      );
      expect(
        detectIdentityImageFormat(Uint8List.fromList('hello world'.codeUnits)),
        isNull,
      );
    });
  });

  group('identityImagePart', () {
    late Directory dir;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('pmdap_img_part');
    });

    tearDown(() {
      dir.deleteSync(recursive: true);
    });

    test('JPEG -> front.jpg + image/jpeg', () async {
      final file = File('${dir.path}/scan_page_1.jpg')
        ..writeAsBytesSync(const <int>[
          0xff,
          0xd8,
          0xff,
          0xe0,
          0x00,
          0x10,
          0x4a,
          0x46,
          0x49,
          0x46,
          0x00,
          0x01,
          0xff,
          0xd9,
        ]);
      final part = await identityImagePart(file.path, side: 'front');
      expect(part.filename, 'front.jpg');
      expect(part.contentType.mimeType, 'image/jpeg');
    });

    test('PNG renamed to .jpg is still front.png + image/png', () async {
      // A PNG file whose NAME ends in .jpg must be detected from magic bytes,
      // never from the extension.
      final file = File('${dir.path}/front.jpg')
        ..writeAsBytesSync(const <int>[
          0x89,
          0x50,
          0x4e,
          0x47,
          0x0d,
          0x0a,
          0x1a,
          0x0a,
          0x00,
          0x00,
          0x00,
          0x00,
          0x49,
          0x45,
          0x4e,
          0x44,
          0xae,
          0x42,
          0x60,
          0x82,
        ]);
      final part = await identityImagePart(file.path, side: 'front');
      expect(part.filename, 'front.png');
      expect(part.contentType.mimeType, 'image/png');
    });

    test('back side -> back.jpg / back.png', () async {
      final jpeg = File('${dir.path}/b.jpg')
        ..writeAsBytesSync(const <int>[
          0xff,
          0xd8,
          0xff,
          0xe0,
          0x00,
          0x10,
          0x4a,
          0x46,
          0x49,
          0x46,
          0x00,
          0x01,
          0xff,
          0xd9,
        ]);
      final part = await identityImagePart(jpeg.path, side: 'back');
      expect(part.filename, 'back.jpg');
    });

    test('unsupported bytes throw IdentityImageException', () async {
      final file = File('${dir.path}/scan.txt')
        ..writeAsBytesSync('not an image'.codeUnits);
      expect(
        () => identityImagePart(file.path, side: 'front'),
        throwsA(
          isA<IdentityImageException>().having(
            (e) => e.code,
            'code',
            'unsupported_format',
          ),
        ),
      );
    });
  });

  group('identityMultipartFile', () {
    test('builds a MultipartFile with explicit content type', () async {
      final dir = await Directory.systemTemp.createTemp('pmdap_mf');
      addTearDown(() => dir.deleteSync(recursive: true));
      final png = File('${dir.path}/photo.png')
        ..writeAsBytesSync(const <int>[
          0x89,
          0x50,
          0x4e,
          0x47,
          0x0d,
          0x0a,
          0x1a,
          0x0a,
          0x00,
          0x00,
          0x00,
          0x00,
          0x49,
          0x45,
          0x4e,
          0x44,
          0xae,
          0x42,
          0x60,
          0x82,
        ]);

      final part = await identityMultipartFile(png.path, side: 'front');

      expect(part.filename, 'front.png');
      expect(part.contentType?.mimeType, 'image/png');
      // Content type is NOT null and NOT octet-stream — it is explicit.
      expect(part.contentType, isNotNull);
      expect(part.contentType?.mimeType, isNot('application/octet-stream'));
    });
  });
}
