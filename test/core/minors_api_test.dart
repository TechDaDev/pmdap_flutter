import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/features/minors/data/minors_api.dart';

/// Captures the outgoing request so we can assert multipart contract fields.
class _CaptureAdapter implements HttpClientAdapter {
  RequestOptions? lastRequest;
  final Map<String, dynamic> body;

  _CaptureAdapter({required this.body});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      jsonEncode(body),
      201,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Future<File> _temp(String name) async {
  final dir = await Directory.systemTemp.createTemp('pmdap_minor_test');
  final f = File('${dir.path}/$name');
  await f.writeAsBytes([0xff, 0xd8, 0xff, 0xe0, 0, 0]);
  return f;
}

void main() {
  group('MinorsApi.create multipart contract', () {
    test('emits date_of_birth and conditional document fields', () async {
      final front = await _temp('front.jpg');
      final back = await _temp('back.jpg');
      final adapter = _CaptureAdapter(
        body: {
          'data': {
            'uuid': 'm1',
            'digital_id': 'PT-AAAA-BBBB-0001',
            'full_name': 'Child',
            'date_of_birth': '2015-08-20',
            'age': 10,
            'is_minor': true,
            'sex': 'UNSPECIFIED',
            'nationality': 'ZZ',
            'blood_group': 'O+',
            'identity_status': 'UNVERIFIED',
          },
        },
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter;
      final api = MinorsApi(dio);

      await api.create(
        MinorCreateSubmission(
          fullName: 'Child',
          dateOfBirth: DateTime(2015, 8, 20),
          sex: Sex.unspecified,
          nationality: 'IQ',
          relationship: Relationship.father,
          documentType: IdentityDocumentType.birthDocument,
          documentNumber: 'DOC123',
          issuingCountry: 'IQ',
          frontPath: front.path,
          frontFilename: 'front.jpg',
          backPath: back.path,
          backFilename: 'back.jpg',
        ),
        idempotencyKey: '11111111-2222-4333-8444-555555555555',
      );

      final form = adapter.lastRequest!.data as FormData;
      final fields = <String, String>{
        for (final e in form.fields) e.key: e.value,
      };
      // The critical DOB fix: non-empty date_of_birth in the multipart body.
      expect(fields['date_of_birth'], '2015-08-20');
      expect(fields['document_type'], 'BIRTH_DOCUMENT');
      expect(fields['issuing_country'], 'IQ');
      expect(
        adapter.lastRequest!.headers['Idempotency-Key'],
        '11111111-2222-4333-8444-555555555555',
      );
    });

    test('national card submission omits evidence when optional', () async {
      final front = await _temp('front.jpg');
      final back = await _temp('back.jpg');
      final adapter = _CaptureAdapter(
        body: {
          'data': {
            'uuid': 'm1',
            'digital_id': 'PT-AAAA-BBBB-0001',
            'full_name': 'Child',
            'age': 10,
            'is_minor': true,
            'identity_status': 'UNVERIFIED',
          },
        },
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter;
      final api = MinorsApi(dio);

      await api.create(
        MinorCreateSubmission(
          fullName: 'Child',
          dateOfBirth: DateTime(2015, 8, 20),
          sex: Sex.unspecified,
          nationality: 'IQ',
          relationship: Relationship.father,
          documentType: IdentityDocumentType.unifiedNationalCard,
          documentNumber: 'DOC123',
          nationalNumber: 'NN123',
          issuingCountry: 'IQ',
          frontPath: front.path,
          frontFilename: 'front.jpg',
          backPath: back.path,
          backFilename: 'back.jpg',
          // No evidence: father/mother → optional, must NOT be sent.
        ),
        idempotencyKey: 'k',
      );

      final form = adapter.lastRequest!.data as FormData;
      final keys = form.fields.map((e) => e.key).toSet();
      expect(keys.contains('evidence_type'), isFalse);
      expect(keys.contains('evidence_file'), isFalse);
      expect(form.fields.any((e) => e.key == 'national_number'), isTrue);
    });
  });
}
