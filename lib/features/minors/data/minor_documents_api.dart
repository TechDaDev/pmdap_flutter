import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/date_candidate.dart';
import '../../../core/models/document_page.dart';
import '../../../core/models/extracted_content.dart';
import '../../../core/models/lab_results.dart';
import '../../../core/models/medical_document.dart';
import '../../../core/models/pagination.dart';
import '../../../core/models/pending_date_confirmation.dart';
import '../../../core/utils/date_utils.dart';
import '../../documents/data/documents_api.dart'
    show DocumentUploadInput, medicalUploadContentType;

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

  /// Read-only structured lab results for a minor's document (guardian flow).
  Future<LabResultsResponse> labResults(
    String minorUuid,
    String docUuid,
  ) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.minorDocumentLabResults(minorUuid, docUuid),
      );
      return decodeData<LabResultsResponse>(
        resp.data,
        LabResultsResponse.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Read-only extracted content for a minor's document (guardian flow).
  Future<ExtractedContentResponse> extractedContent(
    String minorUuid,
    String docUuid,
  ) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.minorDocumentExtractedContent(minorUuid, docUuid),
      );
      return decodeData<ExtractedContentResponse>(
        resp.data,
        ExtractedContentResponse.fromJson,
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
      final contentType = input.mimeType != null
          ? MediaType.parse(input.mimeType!)
          : medicalUploadContentType(input.filePath ?? '');
      final MultipartFile filePart;
      if (input.bytes != null) {
        // Web: no dart:io File path; send in-memory bytes.
        filePart = MultipartFile.fromBytes(
          input.bytes!,
          filename: input.filename,
          contentType: contentType,
        );
      } else {
        filePart = await MultipartFile.fromFile(
          input.filePath!,
          filename: input.filename,
          contentType: contentType,
        );
      }
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
        'file': filePart,
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

  /// Document-centric date-confirmation queue for a minor (guardian flow).
  Future<List<PendingDateConfirmation>> pendingDateConfirmations(
    String minorUuid,
  ) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.minorPendingDateConfirmations(minorUuid),
      );
      final data = decodeData<Map<String, dynamic>>(resp.data, (json) => json);
      final results = (data['results'] as List?) ?? const [];
      return results
          .whereType<Map<String, dynamic>>()
          .map(PendingDateConfirmation.fromJson)
          .toList();
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
        'candidate_id': ?candidateId,
        'date': ?(date == null ? null : formatApiDate(date)),
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

  Future<MedicalDocumentPageSummary> documentPages(
    String minorUuid,
    String docUuid,
  ) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.minorDocumentPages(minorUuid, docUuid),
      );
      return decodeData(resp.data, MedicalDocumentPageSummary.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<MedicalDocumentPageDetail> documentPageDetail(
    String minorUuid,
    String docUuid,
    int pageNumber,
  ) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.minorDocumentPageDetail(minorUuid, docUuid, pageNumber),
      );
      return decodeData(resp.data, MedicalDocumentPageDetail.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<MedicalDocumentPageLabResults> pageLabResults(
    String minorUuid,
    String docUuid,
    int pageNumber,
  ) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.minorDocumentPageLabResults(minorUuid, docUuid, pageNumber),
      );
      return decodeData(resp.data, MedicalDocumentPageLabResults.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<MedicalDocumentPageDetail> confirmPageDate(
    String minorUuid,
    String docUuid,
    int pageNumber, {
    String? candidateId,
    DateTime? date,
  }) async {
    try {
      final body = <String, dynamic>{
        'candidate_id': ?candidateId,
        'date': ?(date == null ? null : formatApiDate(date)),
      };
      final resp = await _dio.post<dynamic>(
        ApiPaths.minorDocumentPageConfirmDate(minorUuid, docUuid, pageNumber),
        data: body,
      );
      return decodeData(resp.data, MedicalDocumentPageDetail.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }
}
