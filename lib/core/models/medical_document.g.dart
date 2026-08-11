// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoredFilePublic _$StoredFilePublicFromJson(Map<String, dynamic> json) =>
    _StoredFilePublic(
      originalFilename: json['original_filename'] as String? ?? '',
      mimeType: json['mime_type'] as String? ?? '',
      sizeBytes: (json['size_bytes'] as num?)?.toInt() ?? 0,
      pageCount: (json['page_count'] as num?)?.toInt(),
      integrityStatus: json['integrity_status'] == null
          ? IntegrityStatus.unknown
          : integrityStatusFromJson(json['integrity_status']),
      malwareScanStatus: json['malware_scan_status'] == null
          ? MalwareScanStatus.unknown
          : malwareScanStatusFromJson(json['malware_scan_status']),
    );

Map<String, dynamic> _$StoredFilePublicToJson(_StoredFilePublic instance) =>
    <String, dynamic>{
      'original_filename': instance.originalFilename,
      'mime_type': instance.mimeType,
      'size_bytes': instance.sizeBytes,
      'page_count': instance.pageCount,
      'integrity_status': _$IntegrityStatusEnumMap[instance.integrityStatus]!,
      'malware_scan_status':
          _$MalwareScanStatusEnumMap[instance.malwareScanStatus]!,
    };

const _$IntegrityStatusEnumMap = {
  IntegrityStatus.pending: 'pending',
  IntegrityStatus.valid: 'valid',
  IntegrityStatus.corrupted: 'corrupted',
  IntegrityStatus.quarantined: 'quarantined',
  IntegrityStatus.missing: 'missing',
  IntegrityStatus.unknown: 'unknown',
};

const _$MalwareScanStatusEnumMap = {
  MalwareScanStatus.notConfigured: 'notConfigured',
  MalwareScanStatus.clean: 'clean',
  MalwareScanStatus.infected: 'infected',
  MalwareScanStatus.error: 'error',
  MalwareScanStatus.unknown: 'unknown',
};

