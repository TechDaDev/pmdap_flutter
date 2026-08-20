// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'enum_json.dart';
import 'enums.dart';
import 'facility.dart';

part 'medical_document.freezed.dart';
part 'medical_document.g.dart';

/// Public file metadata embedded in a medical document.
@freezed
abstract class StoredFilePublic with _$StoredFilePublic {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory StoredFilePublic({
    @Default('') String originalFilename,
    @Default('') String mimeType,
    @Default(0) int sizeBytes,
    int? pageCount,
    @JsonKey(fromJson: integrityStatusFromJson)
    @Default(IntegrityStatus.unknown)
    IntegrityStatus integrityStatus,
    @JsonKey(fromJson: malwareScanStatusFromJson)
    @Default(MalwareScanStatus.unknown)
    MalwareScanStatus malwareScanStatus,
  }) = _StoredFilePublic;

  factory StoredFilePublic.fromJson(Map<String, dynamic> json) =>
      _$StoredFilePublicFromJson(json);
}

/// Medical document list item (`MedicalDocument`).
@freezed
abstract class MedicalDocument with _$MedicalDocument {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MedicalDocument({
    required String uuid,
    @JsonKey(fromJson: medicalDocumentTypeFromJson)
    @Default(MedicalDocumentType.unknown)
    MedicalDocumentType documentType,
    @JsonKey(fromJson: classificationSourceFromJson)
    @Default(ClassificationSource.unknown)
    ClassificationSource classificationSource,
    @Default('') String title,
    @Default('') String description,
    DateTime? documentDate,
    @JsonKey(fromJson: dateSourceFromJson)
    @Default(DateSource.unknown)
    DateSource dateSource,
    @Default(false) bool dateVerified,
    DateTime? dateVerifiedAt,
    @Default('') String facilityName,
    HealthcareFacility? healthcareFacility,
    @Default('') String locationText,
    @Default('') String department,
    @Default('') String physicianName,
    @JsonKey(fromJson: processingStatusFromJson)
    @Default(ProcessingStatus.unknown)
    ProcessingStatus processingStatus,
    @JsonKey(fromJson: archiveStatusFromJson)
    @Default(ArchiveStatus.unknown)
    ArchiveStatus archiveStatus,
    StoredFilePublic? file,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MedicalDocument;

  factory MedicalDocument.fromJson(Map<String, dynamic> json) =>
      _$MedicalDocumentFromJson(json);
}

/// Medical document detail (`MedicalDocumentDetail`).
@freezed
abstract class MedicalDocumentDetail with _$MedicalDocumentDetail {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MedicalDocumentDetail({
    required String uuid,
    @JsonKey(fromJson: medicalDocumentTypeFromJson)
    @Default(MedicalDocumentType.unknown)
    MedicalDocumentType documentType,
    @JsonKey(fromJson: classificationSourceFromJson)
    @Default(ClassificationSource.unknown)
    ClassificationSource classificationSource,
    @Default('') String title,
    @Default('') String description,
    DateTime? documentDate,
    @JsonKey(fromJson: dateSourceFromJson)
    @Default(DateSource.unknown)
    DateSource dateSource,
    @Default(false) bool dateVerified,
    DateTime? dateVerifiedAt,
    @Default('') String facilityName,
    HealthcareFacility? healthcareFacility,
    @Default('') String locationText,
    @Default('') String department,
    @Default('') String physicianName,
    @JsonKey(fromJson: processingStatusFromJson)
    @Default(ProcessingStatus.unknown)
    ProcessingStatus processingStatus,
    @JsonKey(fromJson: archiveStatusFromJson)
    @Default(ArchiveStatus.unknown)
    ArchiveStatus archiveStatus,
    StoredFilePublic? file,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool textAvailable,

    /// Existing document uuid when this upload was flagged as a content
    /// duplicate (owner-scoped). Null otherwise.
    String? duplicateOf,
  }) = _MedicalDocumentDetail;

  factory MedicalDocumentDetail.fromJson(Map<String, dynamic> json) =>
      _$MedicalDocumentDetailFromJson(json);
}

/// Response payload of confirm-date (`DocumentDateConfirmationResponse`).
@freezed
abstract class DocumentDateConfirmationResponse
    with _$DocumentDateConfirmationResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory DocumentDateConfirmationResponse({
    required String uuid,
    DateTime? documentDate,
    @JsonKey(fromJson: dateSourceFromJson)
    @Default(DateSource.unknown)
    DateSource dateSource,
    @Default(false) bool dateVerified,
    DateTime? dateVerifiedAt,
    @JsonKey(fromJson: processingStatusFromJson)
    @Default(ProcessingStatus.unknown)
    ProcessingStatus processingStatus,
  }) = _DocumentDateConfirmationResponse;

  factory DocumentDateConfirmationResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$DocumentDateConfirmationResponseFromJson(json);
}
