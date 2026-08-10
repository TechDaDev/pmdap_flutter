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
T decodeData<T>(
  dynamic responseData,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (responseData is Map<String, dynamic> &&
      responseData['data'] is Map<String, dynamic>) {
    return fromJson(responseData['data'] as Map<String, dynamic>);
  }
  throw const ApiException(
    code: 'invalid_response',
    message: 'Unexpected response from server.',
  );
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
