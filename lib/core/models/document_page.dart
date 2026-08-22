// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'date_candidate.dart';
import 'enum_json.dart';
import 'enums.dart';
import 'lab_results.dart';

part 'document_page.freezed.dart';
part 'document_page.g.dart';

/// Report-subtype values mirrored from the backend (layout metadata only).
class ReportSubtype {
  ReportSubtype._();

  static const labChemistry = 'LAB_CHEMISTRY';
  static const labHormones = 'LAB_HORMONES';
  static const labCbc = 'LAB_CBC';
  static const radiology = 'RADIOLOGY';
  static const narrative = 'NARRATIVE';
  static const unknown = 'UNKNOWN';
}

/// One page/report-unit summary row in the document pages list.
@freezed
abstract class MedicalDocumentPageSummaryItem
    with _$MedicalDocumentPageSummaryItem {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MedicalDocumentPageSummaryItem({
    required int pageNumber,
    @Default(ReportSubtype.unknown) String reportSubtype,
    @Default('') String processingStatus,
    DateTime? documentDate,
    @Default(false) bool dateVerified,
    @Default(0) int labResultCount,
    @Default(0) int dateCandidateCount,
  }) = _MedicalDocumentPageSummaryItem;

  factory MedicalDocumentPageSummaryItem.fromJson(Map<String, dynamic> json) =>
      _$MedicalDocumentPageSummaryItemFromJson(json);
}

/// Document pages summary response (`GET /documents/{uuid}/pages/`).
@freezed
abstract class MedicalDocumentPageSummary with _$MedicalDocumentPageSummary {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MedicalDocumentPageSummary({
    required String documentUuid,
    @Default(0) int pageCount,
    @Default(<MedicalDocumentPageSummaryItem>[])
    List<MedicalDocumentPageSummaryItem> pages,
  }) = _MedicalDocumentPageSummary;

  factory MedicalDocumentPageSummary.fromJson(Map<String, dynamic> json) =>
      _$MedicalDocumentPageSummaryFromJson(json);
}

/// One page detail with its own candidates + structured results.
@freezed
abstract class MedicalDocumentPageDetail with _$MedicalDocumentPageDetail {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MedicalDocumentPageDetail({
    required String documentUuid,
    required int pageNumber,
    @Default(0) int pageCount,
    @Default(ReportSubtype.unknown) String reportSubtype,
    @Default('') String processingStatus,
    @Default('') String processingFailureCode,
    DateTime? documentDate,
    @Default(false) bool dateVerified,
    @Default('') String dateSource,
    @Default(0) int labResultCount,
    @Default(<DateCandidate>[]) List<DateCandidate> detectedCandidates,
    @Default(<LabResultItem>[]) List<LabResultItem> labResults,
  }) = _MedicalDocumentPageDetail;

  factory MedicalDocumentPageDetail.fromJson(Map<String, dynamic> json) =>
      _$MedicalDocumentPageDetailFromJson(json);
}

/// Page lab-results response (`GET .../pages/{n}/lab-results/`).
@freezed
abstract class MedicalDocumentPageLabResults
    with _$MedicalDocumentPageLabResults {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MedicalDocumentPageLabResults({
    required String documentUuid,
    required int pageNumber,
    @Default('') String extractionStatus,
    @Default(0) int resultCount,
    @Default(<LabResultItem>[]) List<LabResultItem> results,
  }) = _MedicalDocumentPageLabResults;

  factory MedicalDocumentPageLabResults.fromJson(Map<String, dynamic> json) =>
      _$MedicalDocumentPageLabResultsFromJson(json);
}
