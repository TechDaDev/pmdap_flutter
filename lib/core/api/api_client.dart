import 'package:dio/dio.dart';

import '../config/app_config.dart';
import 'api_error_mapper.dart';
import 'api_exception.dart';
import 'api_interceptors.dart';

/// Builds the single centralized Dio client.
///
/// Interceptor order: AuthInterceptor → RefreshInterceptor → SafeLogging.
/// [onSessionExpired] fires when a refresh attempt fails and the session must
/// be cleared.
Dio buildApiClient({
  required AuthInterceptor authInterceptor,
  required RefreshInterceptor refreshInterceptor,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      headers: const {'Accept': 'application/json'},
      contentType: Headers.jsonContentType,
    ),
  );
  dio.interceptors.addAll([
    authInterceptor,
    refreshInterceptor,
    SafeLoggingInterceptor(),
  ]);
  return dio;
}

/// Helper to decode an API response envelope into a typed payload.
///
/// Backend success envelope is `{"data": <payload>}`.
///
/// Parse failures are surfaced in debug mode as `[pmdap] parse failure`
/// diagnostics (endpoint + exception type only — never response bodies, which
/// may contain medical or identity data).
T decodeData<T>(
  dynamic responseData,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (responseData is Map<String, dynamic> &&
      responseData['data'] is Map<String, dynamic>) {
    try {
      return fromJson(responseData['data'] as Map<String, dynamic>);
    } catch (e) {
      _logParseFailure(e);
      rethrow;
    }
  }
  throw const ApiException(
    code: 'invalid_response',
    message: 'Unexpected response from server.',
  );
}

/// Helper to decode a paginated payload nested under `data`.
/// `page` shape: `{"data": {"count", "next", "previous", "results", ...}}`.
/// Same debug parse-failure diagnostics as [decodeData]. Accepts either the
/// plain [Page] factory or a subclass factory such as `ArchivePage.fromJson`.
P decodePage<P, T>(
  dynamic responseData,
  P Function(Map<String, dynamic>, T Function(Map<String, dynamic>))
  pageFromJson,
  T Function(Map<String, dynamic>) itemFromJson,
) {
  ensureData(responseData);
  final pageJson =
      (responseData as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  try {
    return pageFromJson(pageJson, itemFromJson);
  } catch (e) {
    _logParseFailure(e);
    rethrow;
  }
}

/// Debug-only: log endpoint + exception type when a response fails to parse.
/// Never logs the response body, credentials, or patient data.
void _logParseFailure(Object e) {
  if (!AppConfig.isDebug) return;
  final path = SafeLoggingInterceptor.lastRequestPath ?? '?';
  // ignore: avoid_print
  print('[pmdap] parse failure: $path -> ${e.runtimeType}');
}

/// Helper to decode a paginated payload nested under `data`.
/// `page` shape: `{"data": {"count", "next", "previous", "results", ...}}`.
void ensureData(dynamic responseData) {
  if (responseData is! Map<String, dynamic> ||
      responseData['data'] is! Map<String, dynamic>) {
    throw const ApiException(
      code: 'invalid_response',
      message: 'Unexpected response from server.',
    );
  }
}

/// Converts a [DioException] into [ApiException] for service-layer throws.
ApiException toApiException(
  DioException e, {
  ApiErrorMapper mapper = const ApiErrorMapper(),
}) {
  return mapper.map(e);
}
