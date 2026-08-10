import 'package:freezed_annotation/freezed_annotation.dart';

import 'enum_json.dart';
import 'enums.dart';

part 'archive.freezed.dart';
part 'archive.g.dart';

@freezed
abstract class ArchiveFacilitySummary with _$ArchiveFacilitySummary {
  const factory ArchiveFacilitySummary({
    String? uuid,
    @Default('') String name,
  }) = _ArchiveFacilitySummary;

  factory ArchiveFacilitySummary.fromJson(Map<String, dynamic> json) =>
      _$ArchiveFacilitySummaryFromJson(json);
}

/// Archive list item — same shape as archive document.
@freezed
abstract class ArchiveDocument with _$ArchiveDocument {
  const factory ArchiveDocument({
    required String uuid,
    @Default('') String title,
    @JsonKey(fromJson: medicalDocumentTypeFromJson)
    @Default(MedicalDocumentType.unknown)
    MedicalDocumentType documentType,
    DateTime? documentDate,
    @Default(false) bool dateVerified,
    @JsonKey(fromJson: dateSourceFromJson)
    @Default(DateSource.unknown)
    DateSource dateSource,
    ArchiveFacilitySummary? healthcareFacility,
    @Default('') String facilityName,
    @Default('') String locationText,
    @Default('') String department,
    @Default('') String physicianName,
    @JsonKey(fromJson: processingStatusFromJson)
    @Default(ProcessingStatus.unknown)
    ProcessingStatus processingStatus,
    DateTime? createdAt,
  }) = _ArchiveDocument;

  factory ArchiveDocument.fromJson(Map<String, dynamic> json) =>
      _$ArchiveDocumentFromJson(json);
}

@freezed
abstract class ArchiveSummaryMonth with _$ArchiveSummaryMonth {
  const factory ArchiveSummaryMonth({
    @Default(0) int month,
    @Default(0) int count,
  }) = _ArchiveSummaryMonth;

  factory ArchiveSummaryMonth.fromJson(Map<String, dynamic> json) =>
      _$ArchiveSummaryMonthFromJson(json);
}

@freezed
abstract class ArchiveSummaryYear with _$ArchiveSummaryYear {
  const factory ArchiveSummaryYear({
    @Default(0) int year,
    @Default(0) int count,
    @Default(<ArchiveSummaryMonth>[]) List<ArchiveSummaryMonth> months,
  }) = _ArchiveSummaryYear;

  factory ArchiveSummaryYear.fromJson(Map<String, dynamic> json) =>
      _$ArchiveSummaryYearFromJson(json);
}

@freezed
abstract class ArchiveSummaryDocumentType with _$ArchiveSummaryDocumentType {
  const factory ArchiveSummaryDocumentType({
    @JsonKey(fromJson: medicalDocumentTypeFromJson)
    @Default(MedicalDocumentType.unknown)
    MedicalDocumentType documentType,
    @Default(0) int count,
  }) = _ArchiveSummaryDocumentType;

  factory ArchiveSummaryDocumentType.fromJson(Map<String, dynamic> json) =>
      _$ArchiveSummaryDocumentTypeFromJson(json);
}

@freezed
abstract class ArchiveSummaryFacility with _$ArchiveSummaryFacility {
  const factory ArchiveSummaryFacility({
    String? uuid,
    @Default('') String name,
    @Default(0) int count,
  }) = _ArchiveSummaryFacility;

  factory ArchiveSummaryFacility.fromJson(Map<String, dynamic> json) =>
      _$ArchiveSummaryFacilityFromJson(json);
}

@freezed
abstract class ArchiveSummary with _$ArchiveSummary {
  const factory ArchiveSummary({
    @Default(<ArchiveSummaryYear>[]) List<ArchiveSummaryYear> years,
    @Default(<ArchiveSummaryDocumentType>[])
    List<ArchiveSummaryDocumentType> documentTypes,
    @Default(<ArchiveSummaryFacility>[])
    List<ArchiveSummaryFacility> facilities,
    @Default(0) int unconfirmedDateCount,
  }) = _ArchiveSummary;

  factory ArchiveSummary.fromJson(Map<String, dynamic> json) =>
      _$ArchiveSummaryFromJson(json);
}
