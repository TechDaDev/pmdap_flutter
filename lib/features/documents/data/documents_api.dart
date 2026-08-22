import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/date_candidate.dart';
import '../../../core/models/document_page.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/extracted_content.dart';
import '../../../core/models/lab_results.dart';
import '../../../core/models/medical_document.dart';
import '../../../core/models/pagination.dart';
import '../../../core/models/pending_date_confirmation.dart';
import '../../../core/utils/date_utils.dart';

class DocumentUploadInput {
  const DocumentUploadInput({
    required this.documentType,
    required this.filename,
    this.filePath,
    this.bytes,
    this.mimeType,
    this.title,
    this.description,
    this.healthcareFacilityId,
    this.facilityName,
    this.locationText,
    this.department,
    this.physicianName,
    this.documentDate,
    this.onUploadProgress,
  });

  final MedicalDocumentType documentType;

  /// Mobile path (from scanner or file picker cache copy).
  final String? filePath;

  /// Web bytes (dart:io File paths are unavailable on web). Exactly one of
  /// [filePath] / [bytes] is set.
  final Uint8List? bytes;

  /// Declared MIME (magic-byte detected by the caller). Used as the multipart
  /// content type; the server re-validates from the actual bytes.
  final String? mimeType;
  final String filename;
  final String? title;
  final String? description;
  final String? healthcareFacilityId;
  final String? facilityName;
  final String? locationText;
  final String? department;
  final String? physicianName;
  final DateTime? documentDate;

  /// Optional real upload progress (bytes sent / total) for the UI.
  final void Function(int sent, int total)? onUploadProgress;
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

