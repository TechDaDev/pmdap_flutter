import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/claim.dart';
import '../../../core/utils/date_utils.dart';

class ClaimSubmission {
  const ClaimSubmission({
    required this.digitalId,
    required this.email,
    required this.phone,
    required this.fullName,
    required this.dateOfBirth,
    required this.identityDocumentType,
    required this.identityDocumentNumber,
    required this.frontPath,
    required this.frontFilename,
    this.backPath,
    this.backFilename,
    this.passportNumber,
    this.passportIssuingCountry,
    this.passportIssueDate,
    this.passportExpiryDate,
    this.passportFrontPath,
    this.passportFrontFilename,
    this.passportBackPath,
    this.passportBackFilename,
  });

  final String digitalId;
  final String email;
  final String phone;
  final String fullName;
  final DateTime? dateOfBirth;
  final String identityDocumentType;
  final String identityDocumentNumber;
  final String frontPath;
  final String frontFilename;
  final String? backPath;
  final String? backFilename;
  final String? passportNumber;
  final String? passportIssuingCountry;
  final DateTime? passportIssueDate;
  final DateTime? passportExpiryDate;
  final String? passportFrontPath;
  final String? passportFrontFilename;
  final String? passportBackPath;
  final String? passportBackFilename;
}

class ClaimsApi {
  ClaimsApi(this._dio);

  final Dio _dio;
  final ApiErrorMapper _mapper = const ApiErrorMapper();

  /// Public account-claim submission (throttled). Returns 202 receipt.
  Future<ClaimReceipt> submit(ClaimSubmission s) async {
    try {
      final form = FormData.fromMap({
        'digital_id': s.digitalId,
        'email': s.email,
        'phone': s.phone,
        'full_name': s.fullName,
        'date_of_birth': formatApiDate(s.dateOfBirth),
        'identity_document_type': s.identityDocumentType,
        'identity_document_number': s.identityDocumentNumber,
        'front_image': await MultipartFile.fromFile(
          s.frontPath,
          filename: s.frontFilename,
        ),
        if (s.backPath != null)
          'back_image': await MultipartFile.fromFile(
            s.backPath!,
            filename: s.backFilename ?? 'back',
          ),
        if (s.passportNumber != null) 'passport_number': s.passportNumber,
        if (s.passportIssuingCountry != null)
          'passport_issuing_country': s.passportIssuingCountry,
        if (s.passportIssueDate != null)
          'passport_issue_date': formatApiDate(s.passportIssueDate),
        if (s.passportExpiryDate != null)
          'passport_expiry_date': formatApiDate(s.passportExpiryDate),
        if (s.passportFrontPath != null)
          'passport_front_image': await MultipartFile.fromFile(
            s.passportFrontPath!,
            filename: s.passportFrontFilename ?? 'passport_front',
          ),
        if (s.passportBackPath != null)
          'passport_back_image': await MultipartFile.fromFile(
            s.passportBackPath!,
            filename: s.passportBackFilename ?? 'passport_back',
          ),
      });
      final resp = await _dio.post<dynamic>(ApiPaths.accountClaims, data: form);
      return decodeData<ClaimReceipt>(resp.data, ClaimReceipt.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }
}
