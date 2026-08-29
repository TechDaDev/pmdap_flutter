import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/features/auth/data/password_reset_api.dart';

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
  late PasswordResetApi api;

  setUp(() {
    adapter = _CaptureAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    api = PasswordResetApi(dio);
  });

  test('request sends email only and parses generic cooldown', () async {
    adapter.body = jsonEncode({
      'data': {
        'message': 'If an eligible account exists, check your email.',
        'resend_after_seconds': 60,
      },
    });

    final seconds = await api.request(email: 'owner@example.com');

    expect(adapter.captured!.path, '/auth/password-reset/request/');
    expect(adapter.captured!.method, 'POST');
    expect(adapter.captured!.data, {'email': 'owner@example.com'});
    expect(seconds, 60);
  });

  test('verify sends purpose inputs and returns opaque capability', () async {
    adapter.body = jsonEncode({
      'data': {
        'reset_token': 'opaque-reset-capability',
        'expires_at': '2026-08-29T13:00:00Z',
      },
    });

    final result = await api.verify(email: 'owner@example.com', code: '123456');

    expect(adapter.captured!.path, '/auth/password-reset/verify/');
    expect(adapter.captured!.data, {
      'email': 'owner@example.com',
      'code': '123456',
    });
    expect(result.token, 'opaque-reset-capability');
    expect(result.expiresAt, DateTime.parse('2026-08-29T13:00:00Z'));
  });

  test('confirm sends capability and password once', () async {
    adapter.body = jsonEncode({
      'data': {'message': 'Password reset completed. Sign in again.'},
    });

    await api.confirm(
      resetToken: 'opaque-reset-capability',
      newPassword: 'Fresh-Correct-Horse-84!',
    );

    expect(adapter.captured!.path, '/auth/password-reset/confirm/');
    expect(adapter.captured!.data, {
      'reset_token': 'opaque-reset-capability',
      'new_password': 'Fresh-Correct-Horse-84!',
    });
  });
}
