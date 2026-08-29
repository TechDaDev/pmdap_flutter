import 'package:dio/dio.dart';

import '../../../core/api/api_error_mapper.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/constants/api_paths.dart';

class PasswordResetVerification {
  const PasswordResetVerification({
    required this.token,
    required this.expiresAt,
  });

  final String token;
  final DateTime expiresAt;
}

class PasswordResetApi {
  PasswordResetApi(this._dio);

  final Dio _dio;
  final ApiErrorMapper _mapper = const ApiErrorMapper();

  Future<int> request({required String email}) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiPaths.passwordResetRequest,
        data: {'email': email},
      );
      final data = _data(response.data);
      final seconds = data['resend_after_seconds'];
      if (seconds is! int) throw _invalidResponse();
      return seconds;
    } on DioException catch (error) {
      throw _mapper.map(error);
    }
  }

  Future<PasswordResetVerification> verify({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiPaths.passwordResetVerify,
        data: {'email': email, 'code': code},
      );
      final data = _data(response.data);
      final token = data['reset_token'];
      final expiresAt = DateTime.tryParse(data['expires_at']?.toString() ?? '');
      if (token is! String || token.isEmpty || expiresAt == null) {
        throw _invalidResponse();
      }
      return PasswordResetVerification(token: token, expiresAt: expiresAt);
    } on DioException catch (error) {
      throw _mapper.map(error);
    }
  }

  Future<void> confirm({
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiPaths.passwordResetConfirm,
        data: {'reset_token': resetToken, 'new_password': newPassword},
      );
      _data(response.data);
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
