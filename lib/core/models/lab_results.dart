// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'lab_results.freezed.dart';
part 'lab_results.g.dart';

/// One structured lab row exposed to the patient (read-only).
@freezed
abstract class LabResultItem with _$LabResultItem {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LabResultItem({
    required String uuid,
    @Default(1) int pageNumber,
    @Default(0) int rowIndex,
    @Default('') String testNameRaw,
    @Default('') String testNameNormalized,
    @Default('') String resultRaw,
    String? resultNumeric,
    @Default('') String resultText,
    @Default('') String unitRaw,
    @Default('') String unitNormalized,
    @Default('') String referenceRangeRaw,
    String? referenceLow,
    String? referenceHigh,
    @Default('') String flagRaw,
    @Default(0.0) double extractionConfidence,
  }) = _LabResultItem;

  factory LabResultItem.fromJson(Map<String, dynamic> json) =>
      _$LabResultItemFromJson(json);
}

/// Extracted lab results response for one document.
@freezed
abstract class LabResultsResponse with _$LabResultsResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LabResultsResponse({
    required String documentUuid,
    @Default('') String documentType,
    @Default('') String extractionStatus,
    String? pipelineVersion,
    @Default(0) int resultCount,
    @Default(<LabResultItem>[]) List<LabResultItem> results,
  }) = _LabResultsResponse;

  factory LabResultsResponse.fromJson(Map<String, dynamic> json) =>
      _$LabResultsResponseFromJson(json);
}

/// Backend extraction status values mirrored as constants.
class LabExtractionStatus {
  LabExtractionStatus._();

  static const queued = 'QUEUED';
  static const completed = 'COMPLETED';
  static const notApplicable = 'NOT_APPLICABLE';
  static const failed = 'FAILED';
}
