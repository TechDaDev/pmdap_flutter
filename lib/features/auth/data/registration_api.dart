import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/config/app_config.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/user.dart';
import '../../identity/data/identity_image_part.dart';
import 'registration_models.dart';

/// Public scan-first registration API.
///
/// Uses a dedicated PUBLIC Dio (no auth/refresh interceptors) so no JWT is
/// ever attached to these anonymous endpoints. The job capability token is
/// sent only in the intended poll request header — never stored, logged or
/// placed in the URL. The password is never sent to the extraction endpoint.
class RegistrationApi {
  RegistrationApi(this._dio);

  final Dio _dio;
  final ApiErrorMapper _mapper = const ApiErrorMapper();

  /// Start M31B email verification: create the registration session and send
  /// the 6-digit OTP. Returns the session capability exactly once.
  Future<RegistrationEmailSession> startEmailVerification({
    required String email,
    String? phone,
    String? governorate,
  }) async {
    try {
      final resp = await _dio.post<dynamic>(
        ApiPaths.registrationEmailStart,
        data: {
          'email': email,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          if (governorate != null && governorate.isNotEmpty)
            'governorate': governorate,
        },
      );
      return decodeData<RegistrationEmailSession>(
        resp.data,
        RegistrationEmailSession.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Resend the email-verification OTP for an existing session.
  Future<RegistrationEmailStatus> resendEmailVerification({
    required String sessionToken,
  }) async {
    try {
      final resp = await _dio.post<dynamic>(
        ApiPaths.registrationEmailResend,
        data: {'session_token': sessionToken},
      );
      return decodeData<RegistrationEmailStatus>(
        resp.data,
        RegistrationEmailStatus.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Verify the email-verification OTP. The target is always the session's
  /// own email server-side; the client can never pick a different target.
  Future<RegistrationEmailStatus> verifyEmail({
    required String sessionToken,
    required String code,
  }) async {
    try {
      final resp = await _dio.post<dynamic>(
        ApiPaths.registrationEmailVerify,
        data: {'session_token': sessionToken, 'code': code},
      );
      return decodeData<RegistrationEmailStatus>(
        resp.data,
        RegistrationEmailStatus.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Resume endpoint: current verification state for a session capability.
  Future<RegistrationEmailStatus> getEmailVerificationStatus({
    required String sessionToken,
  }) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.registrationEmailStatus,
        options: Options(
          headers: {'X-Registration-Session-Token': sessionToken},
        ),
      );
      return decodeData<RegistrationEmailStatus>(
        resp.data,
        RegistrationEmailStatus.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Upload National Card front/back exactly once; returns the capability.
  ///
  /// Requires a verified M31B registration session capability in the header;
  /// an unverified session is refused server-side (403).
  Future<RegistrationExtractionJob> startExtraction({
    required String sessionToken,
    required String frontPath,
    String? backPath,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final form = FormData.fromMap({
        'document_type': IdentityDocumentType.unifiedNationalCard.api,
        'front_image': await identityMultipartFile(frontPath, side: 'front'),
        if (backPath != null)
          'back_image': await identityMultipartFile(backPath, side: 'back'),
      });
      final resp = await _dio.post<dynamic>(
        ApiPaths.registrationIdentityExtract,
        data: form,
        options: Options(
          sendTimeout: AppConfig.uploadSendTimeout,
          receiveTimeout: AppConfig.uploadReceiveTimeout,
          headers: {'X-Registration-Session-Token': sessionToken},
        ),
        onSendProgress: onSendProgress,
      );
      return decodeData<RegistrationExtractionJob>(
        resp.data,
        RegistrationExtractionJob.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Poll an extraction. The capability token is sent in a header only.
  Future<RegistrationExtractionStatus> pollExtraction({
    required String jobId,
    required String jobToken,
  }) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.registrationIdentityExtractStatus(jobId),
        options: Options(headers: {'X-Registration-Job-Token': jobToken}),
      );
      return decodeData<RegistrationExtractionStatus>(
        resp.data,
        RegistrationExtractionStatus.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Final scan-first registration. Sends credentials + the confirmed
  /// reviewed values + the M31B session capability + the job capability.
  /// NO image multipart — the staged images are promoted server-side from the
  /// session (single upload). The client can never assert verification: the
  /// server derives it from the session row.
  Future<PublicUser> registerScanFirst({
    required String email,
    String? phone,
    required String password,
    required String governorate,
    required String sessionToken,
    required RegistrationIdentityInput identity,
  }) async {
    try {
      final resp = await _dio.post<dynamic>(
        ApiPaths.register,
        data: {
          'email': email,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          'password': password,
          'governorate': governorate,
          'registration_session': sessionToken,
          'registration_identity': identity.toJson(),
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
}