_MedicalDocument _$MedicalDocumentFromJson(Map<String, dynamic> json) =>
    _MedicalDocument(
      uuid: json['uuid'] as String,
      documentType: json['document_type'] == null
          ? MedicalDocumentType.unknown
          : medicalDocumentTypeFromJson(json['document_type']),
      classificationSource: json['classification_source'] == null
          ? ClassificationSource.unknown
          : classificationSourceFromJson(json['classification_source']),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      documentDate: json['document_date'] == null
          ? null
          : DateTime.parse(json['document_date'] as String),
      dateSource: json['date_source'] == null
          ? DateSource.unknown
          : dateSourceFromJson(json['date_source']),
      dateVerified: json['date_verified'] as bool? ?? false,
      dateVerifiedAt: json['date_verified_at'] == null
          ? null
          : DateTime.parse(json['date_verified_at'] as String),
      facilityName: json['facility_name'] as String? ?? '',
      healthcareFacility: json['healthcare_facility'] == null
          ? null
          : HealthcareFacility.fromJson(
              json['healthcare_facility'] as Map<String, dynamic>,
            ),
      locationText: json['location_text'] as String? ?? '',
      department: json['department'] as String? ?? '',
      physicianName: json['physician_name'] as String? ?? '',
      processingStatus: json['processing_status'] == null
          ? ProcessingStatus.unknown
          : processingStatusFromJson(json['processing_status']),
      archiveStatus: json['archive_status'] == null
          ? ArchiveStatus.unknown
          : archiveStatusFromJson(json['archive_status']),
      file: json['file'] == null
          ? null
          : StoredFilePublic.fromJson(json['file'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MedicalDocumentToJson(
  _MedicalDocument instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'document_type': _$MedicalDocumentTypeEnumMap[instance.documentType]!,
  'classification_source':
      _$ClassificationSourceEnumMap[instance.classificationSource]!,
  'title': instance.title,
  'description': instance.description,
  'document_date': instance.documentDate?.toIso8601String(),
  'date_source': _$DateSourceEnumMap[instance.dateSource]!,
  'date_verified': instance.dateVerified,
  'date_verified_at': instance.dateVerifiedAt?.toIso8601String(),
  'facility_name': instance.facilityName,
  'healthcare_facility': instance.healthcareFacility,
  'location_text': instance.locationText,
  'department': instance.department,
  'physician_name': instance.physicianName,
  'processing_status': _$ProcessingStatusEnumMap[instance.processingStatus]!,
  'archive_status': _$ArchiveStatusEnumMap[instance.archiveStatus]!,
  'file': instance.file,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$MedicalDocumentTypeEnumMap = {
  MedicalDocumentType.laboratory: 'laboratory',
  MedicalDocumentType.radiology: 'radiology',
  MedicalDocumentType.prescription: 'prescription',
  MedicalDocumentType.consultation: 'consultation',
  MedicalDocumentType.medicalReport: 'medicalReport',
  MedicalDocumentType.hospitalAdmission: 'hospitalAdmission',
  MedicalDocumentType.dischargeSummary: 'dischargeSummary',
  MedicalDocumentType.surgeryProcedure: 'surgeryProcedure',
  MedicalDocumentType.pathology: 'pathology',
  MedicalDocumentType.vaccination: 'vaccination',
  MedicalDocumentType.vitalSigns: 'vitalSigns',
  MedicalDocumentType.other: 'other',
  MedicalDocumentType.unknown: 'unknown',
};

const _$ClassificationSourceEnumMap = {
  ClassificationSource.userSelected: 'userSelected',
  ClassificationSource.guardianSelected: 'guardianSelected',
  ClassificationSource.systemDefault: 'systemDefault',
  ClassificationSource.unknown: 'unknown',
};

const _$DateSourceEnumMap = {
  DateSource.userEntered: 'userEntered',
  DateSource.pdfText: 'pdfText',
  DateSource.ocr: 'ocr',
  DateSource.userConfirmed: 'userConfirmed',
  DateSource.userCorrected: 'userCorrected',
  DateSource.unknown: 'unknown',
};

const _$ProcessingStatusEnumMap = {
  ProcessingStatus.uploaded: 'uploaded',
  ProcessingStatus.queued: 'queued',
  ProcessingStatus.processing: 'processing',
  ProcessingStatus.textExtracted: 'textExtracted',
  ProcessingStatus.ocrRequired: 'ocrRequired',
  ProcessingStatus.ocrProcessing: 'ocrProcessing',
  ProcessingStatus.dateProcessing: 'dateProcessing',
  ProcessingStatus.dateDetected: 'dateDetected',
  ProcessingStatus.dateNotFound: 'dateNotFound',
  ProcessingStatus.awaitingConfirmation: 'awaitingConfirmation',
  ProcessingStatus.dateConfirmed: 'dateConfirmed',
  ProcessingStatus.indexed: 'indexed',
  ProcessingStatus.failed: 'failed',
  ProcessingStatus.unknown: 'unknown',
};

const _$ArchiveStatusEnumMap = {
  ArchiveStatus.active: 'active',
  ArchiveStatus.deleted: 'deleted',
  ArchiveStatus.unknown: 'unknown',
};

_MedicalDocumentDetail _$MedicalDocumentDetailFromJson(
  Map<String, dynamic> json,
) => _MedicalDocumentDetail(
  uuid: json['uuid'] as String,
  documentType: json['document_type'] == null
      ? MedicalDocumentType.unknown
      : medicalDocumentTypeFromJson(json['document_type']),
  classificationSource: json['classification_source'] == null
      ? ClassificationSource.unknown
      : classificationSourceFromJson(json['classification_source']),
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  documentDate: json['document_date'] == null
      ? null
      : DateTime.parse(json['document_date'] as String),
  dateSource: json['date_source'] == null
      ? DateSource.unknown
      : dateSourceFromJson(json['date_source']),
  dateVerified: json['date_verified'] as bool? ?? false,
  dateVerifiedAt: json['date_verified_at'] == null
      ? null
      : DateTime.parse(json['date_verified_at'] as String),
  facilityName: json['facility_name'] as String? ?? '',
  healthcareFacility: json['healthcare_facility'] == null
      ? null
      : HealthcareFacility.fromJson(
          json['healthcare_facility'] as Map<String, dynamic>,
        ),
  locationText: json['location_text'] as String? ?? '',
  department: json['department'] as String? ?? '',
  physicianName: json['physician_name'] as String? ?? '',
  processingStatus: json['processing_status'] == null
      ? ProcessingStatus.unknown
      : processingStatusFromJson(json['processing_status']),
  archiveStatus: json['archive_status'] == null
      ? ArchiveStatus.unknown
      : archiveStatusFromJson(json['archive_status']),
  file: json['file'] == null
      ? null
      : StoredFilePublic.fromJson(json['file'] as Map<String, dynamic>),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  textAvailable: json['text_available'] as bool? ?? false,
);

Map<String, dynamic> _$MedicalDocumentDetailToJson(
  _MedicalDocumentDetail instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'document_type': _$MedicalDocumentTypeEnumMap[instance.documentType]!,
  'classification_source':
      _$ClassificationSourceEnumMap[instance.classificationSource]!,
  'title': instance.title,
  'description': instance.description,
  'document_date': instance.documentDate?.toIso8601String(),
  'date_source': _$DateSourceEnumMap[instance.dateSource]!,
  'date_verified': instance.dateVerified,
  'date_verified_at': instance.dateVerifiedAt?.toIso8601String(),
  'facility_name': instance.facilityName,
  'healthcare_facility': instance.healthcareFacility,
  'location_text': instance.locationText,
  'department': instance.department,
  'physician_name': instance.physicianName,
  'processing_status': _$ProcessingStatusEnumMap[instance.processingStatus]!,
  'archive_status': _$ArchiveStatusEnumMap[instance.archiveStatus]!,
  'file': instance.file,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'text_available': instance.textAvailable,
};

_DocumentDateConfirmationResponse _$DocumentDateConfirmationResponseFromJson(
  Map<String, dynamic> json,
) => _DocumentDateConfirmationResponse(
  uuid: json['uuid'] as String,
  documentDate: json['document_date'] == null
      ? null
      : DateTime.parse(json['document_date'] as String),
  dateSource: json['date_source'] == null
      ? DateSource.unknown
      : dateSourceFromJson(json['date_source']),
  dateVerified: json['date_verified'] as bool? ?? false,
  dateVerifiedAt: json['date_verified_at'] == null
      ? null
      : DateTime.parse(json['date_verified_at'] as String),
  processingStatus: json['processing_status'] == null
      ? ProcessingStatus.unknown
      : processingStatusFromJson(json['processing_status']),
);

Map<String, dynamic> _$DocumentDateConfirmationResponseToJson(
  _DocumentDateConfirmationResponse instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'document_date': instance.documentDate?.toIso8601String(),
  'date_source': _$DateSourceEnumMap[instance.dateSource]!,
  'date_verified': instance.dateVerified,
  'date_verified_at': instance.dateVerifiedAt?.toIso8601String(),
  'processing_status': _$ProcessingStatusEnumMap[instance.processingStatus]!,
};
