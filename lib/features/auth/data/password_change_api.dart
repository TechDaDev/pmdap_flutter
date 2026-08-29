import 'package:dio/dio.dart';

import '../../../core/api/api_error_mapper.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/token_pair.dart';

/// A short-lived, single-use capability authorizing the password change.
class PasswordChangeVerification {
  const PasswordChangeVerification({
    required this.capability,
    required this.expiresAt,
  });

  final String capability;
  final DateTime expiresAt;
}

/// Authenticated password change via current password + email OTP.
///
/// Uses the authenticated Dio client (`dioProvider`): every call requires a
/// valid session and the backend binds the flow to the acting account.
class PasswordChangeApi {
  PasswordChangeApi(this._dio);

  final Dio _dio;
  final ApiErrorMapper _mapper = const ApiErrorMapper();

  /// Proves the current password and issues a PASSWORD_CHANGE OTP to the
  /// account's verified email. Returns the resend cooldown in seconds.
  Future<int> request({required String currentPassword}) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiPaths.passwordChangeRequest,
        data: {'current_password': currentPassword},
      );
      final data = _data(response.data);
      final seconds = data['resend_after_seconds'];
      if (seconds is! int) throw _invalidResponse();
      return seconds;
    } on DioException catch (error) {
      throw _mapper.map(error);
    }
  }

  /// Verifies the emailed code and returns the change capability.
  Future<PasswordChangeVerification> verify({required String code}) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiPaths.passwordChangeVerify,
        data: {'code': code},
      );
      final data = _data(response.data);
      final capability = data['capability'];
      final expiresAt = DateTime.tryParse(data['expires_at']?.toString() ?? '');
      if (capability is! String || capability.isEmpty || expiresAt == null) {
        throw _invalidResponse();
      }
      return PasswordChangeVerification(
        capability: capability,
        expiresAt: expiresAt,
      );
    } on DioException catch (error) {
      throw _mapper.map(error);
    }
  }

  /// Consumes the capability and changes the password. The backend revokes
  /// every other session and returns a fresh token pair for this device.
  Future<TokenPair> confirm({
    required String capability,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiPaths.passwordChangeConfirm,
        data: {'capability': capability, 'new_password': newPassword},
      );
      final data = _data(response.data);
      final access = data['access'];
      final refresh = data['refresh'];
      if (access is! String ||
          access.isEmpty ||
          refresh is! String ||
          refresh.isEmpty) {
        throw _invalidResponse();
      }
      return TokenPair(access: access, refresh: refresh);
    } on DioException catch (error) {
      throw _mapper.map(error);
    }
  }

  Map<String, dynamic> _data(dynamic body) {
    if (body is Map<String, dynamic> && body['data'] is Map<String, dynamic>) {
      return body['data'] as Map<String, dynamic>;
    }
    throw _invalidResponse();
  }

  ApiException _invalidResponse() => const ApiException(
    code: 'invalid_response',
    message: 'Unexpected response from server.',
  );
}
