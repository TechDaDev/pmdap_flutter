import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/guardian_relationship_summary.dart';
import 'package:pmdap_mobile/features/minors/data/minors_api.dart';

/// Captures the outgoing request so we can assert multipart contract fields.
class _CaptureAdapter implements HttpClientAdapter {
  RequestOptions? lastRequest;
  final Map<String, dynamic> body;
  int calls = 0;

  _CaptureAdapter({required this.body});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls++;
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
  await f.writeAsBytes([0xff, 0xd8, 0xff, 0xe0, 0, 0, 0, 0]);
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
          firstName: 'Child',
          fatherName: 'Synthetic Father',
          grandfatherName: 'Synthetic Grandfather',
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
          firstName: 'Child',
          fatherName: 'Synthetic Father',
          grandfatherName: 'Synthetic Grandfather',
          dateOfBirth: DateTime(2015, 8, 20),
          sex: Sex.unspecified,
          nationality: 'IQ',
          relationship: Relationship.father,
          documentType: IdentityDocumentType.unifiedNationalCard,
          extractionJobId: '11111111-2222-4333-8444-555555555555',
          issuingCountry: 'IQ',
          // No evidence: father/mother → optional, must NOT be sent.
        ),
        idempotencyKey: 'k',
      );

      final form = adapter.lastRequest!.data as FormData;
      final keys = form.fields.map((e) => e.key).toSet();
      expect(keys.contains('evidence_type'), isFalse);
      expect(keys.contains('evidence_file'), isFalse);
      final fields = <String, String>{
        for (final entry in form.fields) entry.key: entry.value,
      };
      expect(fields['name'], 'Child');
      expect(fields['father_name'], 'Synthetic Father');
      expect(fields['grandfather_name'], 'Synthetic Grandfather');
      expect(
        fields['extraction_job_id'],
        '11111111-2222-4333-8444-555555555555',
      );
      expect(keys.contains('national_number'), isFalse);
      expect(keys.contains('family_number'), isFalse);
      expect(keys.contains('unique_card_body_number'), isFalse);
      expect(form.files, isEmpty);
    });
  });

  group('guardian relationship contract', () {
    Map<String, dynamic> relationshipJson({String status = 'PENDING'}) => {
      'uuid': 'rel-1',
      'minor_patient': {
        'uuid': 'minor-1',
        'digital_id': 'PT-SAFE-0001',
        'full_name': 'Synthetic Child',
      },
      'relationship': 'MOTHER',
      'status': status,
      'can_revoke': status == 'VERIFIED',
      'created_at': '2026-08-25T10:00:00Z',
    };

    test('parses every supported state and unknown fallback', () {
      for (final entry in {
        'PENDING': GuardianRelationshipStatus.pending,
        'VERIFIED': GuardianRelationshipStatus.verified,
        'REJECTED': GuardianRelationshipStatus.rejected,
        'REVOKED': GuardianRelationshipStatus.revoked,
        'FUTURE_STATE': GuardianRelationshipStatus.unknown,
      }.entries) {
        final value = GuardianRelationshipSummary.fromJson(
          relationshipJson(status: entry.key),
        );
        expect(value.status, entry.value);
        expect(value.child.fullName, 'Synthetic Child');
      }
    });

    test('list parses safe paginated response', () async {
      final adapter = _CaptureAdapter(
        body: {
          'data': {
            'count': 1,
            'next': null,
            'previous': null,
            'results': [relationshipJson(status: 'REJECTED')],
          },
        },
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter;

      final page = await MinorsApi(dio).relationships();

      expect(page.results.single.status, GuardianRelationshipStatus.rejected);
      expect(adapter.lastRequest!.path, '/guardian-relationships/');
    });

    test(
      'revoke sends exactly one request with no child identity fields',
      () async {
        final adapter = _CaptureAdapter(body: {'data': relationshipJson()});
        final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
          ..httpClientAdapter = adapter;

        await MinorsApi(dio).revokeRelationship('rel-1');

        expect(adapter.calls, 1);
        expect(
          adapter.lastRequest!.path,
          '/minors/relationships/rel-1/revoke/',
        );
        expect(adapter.lastRequest!.data, {'reason': 'Revoked by guardian'});
      },
    );
  });
}
