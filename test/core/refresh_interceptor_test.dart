import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/api/api_interceptors.dart';
import 'package:pmdap_mobile/core/auth/token_refresher.dart';
import 'package:pmdap_mobile/core/auth/token_store.dart';
import 'package:pmdap_mobile/core/models/token_pair.dart';
import 'package:pmdap_mobile/core/storage/refresh_token_storage.dart';

class _FakeStorage implements RefreshTokenStorage {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String token) async => value = token;
  @override
  Future<void> clear() async => value = null;
}

class _FakeRefresher extends TokenRefresher {
  _FakeRefresher(TokenStore store) : super(dio: Dio(), store: store);

  int refreshCalls = 0;
  TokenPair? result;
  bool fail = false;

  @override
  Future<TokenPair?> refresh() async {
    refreshCalls++;
    if (fail) return null;
    return result;
  }
}

class _MockHandler extends ErrorInterceptorHandler {
  _MockHandler();

  int nextCount = 0;
  int resolveCount = 0;
  DioException? nextError;
  Response<dynamic>? resolved;

  @override
  void next(DioException err) {
    nextCount++;
    nextError = err;
  }

  @override
  void resolve(Response<dynamic> response) {
    resolveCount++;
    resolved = response;
  }
}

void main() {
  late TokenStore store;
  late _FakeRefresher refresher;
  late bool sessionExpired;
  late Dio dio;

  setUp(() {
    store = TokenStore(_FakeStorage());
    store.setAccess('old-access');
    refresher = _FakeRefresher(store);
    sessionExpired = false;
    dio = Dio();
  });

  DioException unauthorized(String path) {
    final options = RequestOptions(path: path, baseUrl: 'http://x/api/v1');
    return DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
      response: Response<dynamic>(requestOptions: options, statusCode: 401),
    );
  }

  test('401 on an auth endpoint is not refreshed', () async {
    final interceptor = RefreshInterceptor(
      dio: dio,
      refresher: refresher,
      store: store,
      onSessionExpired: () => sessionExpired = true,
    );
    final handler = _MockHandler();
    await interceptor.onError(unauthorized('/auth/login/'), handler);
    expect(refresher.refreshCalls, 0);
    expect(handler.nextCount, 1);
    expect(sessionExpired, isFalse);
  });

  test('401 triggers refresh and retries the request once', () async {
    refresher.result = const TokenPair(
      access: 'new-access',
      refresh: 'new-refresh',
    );
    dio.httpClientAdapter = _EchoAdapter('{"status":"ok"}');
    final interceptor = RefreshInterceptor(
      dio: dio,
      refresher: refresher,
      store: store,
      onSessionExpired: () => sessionExpired = true,
    );
    final handler = _MockHandler();
    await interceptor.onError(unauthorized('/documents/'), handler);

    expect(refresher.refreshCalls, 1);
    expect(handler.resolveCount, 1);
    expect(sessionExpired, isFalse);
    // Retried request carries the new access token.
    final retried = handler.resolved!.requestOptions;
    expect(retried.headers['Authorization'], 'Bearer new-access');
  });

  test('refresh failure clears session via callback', () async {
    refresher.fail = true;
    final interceptor = RefreshInterceptor(
      dio: dio,
      refresher: refresher,
      store: store,
      onSessionExpired: () => sessionExpired = true,
    );
    final handler = _MockHandler();
    await interceptor.onError(unauthorized('/documents/'), handler);

    expect(refresher.refreshCalls, 1);
    expect(sessionExpired, isTrue);
    expect(handler.nextCount, 1);
  });

  test('already-retried requests do not refresh again', () async {
    final err = unauthorized('/documents/');
    err.requestOptions.extra['pmdap_retried'] = true;
    final interceptor = RefreshInterceptor(
      dio: dio,
      refresher: refresher,
      store: store,
      onSessionExpired: () => sessionExpired = true,
    );
    final handler = _MockHandler();
    await interceptor.onError(err, handler);
    expect(refresher.refreshCalls, 0);
    expect(handler.nextCount, 1);
    expect(sessionExpired, isFalse);
  });
}

/// Minimal adapter returning a canned response so the retried fetch resolves.
class _EchoAdapter implements HttpClientAdapter {
  _EchoAdapter(this.body);

  final String body;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      body,
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
