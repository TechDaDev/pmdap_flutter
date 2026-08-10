import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../auth/token_refresher.dart';
import '../auth/token_store.dart';
import '../config/app_config.dart';

/// Paths that never receive the Authorization header (public endpoints).
const Set<String> kPublicPaths = {
  '/auth/login/',
  '/auth/register/',
  '/auth/refresh/',
  '/auth/activate-claimed-account/',
  '/health/',
  '/account-claims/',
};

/// Attaches the current access token (kept in memory only).
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._store);

  final TokenStore _store;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;
    final isPublic = kPublicPaths.any(path.contains);
    final token = _store.accessToken;
    if (!isPublic && token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Development-only logging. Logs method + path + status; NEVER bodies
/// (bodies may contain JWT, medical content, or identity data).
class SafeLoggingInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (AppConfig.isDebug) {
      // ignore: avoid_print
      print(
        '[pmdap] ${response.requestOptions.method} '
        '${response.requestOptions.uri.path} -> ${response.statusCode}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (AppConfig.isDebug) {
      // ignore: avoid_print
      print(
        '[pmdap] ${err.requestOptions.method} '
        '${err.requestOptions.uri.path} !! ${err.response?.statusCode}',
      );
    }
    handler.next(err);
  }
}

/// Single-flight 401 refresh + retry.
///
/// On an eligible 401 (authenticated endpoint, not auth endpoints, not already
/// retried) it asks [TokenRefresher] for a new pair. Exactly one refresh runs
/// at a time — concurrent callers share the in-flight future. On success the
/// original request is retried once. On refresh failure the session is cleared
/// via [onSessionExpired].
class RefreshInterceptor extends Interceptor {
  RefreshInterceptor({
    required this.dio,
    required this.refresher,
    required this.store,
    required this.onSessionExpired,
  });

  final Dio dio;
  final TokenRefresher refresher;
  final TokenStore store;
  final VoidCallback onSessionExpired;

  static const _retriedKey = 'pmdap_retried';

  bool _isAuthEndpoint(String path) =>
      path.contains('/auth/login/') ||
      path.contains('/auth/register/') ||
      path.contains('/auth/refresh/') ||
      path.contains('/auth/activate-claimed-account/');

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final path = err.requestOptions.path;
    final alreadyRetried = err.requestOptions.extra[_retriedKey] == true;

    if (status == 401 && !alreadyRetried && !_isAuthEndpoint(path)) {
      final pair = await refresher.refresh();
      if (pair != null) {
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer ${pair.access}';
        options.extra[_retriedKey] = true;
        try {
          final response = await dio.fetch<dynamic>(options);
          handler.resolve(response);
          return;
        } on DioException catch (retryError) {
          handler.next(retryError);
          return;
        }
      }
      onSessionExpired();
    }
    handler.next(err);
  }
}
