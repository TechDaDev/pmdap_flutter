import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/api/api_exception.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/features/auth/data/registration_api.dart';
import 'package:pmdap_mobile/features/auth/data/registration_models.dart';

/// Captures the exact request Dio would send and returns a canned response.
class _CaptureAdapter implements HttpClientAdapter {
  RequestOptions? captured;
  int status = 201;
  String body = '';

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    captured = options;
    return ResponseBody.fromString(
      body.isEmpty
          ? '{"data": {"uuid": "u1", "email": "x@example.com", '
                '"role": "PATIENT", "status": "ACTIVE"}}'
          : body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

const _pngBytes = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, //
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, //
  0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x62, 0x00, 0x01, 0x00, 0x00, //
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, //
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
];

RegistrationIdentityInput _identity() => RegistrationIdentityInput(
  jobId: 'job-1',
  jobToken: 'token-1',
  documentType: IdentityDocumentType.unifiedNationalCard,
  documentNumber: '123456789012',
  nationalCardNumber: '123456789012',
  familyNumber: 'SYNTHFAM123456',
  uniqueCardBodyNumber: 'G12345678',
  name: 'SYNTHNAME',
  fatherName: 'SYNTHFATHER',
  grandfatherName: 'SYNTHGRAND',
  motherName: 'SYNTHMOTHER',
  confirmation: true,
  dateOfBirth: DateTime(1990, 5, 17),
  sex: Sex.male,
  nationality: 'IQ',
  bloodGroup: BloodGroup.oPos,
);

void main() {
  late _CaptureAdapter adapter;
  late Dio dio;
  late RegistrationApi api;

  setUp(() {
    adapter = _CaptureAdapter();
    dio = Dio()..httpClientAdapter = adapter;
    api = RegistrationApi(dio);
  });

  test(
    'registerScanFirst sends exact JSON: account + capability, NO images',
    () async {
      await api.registerScanFirst(
        email: 'synth@example.com',
        phone: '07700000000',
        password: 'StrongPass123!',
        governorate: 'BAGHDAD',
        sessionToken: 'session-token-1',
        identity: _identity(),
      );

      expect(adapter.captured, isNotNull);
      final path = adapter.captured!.path;
      expect(path, '/auth/register/');
      expect(adapter.captured!.method, 'POST');

      final data = adapter.captured!.data as Map<String, dynamic>;
      // Account fields.
      expect(data['email'], 'synth@example.com');
      expect(data['password'], 'StrongPass123!');
      expect(data['phone'], '07700000000');
      expect(data['governorate'], 'BAGHDAD');
      // M31B session capability (the client never sends a verified flag).
      expect(data['registration_session'], 'session-token-1');
      expect(data.containsKey('email_verified'), isFalse);
      expect(data.containsKey('verified'), isFalse);
      // No image bytes anywhere in the complete request.
      expect(data.containsKey('front_image'), isFalse);
      expect(data.containsKey('back_image'), isFalse);

      final id = data['registration_identity'] as Map<String, dynamic>;
      expect(id, {
        'job_id': 'job-1',
        'job_token': 'token-1',
        'document_type': 'UNIFIED_NATIONAL_CARD',
        'document_number': '123456789012',
        'national_card_number': '123456789012',
        'family_number': 'SYNTHFAM123456',
        'unique_card_body_number': 'G12345678',
        'name': 'SYNTHNAME',
        'father_name': 'SYNTHFATHER',
        'grandfather_name': 'SYNTHGRAND',
        'mother_name': 'SYNTHMOTHER',
        'confirmation': true,
        'date_of_birth': '1990-05-17',
        'sex': 'MALE',
        'nationality': 'IQ',
        'blood_group': 'O+',
      });
    },
  );

  test(
    'startExtraction sends multipart + session token header, never credentials',
    () async {
      final dir = await Directory.systemTemp.createTemp('reg_api_test');
      final file = File('${dir.path}/front.png');
      await file.writeAsBytes(Uint8List.fromList(_pngBytes));

      await api.startExtraction(
        sessionToken: 'session-token-1',
        frontPath: file.path,
        backPath: file.path,
      );

      expect(adapter.captured, isNotNull);
      expect(adapter.captured!.path, '/auth/register/identity/extract/');
      expect(
        adapter.captured!.headers['X-Registration-Session-Token'],
        'session-token-1',
      );
      expect(adapter.captured!.data, isA<FormData>());
      final form = adapter.captured!.data as FormData;
      final fields = form.fields.map((f) => f.key).toSet();
      expect(fields, contains('document_type'));
      expect(
        form.files.map((f) => f.key),
        containsAll(['front_image', 'back_image']),
      );
      // The extraction request carries NO account credentials.
      expect(fields.contains('password'), isFalse);
      expect(fields.contains('email'), isFalse);
    },
  );

  test('startEmailVerification sends account details to /email/start/',
      () async {
        adapter.body =
            '{"data": {"session_id": "s1", "session_token": "tok1", '
            '"masked_email": "s***y@example.com", "status": '
            '"PENDING_EMAIL_VERIFICATION", "email_verified": false, '
            '"expires_at": "2026-09-01T00:00:00Z"}}';
        final session = await api.startEmailVerification(
          email: 'synth.verify@example.com',
          phone: '07700000000',
          governorate: 'BAGHDAD',
        );
        expect(session.sessionToken, 'tok1');
        expect(session.maskedEmail, 's***y@example.com');
        expect(session.status, 'PENDING_EMAIL_VERIFICATION');
        final path = adapter.captured!.path;
        expect(path, '/auth/register/email/start/');
        expect(adapter.captured!.method, 'POST');
        final data = adapter.captured!.data as Map<String, dynamic>;
        expect(data['email'], 'synth.verify@example.com');
        expect(data['phone'], '07700000000');
        expect(data['governorate'], 'BAGHDAD');
        // No password on the account-details step.
        expect(data.containsKey('password'), isFalse);
      });

  test('verifyEmail sends session token + code only (no target choice)',
      () async {
        adapter.body =
            '{"data": {"session_id": "s1", "masked_email": "s***y@example.com", '
            '"status": "EMAIL_VERIFIED", "email_verified": true}}';
        final status = await api.verifyEmail(
          sessionToken: 'tok1',
          code: '123456',
        );
        expect(status.verified, isTrue);
        expect(adapter.captured!.path, '/auth/register/email/verify/');
        final data = adapter.captured!.data as Map<String, dynamic>;
        expect(data['session_token'], 'tok1');
        expect(data['code'], '123456');
        // The client can never supply a target or a verified flag.
        expect(data.containsKey('target'), isFalse);
        expect(data.containsKey('email'), isFalse);
        expect(data.containsKey('email_verified'), isFalse);
      });

  test('resendEmailVerification posts session token to /email/resend/',
      () async {
        adapter.body =
            '{"data": {"session_id": "s1", "masked_email": "s***y@example.com", '
            '"status": "PENDING_EMAIL_VERIFICATION", "email_verified": false, '
            '"resend_at": "2026-09-01T00:00:00Z"}}';
        final status = await api.resendEmailVerification(sessionToken: 'tok1');
        expect(status.resendAt, isNotNull);
        expect(adapter.captured!.path, '/auth/register/email/resend/');
        final data = adapter.captured!.data as Map<String, dynamic>;
        expect(data['session_token'], 'tok1');
      });

  test('getEmailVerificationStatus sends token in header, never URL',
      () async {
        adapter.body =
            '{"data": {"session_id": "s1", "masked_email": "s***y@example.com", '
            '"status": "PENDING_EMAIL_VERIFICATION", "email_verified": false}}';
        final status = await api.getEmailVerificationStatus(
          sessionToken: 'tok1',
        );
        expect(status.pendingVerification, isTrue);
        expect(adapter.captured!.path, '/auth/register/email/status/');
        expect(
          adapter.captured!.headers['X-Registration-Session-Token'],
          'tok1',
        );
      });

  test('maps backend error envelope to typed ApiException', () async {
    adapter.status = 400;
    adapter.body =
        '{"error":{"code":"validation_error","message":"Validation failed.",'
        '"details":{"email":["An account with this email already exists."]}}}';
    try {
      await api.registerScanFirst(
        email: 'synth@example.com',
        password: 'StrongPass123!',
        governorate: 'BAGHDAD',
        sessionToken: 'session-token-1',
        identity: _identity(),
      );
      fail('expected ApiException');
    } on ApiException catch (e) {
      expect(e.code, 'validation_error');
      expect(
        e.details['email'],
        contains('An account with this email already exists.'),
      );
    }
  });

  test('maps job-expired 410 code', () async {
    adapter.status = 410;
    adapter.body =
        '{"error":{"code":"registration_job_expired",'
        '"message":"Registration identity session has expired."}}';
    try {
      await api.registerScanFirst(
        email: 'synth@example.com',
        password: 'StrongPass123!',
        governorate: 'BAGHDAD',
        sessionToken: 'session-token-1',
        identity: _identity(),
      );
      fail('expected ApiException');
    } on ApiException catch (e) {
      expect(e.code, 'registration_job_expired');
    }
  });

  test('maps unverified-OCR 403 to registration_email_not_verified',
      () async {
        adapter.status = 403;
        adapter.body =
            '{"error":{"code":"registration_email_not_verified",'
            '"message":"Email verification is required."}}';
        final dir = await Directory.systemTemp.createTemp('reg_api_test');
        final file = File('${dir.path}/front.png');
        await file.writeAsBytes(Uint8List.fromList(_pngBytes));
        try {
          await api.startExtraction(
            sessionToken: 'unverified',
            frontPath: file.path,
          );
          fail('expected ApiException');
        } on ApiException catch (e) {
          expect(e.code, 'registration_email_not_verified');
          expect(e.isForbidden, isTrue);
        }
      });
}
