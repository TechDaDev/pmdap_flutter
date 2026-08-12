import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/config/app_config.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/identity.dart';
import '../../../core/models/pagination.dart';
import '../../../core/utils/date_utils.dart';
import 'extraction_models.dart';
import 'identity_image_part.dart';

/// Selected existing file/image to submit for an identity document.
///
/// Filenames/content types are NOT hardcoded here — they are derived from the
/// real image bytes by [identityMultipartFile] so extraction, final submit and
/// replacement always agree on the format.
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
    this.backPath,
  });

  final IdentityDocumentType documentType;
  final String documentNumber;
  final String nationalNumber;
  final String familyNumber;
  final String issuingCountry;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final String frontPath;
  final String? backPath;
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

  Future<IdentityDocumentDetail> submit(
    IdentitySubmission s, {
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final form = await _identityForm(s);
      final resp = await _dio.post<dynamic>(
        ApiPaths.identityDocuments,
        data: form,
        options: _uploadOptions(),
        onSendProgress: onSendProgress,
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
    IdentitySubmission s, {
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final form = await _identityForm(s);
      final resp = await _dio.post<dynamic>(
        ApiPaths.identityDocumentReplace(uuid),
        data: form,
        options: _uploadOptions(),
        onSendProgress: onSendProgress,
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

  /// Advisory field extraction (async). Returns the job id; poll
  /// [extractStatus] for the result. No IdentityDocument is created; the
  /// result is for human review before the real [submit]/[replace] call.
  Future<ExtractionJobDto> extract({
    required IdentityDocumentType documentType,
    required String frontPath,
    String? backPath,
  }) async {
    try {
      final form = FormData.fromMap({
        'document_type': documentType.api,
        'front_image': await identityMultipartFile(frontPath, side: 'front'),
        if (backPath != null)
          'back_image': await identityMultipartFile(backPath, side: 'back'),
      });
      final resp = await _dio.post<dynamic>(
        ApiPaths.identityExtract,
        data: form,
        options: _uploadOptions(),
      );
      return decodeData<ExtractionJobDto>(resp.data, ExtractionJobDto.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Build the multipart form for [submit]/[replace] using the shared
  /// identity-image helper so the declared MIME always matches the real bytes.
  Future<FormData> _identityForm(IdentitySubmission s) async {
    final form = FormData.fromMap({
      'document_type': s.documentType.api,
      'document_number': s.documentNumber,
      'national_number': s.nationalNumber,
      'family_number': s.familyNumber,
      'issuing_country': s.issuingCountry,
      if (s.issueDate != null) 'issue_date': formatApiDate(s.issueDate),
      if (s.expiryDate != null) 'expiry_date': formatApiDate(s.expiryDate),
      'front_image': await identityMultipartFile(s.frontPath, side: 'front'),
      if (s.backPath != null)
        'back_image': await identityMultipartFile(s.backPath!, side: 'back'),
    });
    return form;
  }

  /// Upload-timeout options. Uploads of identity images are intentionally
  /// given a longer (still finite) send window than regular requests.
  Options _uploadOptions() => Options(
    sendTimeout: AppConfig.uploadSendTimeout,
    receiveTimeout: AppConfig.uploadReceiveTimeout,
  );

  /// Poll an async extraction job. Terminal states carry the result or an
  /// error code; the job is consumed server-side on read.
  Future<ExtractionStatus> extractStatus(String jobId) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.identityExtractStatus(jobId),
      );
      return decodeData<ExtractionStatus>(resp.data, ExtractionStatus.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }
}
