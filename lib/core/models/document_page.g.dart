// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicalDocumentPageSummaryItem _$MedicalDocumentPageSummaryItemFromJson(
  Map<String, dynamic> json,
) => _MedicalDocumentPageSummaryItem(
  pageNumber: (json['page_number'] as num).toInt(),
  reportSubtype: json['report_subtype'] as String? ?? ReportSubtype.unknown,
  processingStatus: json['processing_status'] as String? ?? '',
  documentDate: json['document_date'] == null
      ? null
      : DateTime.parse(json['document_date'] as String),
  dateVerified: json['date_verified'] as bool? ?? false,
  labResultCount: (json['lab_result_count'] as num?)?.toInt() ?? 0,
  dateCandidateCount: (json['date_candidate_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MedicalDocumentPageSummaryItemToJson(
  _MedicalDocumentPageSummaryItem instance,
) => <String, dynamic>{
  'page_number': instance.pageNumber,
  'report_subtype': instance.reportSubtype,
  'processing_status': instance.processingStatus,
  'document_date': instance.documentDate?.toIso8601String(),
  'date_verified': instance.dateVerified,
  'lab_result_count': instance.labResultCount,
  'date_candidate_count': instance.dateCandidateCount,
};

_MedicalDocumentPageSummary _$MedicalDocumentPageSummaryFromJson(
  Map<String, dynamic> json,
) => _MedicalDocumentPageSummary(
  documentUuid: json['document_uuid'] as String,
  pageCount: (json['page_count'] as num?)?.toInt() ?? 0,
  pages:
      (json['pages'] as List<dynamic>?)
          ?.map(
            (e) => MedicalDocumentPageSummaryItem.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const <MedicalDocumentPageSummaryItem>[],
);

Map<String, dynamic> _$MedicalDocumentPageSummaryToJson(
  _MedicalDocumentPageSummary instance,
) => <String, dynamic>{
  'document_uuid': instance.documentUuid,
  'page_count': instance.pageCount,
  'pages': instance.pages,
};

_MedicalDocumentPageDetail _$MedicalDocumentPageDetailFromJson(
  Map<String, dynamic> json,
) => _MedicalDocumentPageDetail(
  documentUuid: json['document_uuid'] as String,
  pageNumber: (json['page_number'] as num).toInt(),
  pageCount: (json['page_count'] as num?)?.toInt() ?? 0,
  reportSubtype: json['report_subtype'] as String? ?? ReportSubtype.unknown,
  processingStatus: json['processing_status'] as String? ?? '',
  processingFailureCode: json['processing_failure_code'] as String? ?? '',
  documentDate: json['document_date'] == null
      ? null
      : DateTime.parse(json['document_date'] as String),
  dateVerified: json['date_verified'] as bool? ?? false,
  dateSource: json['date_source'] as String? ?? '',
  labResultCount: (json['lab_result_count'] as num?)?.toInt() ?? 0,
  detectedCandidates:
      (json['detected_candidates'] as List<dynamic>?)
          ?.map((e) => DateCandidate.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <DateCandidate>[],
  labResults:
      (json['lab_results'] as List<dynamic>?)
          ?.map((e) => LabResultItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LabResultItem>[],
);

Map<String, dynamic> _$MedicalDocumentPageDetailToJson(
  _MedicalDocumentPageDetail instance,
) => <String, dynamic>{
  'document_uuid': instance.documentUuid,
  'page_number': instance.pageNumber,
  'page_count': instance.pageCount,
  'report_subtype': instance.reportSubtype,
  'processing_status': instance.processingStatus,
  'processing_failure_code': instance.processingFailureCode,
  'document_date': instance.documentDate?.toIso8601String(),
  'date_verified': instance.dateVerified,
  'date_source': instance.dateSource,
  'lab_result_count': instance.labResultCount,
  'detected_candidates': instance.detectedCandidates,
  'lab_results': instance.labResults,
};

_MedicalDocumentPageLabResults _$MedicalDocumentPageLabResultsFromJson(
  Map<String, dynamic> json,
) => _MedicalDocumentPageLabResults(
  documentUuid: json['document_uuid'] as String,
  pageNumber: (json['page_number'] as num).toInt(),
  extractionStatus: json['extraction_status'] as String? ?? '',
  resultCount: (json['result_count'] as num?)?.toInt() ?? 0,
  results:
      (json['results'] as List<dynamic>?)
          ?.map((e) => LabResultItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LabResultItem>[],
);

Map<String, dynamic> _$MedicalDocumentPageLabResultsToJson(
  _MedicalDocumentPageLabResults instance,
) => <String, dynamic>{
  'document_uuid': instance.documentUuid,
  'page_number': instance.pageNumber,
  'extraction_status': instance.extractionStatus,
  'result_count': instance.resultCount,
  'results': instance.results,
};
