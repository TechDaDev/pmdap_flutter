import 'package:dio/dio.dart';

import '../../../core/api/api_error_mapper.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/token_pair.dart';
import '../../../core/models/user.dart';
import '../../../core/utils/date_utils.dart';

/// Registration input matching `RegisterRequest.patient`.
class PatientRegistrationInput {
  const PatientRegistrationInput({
    required this.fullName,
    required this.dateOfBirth,
    required this.sex,
    required this.nationality,
    this.bloodGroup = BloodGroup.unknown,
  });

  final String fullName;
  final DateTime? dateOfBirth;
  final Sex sex;
  final String nationality;
  final BloodGroup bloodGroup;

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'date_of_birth': formatApiDate(dateOfBirth),
    'sex': sex.api,
    'nationality': nationality,
    if (bloodGroup != BloodGroup.unknown) 'blood_group': bloodGroup.api,
  };
}

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;
  final ApiErrorMapper _mapper = const ApiErrorMapper();

  Future<TokenPair> login({
    required String email,
    required String password,
  }) async {
    try {
      final resp = await _dio.post<dynamic>(
        ApiPaths.login,
        data: {'email': email, 'password': password},
      );
      final data = resp.data;
      if (data is Map<String, dynamic> &&
          data['data'] is Map<String, dynamic>) {
        return TokenPair.fromJson(data['data'] as Map<String, dynamic>);
      }
      throw const ApiException(
        code: 'invalid_response',
        message: 'Unexpected response from server.',
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<PublicUser> register({
    required String email,
    String? phone,
    required String password,
    required PatientRegistrationInput patient,
  }) async {
    try {
      final resp = await _dio.post<dynamic>(
        ApiPaths.register,
        data: {
          'email': email,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          'password': password,
          'patient': patient.toJson(),
        },
      );
      final data = resp.data;
      if (data is Map<String, dynamic> &&
          data['data'] is Map<String, dynamic>) {
        return PublicUser.fromJson(data['data'] as Map<String, dynamic>);
      }
      throw const ApiException(
        code: 'invalid_response',
        message: 'Unexpected response from server.',
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<PublicUser> me() async {
    try {
      final resp = await _dio.get<dynamic>(ApiPaths.me);
      final data = resp.data;
      if (data is Map<String, dynamic> &&
          data['data'] is Map<String, dynamic>) {
        return PublicUser.fromJson(data['data'] as Map<String, dynamic>);
      }
      throw const ApiException(
        code: 'invalid_response',
        message: 'Unexpected response from server.',
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<void> logout(String refresh) async {
    try {
      await _dio.post<dynamic>(ApiPaths.logout, data: {'refresh': refresh});
    } on DioException catch (e) {
      // Logout is best-effort; even if the server rejects the (possibly
      // expired) token, the client still clears local state.
      if (!_isAuthFailure(e)) throw _mapper.map(e);
    }
  }

  bool _isAuthFailure(DioException e) =>
      e.response?.statusCode == 401 || e.response?.statusCode == 400;
}
