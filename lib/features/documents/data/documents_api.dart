import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/date_candidate.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/medical_document.dart';
import '../../../core/models/pagination.dart';
import '../../../core/utils/date_utils.dart';

class DocumentUploadInput {
  const DocumentUploadInput({
    required this.documentType,
    required this.filePath,
    required this.filename,
    this.title,
    this.description,
    this.healthcareFacilityId,
    this.facilityName,
    this.locationText,
    this.department,
    this.physicianName,
    this.documentDate,
  });

  final MedicalDocumentType documentType;
  final String filePath;
  final String filename;
  final String? title;
  final String? description;
  final String? healthcareFacilityId;
  final String? facilityName;
  final String? locationText;
  final String? department;
  final String? physicianName;
  final DateTime? documentDate;
}

class DocumentsApi {
  DocumentsApi(this._dio);

  final Dio _dio;
  final ApiErrorMapper _mapper = const ApiErrorMapper();

  Future<Page<MedicalDocument>> list({int page = 1}) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.documents,
        queryParameters: {'page': page},
      );
      return decodePage(
        resp.data,
        Page<MedicalDocument>.fromJson,
        MedicalDocument.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<MedicalDocumentDetail> detail(String uuid) async {
    try {
      final resp = await _dio.get<dynamic>(ApiPaths.documentDetail(uuid));
      return decodeData<MedicalDocumentDetail>(
        resp.data,
        MedicalDocumentDetail.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<MedicalDocument> upload(DocumentUploadInput input) async {
    try {
      final form = FormData.fromMap({
        'document_type': input.documentType.api,
        if (input.title != null && input.title!.isNotEmpty)
          'title': input.title,
        if (input.description != null && input.description!.isNotEmpty)
          'description': input.description,
        if (input.healthcareFacilityId != null)
          'healthcare_facility_id': input.healthcareFacilityId,
        if (input.facilityName != null && input.facilityName!.isNotEmpty)
          'facility_name': input.facilityName,
        if (input.locationText != null && input.locationText!.isNotEmpty)
          'location_text': input.locationText,
        if (input.department != null && input.department!.isNotEmpty)
          'department': input.department,
        if (input.physicianName != null && input.physicianName!.isNotEmpty)
          'physician_name': input.physicianName,
        if (input.documentDate != null)
          'document_date': formatApiDate(input.documentDate),
        'file': await MultipartFile.fromFile(
          input.filePath,
          filename: input.filename,
        ),
      });
      final resp = await _dio.post<dynamic>(ApiPaths.documents, data: form);
      return decodeData<MedicalDocument>(resp.data, MedicalDocument.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<MedicalDocument> updateMetadata(
    String uuid, {
    MedicalDocumentType? documentType,
    String? title,
    String? description,
    String? healthcareFacilityId,
    String? facilityName,
    String? locationText,
    String? department,
    String? physicianName,
  }) async {
    try {
      final body = <String, dynamic>{
        if (documentType != null) 'document_type': documentType.api,
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (healthcareFacilityId != null)
          'healthcare_facility_id': healthcareFacilityId,
        if (facilityName != null) 'facility_name': facilityName,
        if (locationText != null) 'location_text': locationText,
        if (department != null) 'department': department,
        if (physicianName != null) 'physician_name': physicianName,
      };
      final resp = await _dio.patch<dynamic>(
        ApiPaths.documentDetail(uuid),
        data: body,
      );
      return decodeData<MedicalDocument>(resp.data, MedicalDocument.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Soft delete (backend keeps the record). 204 on success.
  Future<void> delete(String uuid) async {
    try {
      await _dio.delete<dynamic>(ApiPaths.documentDetail(uuid));
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Fetch the original private file through the authenticated endpoint.
  Future<Uint8List> fetchFile(String uuid) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.documentFile(uuid),
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(resp.data as List<int>);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<Page<DateCandidate>> dateCandidates(
    String uuid, {
    int page = 1,
  }) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.documentCandidates(uuid),
        queryParameters: {'page': page},
      );
      return decodePage(
        resp.data,
        Page<DateCandidate>.fromJson,
        DateCandidate.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Confirm a candidate (`candidate_id`) OR provide a manual date.
  /// The backend is the authority for `date_source`/`date_verified`.
  Future<DocumentDateConfirmationResponse> confirmDate(
    String uuid, {
    String? candidateId,
    DateTime? date,
  }) async {
    try {
      final body = <String, dynamic>{
        if (candidateId != null) 'candidate_id': candidateId,
        if (date != null) 'date': formatApiDate(date),
      };
      final resp = await _dio.post<dynamic>(
        ApiPaths.documentConfirmDate(uuid),
        data: body,
      );
      return decodeData<DocumentDateConfirmationResponse>(
        resp.data,
        DocumentDateConfirmationResponse.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }
}
