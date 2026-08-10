import '../models/api_error.dart';

/// Typed exception surfaced to UI. Never display raw DioException text.
class ApiException implements Exception {
  const ApiException({
    this.statusCode,
    required this.code,
    required this.message,
    this.details = const {},
    this.isNetwork = false,
  });

  const ApiException.network({
    String message = 'Network error. Check connection.',
  }) : statusCode = null,
       code = 'network_error',
       message = message,
       details = const {},
       isNetwork = true;

  final int? statusCode;
  final String code;
  final String message;
  final Map<String, dynamic> details;
  final bool isNetwork;

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isThrottled => statusCode == 429 || code == 'throttled';
  bool get isTimeout =>
      code == 'connection_timeout' ||
      code == 'receive_timeout' ||
      code == 'send_timeout';

  String? get firstFieldMessage {
    for (final entry in details.entries) {
      final value = entry.value;
      if (value is List && value.isNotEmpty && value.first is String) {
        return '${entry.key}: ${value.first}';
      }
      if (value is String && value.isNotEmpty) return '${entry.key}: $value';
    }
    return null;
  }

  /// Build an [ApiError] equivalent (for mappers/tests).
  ApiError toApiError() =>
      ApiError(code: code, message: message, details: details);

  @override
  String toString() => 'ApiException($code, $statusCode, $message)';
}
