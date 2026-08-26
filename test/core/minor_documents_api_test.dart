import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/features/minors/data/minor_documents_api.dart';

class _PageRouteAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final isList = options.path.endsWith('/pages/');
    final isLab = options.path.endsWith('/lab-results/');
    final body = isList
        ? {
            'data': {
              'document_uuid': 'doc-1',
              'page_count': 1,
              'pages': <Object?>[],
            },
          }
        : isLab
        ? {
            'data': {
              'document_uuid': 'doc-1',
              'page_number': 2,
              'results': <Object?>[],
            },
          }
        : {
            'data': {'document_uuid': 'doc-1', 'page_number': 2},
          };
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test(
    'minor page methods use guardian-scoped routes and HTTP verbs',
    () async {
      final adapter = _PageRouteAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter;
      final api = MinorDocumentsApi(dio);

      await api.documentPages('minor-1', 'doc-1');
      await api.documentPageDetail('minor-1', 'doc-1', 2);
      await api.pageLabResults('minor-1', 'doc-1', 2);
      await api.confirmPageDate(
        'minor-1',
        'doc-1',
        2,
        date: DateTime(2026, 8, 26),
      );

      expect(adapter.requests.map((request) => request.path), [
        '/minors/minor-1/documents/doc-1/pages/',
        '/minors/minor-1/documents/doc-1/pages/2/',
        '/minors/minor-1/documents/doc-1/pages/2/lab-results/',
        '/minors/minor-1/documents/doc-1/pages/2/confirm-date/',
      ]);
      expect(adapter.requests.map((request) => request.method), [
        'GET',
        'GET',
        'GET',
        'POST',
      ]);
      expect(adapter.requests.last.data, {'date': '2026-08-26'});
    },
  );
}
