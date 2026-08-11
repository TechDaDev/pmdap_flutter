import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/identity.dart';
import '../../../core/models/pagination.dart';
import '../../../core/utils/date_utils.dart';

/// Selected existing file/image to submit for an identity document.
class IdentitySubmission {
  const IdentitySubmission({
    required this.documentType,
    required this.documentNumber,
    this.nationalNumber = '',
    this.familyNumber = '',
    this.issuingCountry = 'IQ',
    this.issueDate,
    this.expiryDate,
    required this.frontPath,
    required this.frontFilename,
    this.backPath,
    this.backFilename,
  });

  final IdentityDocumentType documentType;
  final String documentNumber;
  final String nationalNumber;
  final String familyNumber;
  final String issuingCountry;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final String frontPath;
  final String frontFilename;
  final String? backPath;
  final String? backFilename;
}

class IdentityApi {
  IdentityApi(this._dio);

  final Dio _dio;
  final ApiErrorMapper _mapper = const ApiErrorMapper();

  Future<Page<IdentityDocumentSummary>> list({int page = 1}) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.identityDocuments,
        queryParameters: {'page': page},
      );
      return decodePage(
        resp.data,
        Page<IdentityDocumentSummary>.fromJson,
        IdentityDocumentSummary.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<IdentityDocumentDetail> detail(String uuid) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.identityDocumentDetail(uuid),
      );
      return decodeData<IdentityDocumentDetail>(
        resp.data,
        IdentityDocumentDetail.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<IdentityDocumentDetail> submit(IdentitySubmission s) async {
    try {
      final form = FormData.fromMap({
        'document_type': s.documentType.api,
        'document_number': s.documentNumber,
        'national_number': s.nationalNumber,
        'family_number': s.familyNumber,
        'issuing_country': s.issuingCountry,
        if (s.issueDate != null) 'issue_date': formatApiDate(s.issueDate),
        if (s.expiryDate != null) 'expiry_date': formatApiDate(s.expiryDate),
        'front_image': await MultipartFile.fromFile(
          s.frontPath,
          filename: s.frontFilename,
        ),
        if (s.backPath != null)
          'back_image': await MultipartFile.fromFile(
            s.backPath!,
            filename: s.backFilename ?? 'back',
          ),
      });
      final resp = await _dio.post<dynamic>(
        ApiPaths.identityDocuments,
        data: form,
      );
      return decodeData<IdentityDocumentDetail>(
        resp.data,
        IdentityDocumentDetail.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<IdentityDocumentDetail> replace(
    String uuid,
    IdentitySubmission s,
  ) async {
    try {
      final form = FormData.fromMap({
        'document_type': s.documentType.api,
        'document_number': s.documentNumber,
        'national_number': s.nationalNumber,
        'family_number': s.familyNumber,
        'issuing_country': s.issuingCountry,
        if (s.issueDate != null) 'issue_date': formatApiDate(s.issueDate),
        if (s.expiryDate != null) 'expiry_date': formatApiDate(s.expiryDate),
        'front_image': await MultipartFile.fromFile(
          s.frontPath,
          filename: s.frontFilename,
        ),
        if (s.backPath != null)
          'back_image': await MultipartFile.fromFile(
            s.backPath!,
            filename: s.backFilename ?? 'back',
          ),
      });
      final resp = await _dio.post<dynamic>(
        ApiPaths.identityDocumentReplace(uuid),
        data: form,
      );
      return decodeData<IdentityDocumentDetail>(
        resp.data,
        IdentityDocumentDetail.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Fetch a private identity image through the authenticated endpoint.
  Future<Uint8List> fetchImage(String uuid, String side) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.identityDocumentImage(uuid, side),
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(resp.data as List<int>);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }
}
