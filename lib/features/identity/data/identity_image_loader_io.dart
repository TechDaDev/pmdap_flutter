import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

Future<Uint8List> readIdentityImageHeader(String path) async {
  final handle = await File(path).open();
  try {
    return Uint8List.fromList(await handle.read(12));
  } finally {
    await handle.close();
  }
}

Future<MultipartFile> buildIdentityMultipartFile({
  required String path,
  required String filename,
  required MediaType contentType,
}) =>
    MultipartFile.fromFile(path, filename: filename, contentType: contentType);
