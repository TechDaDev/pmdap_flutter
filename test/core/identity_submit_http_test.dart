import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/api/api_exception.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/features/identity/data/identity_api.dart';

/// Captures the exact request body Dio would send and returns a canned 201.
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
          ? '{"data": {"uuid": "id-1", "document_type": '
                '"UNIFIED_NATIONAL_CARD", "verification_status": "PENDING", '
                '"status": "CURRENT"}}'
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

void main() {
  late _CaptureAdapter adapter;
  late Dio dio;
  late IdentityApi api;

  setUp(() {
    adapter = _CaptureAdapter();
    dio = Dio()..httpClientAdapter = adapter;
    api = IdentityApi(dio);
  });

  IdentitySubmission jobSubmission({
    String documentNumber = 'Z99999999',
    String jobId = 'job-1',
    IdentityDocumentType type = IdentityDocumentType.unifiedNationalCard,
  }) {
    return IdentitySubmission(
      documentType: type,
      documentNumber: documentNumber,
      nationalNumber: '012345678901234',
      familyNumber: '1234',
      issuingCountry: 'IQ',
      source: ExtractionJob(jobId: jobId),
    );
  }

  test(
    'ExtractionJob submit sends JSON with extraction_job_id, no images',
    () async {
      await api.submit(jobSubmission(documentNumber: 'CORRECTED-1'));

      final data = adapter.captured!.data as Map<String, dynamic>;
      expect(data['document_type'], 'UNIFIED_NATIONAL_CARD');
      expect(data['document_number'], 'CORRECTED-1');
      expect(data['national_number'], '012345678901234');
      expect(data['family_number'], '1234');
      expect(data['issuing_country'], 'IQ');
      expect(data['extraction_job_id'], 'job-1');
      // NO image bytes / file fields on the single-upload path.
      expect(data.containsKey('front_image'), isFalse);
      expect(data.containsKey('back_image'), isFalse);
    },
  );

  test('passport job submit sends dates + job id', () async {
    await api.submit(
      jobSubmission(
        type: IdentityDocumentType.passport,
        documentNumber: 'P1234',
        jobId: 'job-p',
      ),
    );

    final data = adapter.captured!.data as Map<String, dynamic>;
    expect(data['document_type'], 'PASSPORT');
    expect(data['extraction_job_id'], 'job-p');
  });

  test('ExistingImages submit sends multipart with image parts', () async {
    final dir = await Directory.systemTemp.createTemp('pmdap_http');
    addTearDown(() => dir.deleteSync(recursive: true));
    final front = File('${dir.path}/front.png')..writeAsBytesSync(_pngBytes);
    final back = File('${dir.path}/back.png')..writeAsBytesSync(_pngBytes);

    await api.submit(
      IdentitySubmission(
        documentType: IdentityDocumentType.unifiedNationalCard,
        documentNumber: 'CARD-1',
        nationalNumber: 'N',
        familyNumber: 'F',
        issuingCountry: 'IQ',
        source: ExistingImages(frontPath: front.path, backPath: back.path),
      ),
    );

    final data = adapter.captured!.data as FormData;
    final partKeys = data.files.map((e) => e.key).toSet();
    expect(partKeys, containsAll(<String>['front_image', 'back_image']));
    expect(partKeys.contains('extraction_job_id'), isFalse);
  });

  test('replacement with job sends JSON to replace URL', () async {
    await api.replace('old-1', jobSubmission());

    expect(adapter.captured!.path, '/identity-documents/old-1/replace/');
    final data = adapter.captured!.data as Map<String, dynamic>;
    expect(data['extraction_job_id'], 'job-1');
    expect(data.containsKey('front_image'), isFalse);
  });

  test('job expired/consumed maps 409 to ApiException, not generic', () async {
    adapter.status = 409;
    adapter.body =
        '{"error": {"code": "extraction_job_conflict", '
        '"message": "Identity extraction job cannot be finalized.", '
        '"details": {}}}';

    expect(
      () => api.submit(jobSubmission()),
      throwsA(
        isA<ApiException>()
            .having((e) => e.code, 'code', 'extraction_job_conflict')
            .having((e) => e.statusCode, 'statusCode', 409),
      ),
    );
  });

  test('job not found maps 404 to ApiException', () async {
    adapter.status = 404;
    adapter.body =
        '{"error": {"code": "extraction_job_not_found", '
        '"message": "Identity extraction job does not exist or has expired.", '
        '"details": {}}}';

    expect(
      () => api.submit(jobSubmission()),
      throwsA(
        isA<ApiException>()
            .having((e) => e.code, 'code', 'extraction_job_not_found')
            .having((e) => e.statusCode, 'statusCode', 404),
      ),
    );
  });

  test('network error maps to network ApiException', () async {
    adapter.status = 0;
    adapter.body = '';
    dio.httpClientAdapter = _FailingAdapter();

    expect(
      () => api.submit(jobSubmission()),
      throwsA(
        isA<ApiException>().having((e) => e.isNetwork, 'isNetwork', true),
      ),
    );
  });
}

class _FailingAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    throw DioException.connectionError(
      requestOptions: options,
      reason: 'connection failed',
    );
  }

  @override
  void close({bool force = false}) {}
}
