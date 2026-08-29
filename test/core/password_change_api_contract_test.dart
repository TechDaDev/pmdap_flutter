import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/features/auth/data/password_change_api.dart';

class _CaptureAdapter implements HttpClientAdapter {
  RequestOptions? captured;
  String body = '{}';
  int status = 200;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    captured = options;
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _CaptureAdapter adapter;
  late PasswordChangeApi api;

  setUp(() {
    adapter = _CaptureAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    api = PasswordChangeApi(dio);
  });

  test('request sends current password only and parses cooldown', () async {
    adapter.body = jsonEncode({
      'data': {
        'message': 'A verification code has been sent to your email.',
        'resend_after_seconds': 60,
      },
    });

    final seconds = await api.request(currentPassword: 'Correct-Horse-42!');

    expect(adapter.captured!.path, '/auth/password-change/request/');
    expect(adapter.captured!.method, 'POST');
    expect(adapter.captured!.data, {'current_password': 'Correct-Horse-42!'});
    expect(seconds, 60);
  });

  test('verify sends code and returns opaque capability', () async {
    adapter.body = jsonEncode({
      'data': {
        'capability': 'opaque-change-capability',
        'expires_at': '2026-08-29T13:00:00Z',
      },
    });

    final result = await api.verify(code: '123456');

    expect(adapter.captured!.path, '/auth/password-change/verify/');
    expect(adapter.captured!.data, {'code': '123456'});
    expect(result.capability, 'opaque-change-capability');
    expect(result.expiresAt, DateTime.parse('2026-08-29T13:00:00Z'));
  });

  test(
    'confirm sends capability and password, parses fresh token pair',
    () async {
      adapter.body = jsonEncode({
        'data': {
          'message': 'Password changed.',
          'access': 'fresh-access',
          'refresh': 'fresh-refresh',
        },
      });

      final pair = await api.confirm(
        capability: 'opaque-change-capability',
        newPassword: 'Fresh-Correct-Horse-84!',
      );

      expect(adapter.captured!.path, '/auth/password-change/confirm/');
      expect(adapter.captured!.data, {
        'capability': 'opaque-change-capability',
        'new_password': 'Fresh-Correct-Horse-84!',
      });
      expect(pair.access, 'fresh-access');
      expect(pair.refresh, 'fresh-refresh');
    },
  );
}