  /// Read-only structured lab results for an owned document.
  Future<LabResultsResponse> labResults(String uuid) async {
    try {
      final resp = await _dio.get<dynamic>(ApiPaths.documentLabResults(uuid));
      return decodeData<LabResultsResponse>(
        resp.data,
        LabResultsResponse.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Read-only extracted content (narrative sections) for an owned document.
  Future<ExtractedContentResponse> extractedContent(String uuid) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.documentExtractedContent(uuid),
      );
      return decodeData<ExtractedContentResponse>(
        resp.data,
        ExtractedContentResponse.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<MedicalDocument> upload(DocumentUploadInput input) async {
    final sw = Stopwatch()..start();
    try {
      // Explicit content type from magic bytes. Dio would otherwise send
      // application/octet-stream, which the backend rejects (must be
      // image/jpeg, image/png or application/pdf).
      final contentType = input.mimeType != null
          ? MediaType.parse(input.mimeType!)
          : medicalUploadContentType(input.filePath ?? '');

      final MultipartFile filePart;
      if (input.bytes != null) {
        // Web: no dart:io File path; send the in-memory bytes.
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
      if (kDebugMode) {
        // Safe trace: mime + byte size + type + progress. NEVER the path,
        // bytes, medical content, JWT or patient id.
        final f = form.files.firstWhere(
          (e) => e.key == 'file',
          orElse: () => form.files.first,
        );
        debugPrint(
          'medical_upload start mime=${f.value.contentType} '
          'bytes=${f.value.length} type=${input.documentType.api}',
        );
      }
      final resp = await _dio.post<dynamic>(
        ApiPaths.documents,
        data: form,
        onSendProgress: (sent, total) {
          input.onUploadProgress?.call(sent, total);
          if (kDebugMode && total > 0) {
            final p = (sent * 100 / total).round();
            // Throttle to 10% steps to avoid hundreds of log lines.
            if (p % 10 == 0) {
              debugPrint('medical_upload progress=$p');
            }
          }
        },
      );
      if (kDebugMode) {
        debugPrint(
          'medical_upload ok status=${resp.statusCode} '
          'elapsed_ms=${sw.elapsedMilliseconds}',
        );
      }
      return decodeData<MedicalDocument>(resp.data, MedicalDocument.fromJson);
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint(
          'medical_upload error dio=${e.type.name} '
          'status=${e.response?.statusCode} '
          'elapsed_ms=${sw.elapsedMilliseconds}',
        );
      }
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

  /// Document-centric date-confirmation queue (single source for Home badge +
  /// Confirm Dates page). Documents with zero OCR candidates are included.
  Future<List<PendingDateConfirmation>> pendingDateConfirmations() async {
    try {
      final resp = await _dio.get<dynamic>(ApiPaths.pendingDateConfirmations);
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

  /// Report-unit summary for an owned document (`GET .../pages/`).
  Future<MedicalDocumentPageSummary> documentPages(String uuid) async {
    try {
      final resp = await _dio.get<dynamic>(ApiPaths.documentPages(uuid));
      return decodeData<MedicalDocumentPageSummary>(
        resp.data,
        MedicalDocumentPageSummary.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// One report page unit with its own candidates + structured results.
  Future<MedicalDocumentPageDetail> documentPageDetail(
    String uuid,
    int pageNumber,
  ) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.documentPageDetail(uuid, pageNumber),
      );
      return decodeData<MedicalDocumentPageDetail>(
        resp.data,
        MedicalDocumentPageDetail.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Structured lab results for ONE report page (owner-only).
  Future<MedicalDocumentPageLabResults> pageLabResults(
    String uuid,
    int pageNumber,
  ) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.documentPageLabResults(uuid, pageNumber),
      );
      return decodeData<MedicalDocumentPageLabResults>(
        resp.data,
        MedicalDocumentPageLabResults.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Confirm (or manually set) the report date for ONE page unit.
  Future<MedicalDocumentPageDetail> confirmPageDate(
    String uuid,
    int pageNumber, {
    String? candidateId,
    DateTime? date,
  }) async {
    try {
      final body = <String, dynamic>{
        if (candidateId != null) 'candidate_id': candidateId,
        if (date != null) 'date': formatApiDate(date),
      };
      final resp = await _dio.post<dynamic>(
        ApiPaths.documentPageConfirmDate(uuid, pageNumber),
        data: body,
      );
      return decodeData<MedicalDocumentPageDetail>(
        resp.data,
        MedicalDocumentPageDetail.fromJson,
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

/// Detect the medical-document MIME type from file magic bytes so the
/// multipart part carries an explicit, content-accurate content type.
///
/// Returns null for anything that is not JPEG/PNG/PDF; the backend then
/// rejects with a clear "must be PDF, JPEG, or PNG" error (correct behaviour
/// for an unsupported file).
MediaType? medicalUploadContentType(String path) {
  try {
    final raf = File(path).openSync();
    try {
      final head = raf.readSync(8);
      if (head.length >= 4 &&
          head[0] == 0x25 &&
          head[1] == 0x50 &&
          head[2] == 0x44 &&
          head[3] == 0x46) {
        return MediaType('application', 'pdf');
      }
      if (head.length >= 3 &&
          head[0] == 0xff &&
          head[1] == 0xd8 &&
          head[2] == 0xff) {
        return MediaType('image', 'jpeg');
      }
      if (head.length >= 4 &&
          head[0] == 0x89 &&
          head[1] == 0x50 &&
          head[2] == 0x4e &&
          head[3] == 0x47) {
        return MediaType('image', 'png');
      }
    } finally {
      raf.closeSync();
    }
  } catch (_) {
    return null;
  }
  return null;
}

/// Web-safe variant of [medicalUploadContentType]: detects JPEG/PNG/PDF from
/// in-memory bytes (dart:io File paths are unavailable on web).
MediaType? medicalUploadContentTypeFromBytes(Uint8List bytes) {
  if (bytes.length >= 4 &&
      bytes[0] == 0x25 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x44 &&
      bytes[3] == 0x46) {
    return MediaType('application', 'pdf');
  }
  if (bytes.length >= 3 &&
      bytes[0] == 0xff &&
      bytes[1] == 0xd8 &&
      bytes[2] == 0xff) {
    return MediaType('image', 'jpeg');
  }
  if (bytes.length >= 4 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4e &&
      bytes[3] == 0x47) {
    return MediaType('image', 'png');
  }
  return null;
}
