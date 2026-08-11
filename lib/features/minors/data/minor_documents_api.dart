import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/date_candidate.dart';
import '../../../core/models/medical_document.dart';
import '../../../core/models/pagination.dart';
import '../../../core/utils/date_utils.dart';
import '../../documents/data/documents_api.dart' show DocumentUploadInput;

/// Medical document operations scoped to a minor (guardian flow).
class MinorDocumentsApi {
  MinorDocumentsApi(this._dio);

  final Dio _dio;
  final ApiErrorMapper _mapper = const ApiErrorMapper();

  Future<Page<MedicalDocument>> list(String minorUuid, {int page = 1}) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.minorDocuments(minorUuid),
        queryParameters: {'page': page},
      );
      ensureData(resp.data);
      final pageJson =
          (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return Page<MedicalDocument>.fromJson(pageJson, MedicalDocument.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<MedicalDocumentDetail> detail(String minorUuid, String docUuid) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.minorDocumentDetail(minorUuid, docUuid),
      );
      return decodeData<MedicalDocumentDetail>(
        resp.data,
        MedicalDocumentDetail.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<MedicalDocument> upload(
    String minorUuid,
    DocumentUploadInput input,
  ) async {
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
      final resp = await _dio.post<dynamic>(
        ApiPaths.minorDocuments(minorUuid),
        data: form,
      );
      return decodeData<MedicalDocument>(resp.data, MedicalDocument.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<void> delete(String minorUuid, String docUuid) async {
    try {
      await _dio.delete<dynamic>(
        ApiPaths.minorDocumentDetail(minorUuid, docUuid),
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<Uint8List> fetchFile(String minorUuid, String docUuid) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.minorDocumentFile(minorUuid, docUuid),
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(resp.data as List<int>);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<Page<DateCandidate>> dateCandidates(
    String minorUuid,
    String docUuid, {
    int page = 1,
  }) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.minorDocumentCandidates(minorUuid, docUuid),
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

  Future<DocumentDateConfirmationResponse> confirmDate(
    String minorUuid,
    String docUuid, {
    String? candidateId,
    DateTime? date,
  }) async {
    try {
      final body = <String, dynamic>{
        if (candidateId != null) 'candidate_id': candidateId,
        if (date != null) 'date': formatApiDate(date),
      };
      final resp = await _dio.post<dynamic>(
        ApiPaths.minorDocumentConfirmDate(minorUuid, docUuid),
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
