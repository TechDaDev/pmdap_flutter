import 'package:dio/dio.dart';

import '../models/api_error.dart';
import 'api_exception.dart';

/// Maps a [DioException] to a safe, typed [ApiException].
///
/// Backend errors use the envelope `{"error": {"code","message","details"}}`.
/// Everything else becomes a generic safe message — never raw DioException
/// text, stack traces, SQL, or internal URLs.
class ApiErrorMapper {
  const ApiErrorMapper();

  ApiException map(DioException e) {
    final response = e.response;
    if (response == null) {
      // No HTTP response → transport-level error.
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          return const ApiException(
            code: 'connection_timeout',
            message:
                'Connection timed out. Check your connection and try again.',
          );
        case DioExceptionType.sendTimeout:
          return const ApiException(
            code: 'send_timeout',
            message: 'Request timed out. Try again.',
          );
        case DioExceptionType.receiveTimeout:
          return const ApiException(
            code: 'receive_timeout',
            message: 'Response timed out. Try again.',
          );
        case DioExceptionType.cancel:
          return const ApiException(
            code: 'request_cancelled',
            message: 'Request cancelled.',
          );
        default:
          return const ApiException.network();
      }
    }

    final status = response.statusCode ?? 0;
    final data = response.data;

    if (data is Map<String, dynamic>) {
      final envelope = _tryEnvelope(data);
      if (envelope != null) {
        return ApiException(
          statusCode: status,
          code: envelope.code,
          message: envelope.message,
          details: envelope.details,
        );
      }
    }

    // Fallback: safe generic message based on status only.
    return ApiException(
      statusCode: status,
      code: 'http_$status',
      message: _genericMessage(status),
    );
  }

  ApiError? _tryEnvelope(Map<String, dynamic> data) {
    if (data['error'] is Map<String, dynamic>) {
      return ApiError.fromJson(data);
    }
    return null;
  }

  String _genericMessage(int status) {
    if (status >= 500) return 'Server error. Please try again later.';
    if (status == 401) return 'Session expired. Please sign in again.';
    if (status == 403) return 'You do not have permission to do this.';
    if (status == 404) return 'The requested item was not found.';
    if (status == 429) return 'Too many attempts. Please wait and try again.';
    return 'Request failed (HTTP $status).';
  }
}
