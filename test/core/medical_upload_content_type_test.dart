import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/features/documents/data/documents_api.dart';

/// The medical upload must carry an explicit, content-accurate MIME type.
/// Dio would otherwise send application/octet-stream, which the backend
/// rejects ("Medical file must be PDF, JPEG, or PNG").
void main() {
  late Directory tmp;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('pmdap_med');
  });

  tearDown(() {
    tmp.deleteSync(recursive: true);
  });

  test('detects JPEG magic bytes', () async {
    final f = File('${tmp.path}/scan.jpg');
    f.writeAsBytesSync([0xff, 0xd8, 0xff, 0xe0, 1, 2, 3]);
    final type = medicalUploadContentType(f.path);
    expect(type, isNotNull);
    expect(type!.mimeType, 'image/jpeg');
  });

  test('detects PNG magic bytes', () async {
    final f = File('${tmp.path}/scan.png');
    f.writeAsBytesSync([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 1, 2]);
    final type = medicalUploadContentType(f.path);
    expect(type!.mimeType, 'image/png');
  });

  test('detects PDF magic bytes', () async {
    final f = File('${tmp.path}/scan.pdf');
    f.writeAsBytesSync([0x25, 0x50, 0x44, 0x46, 0x2d, 0x31, 0x2e, 0x34]);
    final type = medicalUploadContentType(f.path);
    expect(type!.mimeType, 'application/pdf');
  });

  test(
    'returns null for unknown content (backend will reject cleanly)',
    () async {
      final f = File('${tmp.path}/scan.bin');
      f.writeAsBytesSync([0xde, 0xad, 0xbe, 0xef, 1, 2, 3, 4]);
      expect(medicalUploadContentType(f.path), isNull);
    },
  );

  test('returns null for missing file', () async {
    expect(medicalUploadContentType('${tmp.path}/does_not_exist.jpg'), isNull);
  });
}
