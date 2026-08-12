// Faithful reproduction of the multipart parts the app sends for identity
// extraction vs. final submit, WITHOUT touching the network.
//
// Prints, per part:  field  |  filename  |  contentType
//
// This mirrors exactly what IdentityApi.extract() / submit() build via
// MultipartFile.fromFile() in dio 5.11.
//
// Run:
//   dart run tool/repro_multipart.dart
import 'dart:io';

import 'package:dio/dio.dart';

void main() async {
  final dir = await Directory.systemTemp.createTemp('pmdap_repro');
  try {
    // JPEG bytes (minimal, ends with FF D9 like the backend terminator check).
    final jpgBytes = <int>[
      0xff, 0xd8, 0xff, 0xe0, 0x00, 0x10, 0x4a, 0x46, 0x49, 0x46, //
      0x00, 0x01, 0xff, 0xd9,
    ];
    // PNG bytes (signature + minimal IEND terminator the backend requires).
    final pngBytes = <int>[
      0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, //
      0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4e, 0x44, 0xae, 0x42, 0x60, 0x82,
    ];

    // 1. Scanner output (what a physical scan produces).
    final scanFront = File('${dir.path}/scan_page_123_0.jpg')
      ..writeAsBytesSync(jpgBytes);

    // 2. Gallery pick of a PNG (allowed by _supportsImage).
    final pickPng = File('${dir.path}/gallery_pick.png')
      ..writeAsBytesSync(pngBytes);

    // 3. File with NO extension (edge case).
    final noExt = File('${dir.path}/camera_raw_capture')
      ..writeAsBytesSync(jpgBytes);

    void part(String field, MultipartFile f) {
      stdout.writeln(
        '  $field  |  ${f.filename ?? '<null>'}  |  '
        '${f.contentType ?? '<null>'}',
      );
    }

    stdout.writeln(
      'EXTRACTION path (MultipartFile.fromFile(path), '
      'no explicit filename/contentType):',
    );
    var form = FormData.fromMap({
      'document_type': 'UNIFIED_NATIONAL_CARD',
      'front_image': await MultipartFile.fromFile(scanFront.path),
      'back_image': await MultipartFile.fromFile(scanFront.path),
    });
    for (final e in form.files) {
      part(e.key, e.value);
    }

    stdout.writeln();
    stdout.writeln(
      'FINAL SUBMIT path (filename hardcoded front.jpg/back.jpg):',
    );
    form = FormData.fromMap({
      'document_type': 'UNIFIED_NATIONAL_CARD',
      'document_number': 'x',
      'national_number': 'y',
      'family_number': 'z',
      'issuing_country': 'IQ',
      'front_image': await MultipartFile.fromFile(
        scanFront.path,
        filename: 'front.jpg',
      ),
      'back_image': await MultipartFile.fromFile(
        scanFront.path,
        filename: 'back.jpg',
      ),
    });
    for (final e in form.files) {
      part(e.key, e.value);
    }

    stdout.writeln();
    stdout.writeln(
      'PNG gallery pick through FINAL SUBMIT path '
      '(front.jpg hardcoded):',
    );
    form = FormData.fromMap({
      'document_type': 'UNIFIED_NATIONAL_CARD',
      'front_image': await MultipartFile.fromFile(
        pickPng.path,
        filename: 'front.jpg',
      ),
      'back_image': await MultipartFile.fromFile(
        pickPng.path,
        filename: 'back.jpg',
      ),
    });
    for (final e in form.files) {
      part(e.key, e.value);
    }

    stdout.writeln();
    stdout.writeln(
      'EXTRACTION path with NO-EXTENSION file '
      '(basename used):',
    );
    form = FormData.fromMap({
      'document_type': 'UNIFIED_NATIONAL_CARD',
      'front_image': await MultipartFile.fromFile(noExt.path),
    });
    for (final e in form.files) {
      part(e.key, e.value);
    }

    stdout.writeln();
    stdout.writeln(
      'FINAL SUBMIT path with no-extension file '
      '(front.jpg hardcoded):',
    );
    form = FormData.fromMap({
      'document_type': 'UNIFIED_NATIONAL_CARD',
      'front_image': await MultipartFile.fromFile(
        noExt.path,
        filename: 'front.jpg',
      ),
    });
    for (final e in form.files) {
      part(e.key, e.value);
    }
  } finally {
    dir.deleteSync(recursive: true);
  }
}
