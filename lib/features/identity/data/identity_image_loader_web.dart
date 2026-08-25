import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

Future<Uint8List> _readBlob(String path) async {
  final response = await Dio().get<List<int>>(
    path,
    options: Options(responseType: ResponseType.bytes),
  );
  return Uint8List.fromList(response.data ?? const <int>[]);
}

Future<Uint8List> readIdentityImageHeader(String path) async {
  final bytes = await _readBlob(path);
  return Uint8List.sublistView(bytes, 0, bytes.length.clamp(0, 12));
}

Future<MultipartFile> buildIdentityMultipartFile({
  required String path,
  required String filename,
  required MediaType contentType,
}) async => MultipartFile.fromBytes(
  await _readBlob(path),
  filename: filename,
  contentType: contentType,
);
