/// Typed backend error envelope: `{"error": {"code","message","details"}}`.
class ApiError {
  const ApiError({
    required this.code,
    required this.message,
    this.details = const {},
  });

  final String code;
  final String message;
  final Map<String, dynamic> details;

  factory ApiError.fromJson(Map<String, dynamic> json) {
    final error = (json['error'] as Map<String, dynamic>?) ?? const {};
    final detailsRaw = error['details'];
    Map<String, dynamic> details = const {};
    if (detailsRaw is Map<String, dynamic>) details = detailsRaw;
    return ApiError(
      code: (error['code'] as String?) ?? 'unknown_error',
      message: (error['message'] as String?) ?? 'Unexpected error.',
      details: details,
    );
  }

  /// First field-level message from [details], if any (safe, backend-provided).
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

  bool get isThrottled => code == 'throttled';
  bool get isInvalidCredentials =>
      code == 'invalid_credentials' || code == 'authentication_failed';
  bool get isAccountUnavailable => code == 'account_unavailable';
  bool get isNotAuthenticated =>
      code == 'not_authenticated' || code == 'authentication_failed';

  @override
  String toString() => 'ApiError($code: $message)';
}
