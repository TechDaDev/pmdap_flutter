import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/api/api_exception.dart';
import 'package:pmdap_mobile/core/constants/api_paths.dart';
import 'package:pmdap_mobile/features/patient/data/patient_api.dart';

/// Captures the outgoing request; returns a canned [ResponseBody].
class _CaptureAdapter implements HttpClientAdapter {
  _CaptureAdapter({required this.body, this.statusCode = 200, this.bytes});

  RequestOptions? lastRequest;
  final Map<String, dynamic> body;
  final int statusCode;
  final Uint8List? bytes;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    if (bytes != null) {
      return ResponseBody.fromBytes(
        bytes!,
        statusCode,
        headers: {
          Headers.contentTypeHeader: ['image/png'],
        },
      );
    }
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({force = false}) {}
}

Map<String, dynamic> _profileJson({String? avatarUrl}) => {
  'uuid': 'p1',
  'digital_id': 'PT-AAAA-BBBB-0001',
  'full_name': 'Test User',
  'avatar_url': avatarUrl,
};

void main() {
  group('PatientApi avatar', () {
    test('fetchAvatar returns raw bytes via authenticated path', () async {
      final adapter = _CaptureAdapter(
        body: const {},
        bytes: Uint8List.fromList([0x89, 0x50, 0x4e, 0x47]),
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter;
      final api = PatientApi(dio);

      final bytes = await api.fetchAvatar();

      expect(adapter.lastRequest!.path, ApiPaths.patientAvatar);
      expect(adapter.lastRequest!.responseType, ResponseType.bytes);
      expect(bytes, [0x89, 0x50, 0x4e, 0x47]);
    });

    test('fetchAvatar 404 maps to ApiException (caller falls back)', () async {
      final adapter = _CaptureAdapter(body: const {}, statusCode: 404);
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter;
      final api = PatientApi(dio);

      expect(() => api.fetchAvatar(), throwsA(isA<ApiException>()));
    });

    test('upload avatar sends multipart PATCH with avatar field', () async {
      final adapter = _CaptureAdapter(
        body: {'data': _profileJson(avatarUrl: '/api/v1/patients/me/avatar/')},
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter;
      final api = PatientApi(dio);

      final dir = await Directory.systemTemp.createTemp('pmdap_avatar_test');
      final file = File('${dir.path}/avatar.png');
      await file.writeAsBytes([0x89, 0x50, 0x4e, 0x47]);

      final profile = await api.updateAvatar(
        filePath: file.path,
        filename: 'avatar.png',
      );

      expect(adapter.lastRequest!.method, 'PATCH');
      expect(adapter.lastRequest!.path, ApiPaths.patientsMe);
      expect(adapter.lastRequest!.data, isA<FormData>());
      final form = adapter.lastRequest!.data as FormData;
      expect(form.files.any((f) => f.key == 'avatar'), isTrue);
      expect(profile.avatarUrl, '/api/v1/patients/me/avatar/');
    });

    test('remove avatar sends JSON PATCH with avatar:null', () async {
      final adapter = _CaptureAdapter(body: {'data': _profileJson()});
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter;
      final api = PatientApi(dio);

      final profile = await api.removeAvatar();

      expect(adapter.lastRequest!.method, 'PATCH');
      expect(adapter.lastRequest!.path, ApiPaths.patientsMe);
      expect(adapter.lastRequest!.data, {'avatar': null});
      expect(profile.avatarUrl, isNull);
    });

    test('fetchAvatar 503 maps to ApiException (caller falls back)', () async {
      final adapter = _CaptureAdapter(body: const {}, statusCode: 503);
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter;
      final api = PatientApi(dio);

      expect(() => api.fetchAvatar(), throwsA(isA<ApiException>()));
    });
  });
}
