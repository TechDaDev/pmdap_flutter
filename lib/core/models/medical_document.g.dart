// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoredFilePublic _$StoredFilePublicFromJson(Map<String, dynamic> json) =>
    _StoredFilePublic(
      originalFilename: json['originalFilename'] as String? ?? '',
      mimeType: json['mimeType'] as String? ?? '',
      sizeBytes: (json['sizeBytes'] as num?)?.toInt() ?? 0,
      pageCount: (json['pageCount'] as num?)?.toInt(),
      integrityStatus: json['integrityStatus'] == null
          ? IntegrityStatus.unknown
          : integrityStatusFromJson(json['integrityStatus']),
      malwareScanStatus: json['malwareScanStatus'] == null
          ? MalwareScanStatus.unknown
          : malwareScanStatusFromJson(json['malwareScanStatus']),
    );

Map<String, dynamic> _$StoredFilePublicToJson(
  _StoredFilePublic instance,
) => <String, dynamic>{
  'originalFilename': instance.originalFilename,
  'mimeType': instance.mimeType,
  'sizeBytes': instance.sizeBytes,
  'pageCount': instance.pageCount,
  'integrityStatus': _$IntegrityStatusEnumMap[instance.integrityStatus]!,
  'malwareScanStatus': _$MalwareScanStatusEnumMap[instance.malwareScanStatus]!,
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
      documentType: json['documentType'] == null
          ? MedicalDocumentType.unknown
          : medicalDocumentTypeFromJson(json['documentType']),
      classificationSource: json['classificationSource'] == null
          ? ClassificationSource.unknown
          : classificationSourceFromJson(json['classificationSource']),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      documentDate: json['documentDate'] == null
          ? null
          : DateTime.parse(json['documentDate'] as String),
      dateSource: json['dateSource'] == null
          ? DateSource.unknown
          : dateSourceFromJson(json['dateSource']),
      dateVerified: json['dateVerified'] as bool? ?? false,
      dateVerifiedAt: json['dateVerifiedAt'] == null
          ? null
          : DateTime.parse(json['dateVerifiedAt'] as String),
      facilityName: json['facilityName'] as String? ?? '',
      healthcareFacility: json['healthcareFacility'] == null
          ? null
          : HealthcareFacility.fromJson(
              json['healthcareFacility'] as Map<String, dynamic>,
            ),
      locationText: json['locationText'] as String? ?? '',
      department: json['department'] as String? ?? '',
      physicianName: json['physicianName'] as String? ?? '',
      processingStatus: json['processingStatus'] == null
          ? ProcessingStatus.unknown
          : processingStatusFromJson(json['processingStatus']),
      archiveStatus: json['archiveStatus'] == null
          ? ArchiveStatus.unknown
          : archiveStatusFromJson(json['archiveStatus']),
      file: json['file'] == null
          ? null
          : StoredFilePublic.fromJson(json['file'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MedicalDocumentToJson(_MedicalDocument instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'documentType': _$MedicalDocumentTypeEnumMap[instance.documentType]!,
      'classificationSource':
          _$ClassificationSourceEnumMap[instance.classificationSource]!,
      'title': instance.title,
      'description': instance.description,
      'documentDate': instance.documentDate?.toIso8601String(),
      'dateSource': _$DateSourceEnumMap[instance.dateSource]!,
      'dateVerified': instance.dateVerified,
      'dateVerifiedAt': instance.dateVerifiedAt?.toIso8601String(),
      'facilityName': instance.facilityName,
      'healthcareFacility': instance.healthcareFacility,
      'locationText': instance.locationText,
      'department': instance.department,
      'physicianName': instance.physicianName,
      'processingStatus': _$ProcessingStatusEnumMap[instance.processingStatus]!,
      'archiveStatus': _$ArchiveStatusEnumMap[instance.archiveStatus]!,
      'file': instance.file,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
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
  documentType: json['documentType'] == null
      ? MedicalDocumentType.unknown
      : medicalDocumentTypeFromJson(json['documentType']),
  classificationSource: json['classificationSource'] == null
      ? ClassificationSource.unknown
      : classificationSourceFromJson(json['classificationSource']),
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  documentDate: json['documentDate'] == null
      ? null
      : DateTime.parse(json['documentDate'] as String),
  dateSource: json['dateSource'] == null
      ? DateSource.unknown
      : dateSourceFromJson(json['dateSource']),
  dateVerified: json['dateVerified'] as bool? ?? false,
  dateVerifiedAt: json['dateVerifiedAt'] == null
      ? null
      : DateTime.parse(json['dateVerifiedAt'] as String),
  facilityName: json['facilityName'] as String? ?? '',
  healthcareFacility: json['healthcareFacility'] == null
      ? null
      : HealthcareFacility.fromJson(
          json['healthcareFacility'] as Map<String, dynamic>,
        ),
  locationText: json['locationText'] as String? ?? '',
  department: json['department'] as String? ?? '',
  physicianName: json['physicianName'] as String? ?? '',
  processingStatus: json['processingStatus'] == null
      ? ProcessingStatus.unknown
      : processingStatusFromJson(json['processingStatus']),
  archiveStatus: json['archiveStatus'] == null
      ? ArchiveStatus.unknown
      : archiveStatusFromJson(json['archiveStatus']),
  file: json['file'] == null
      ? null
      : StoredFilePublic.fromJson(json['file'] as Map<String, dynamic>),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  textAvailable: json['textAvailable'] as bool? ?? false,
);

Map<String, dynamic> _$MedicalDocumentDetailToJson(
  _MedicalDocumentDetail instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'documentType': _$MedicalDocumentTypeEnumMap[instance.documentType]!,
  'classificationSource':
      _$ClassificationSourceEnumMap[instance.classificationSource]!,
  'title': instance.title,
  'description': instance.description,
  'documentDate': instance.documentDate?.toIso8601String(),
  'dateSource': _$DateSourceEnumMap[instance.dateSource]!,
  'dateVerified': instance.dateVerified,
  'dateVerifiedAt': instance.dateVerifiedAt?.toIso8601String(),
  'facilityName': instance.facilityName,
  'healthcareFacility': instance.healthcareFacility,
  'locationText': instance.locationText,
  'department': instance.department,
  'physicianName': instance.physicianName,
  'processingStatus': _$ProcessingStatusEnumMap[instance.processingStatus]!,
  'archiveStatus': _$ArchiveStatusEnumMap[instance.archiveStatus]!,
  'file': instance.file,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'textAvailable': instance.textAvailable,
};

_DocumentDateConfirmationResponse _$DocumentDateConfirmationResponseFromJson(
  Map<String, dynamic> json,
) => _DocumentDateConfirmationResponse(
  uuid: json['uuid'] as String,
  documentDate: json['documentDate'] == null
      ? null
      : DateTime.parse(json['documentDate'] as String),
  dateSource: json['dateSource'] == null
      ? DateSource.unknown
      : dateSourceFromJson(json['dateSource']),
  dateVerified: json['dateVerified'] as bool? ?? false,
  dateVerifiedAt: json['dateVerifiedAt'] == null
      ? null
      : DateTime.parse(json['dateVerifiedAt'] as String),
  processingStatus: json['processingStatus'] == null
      ? ProcessingStatus.unknown
      : processingStatusFromJson(json['processingStatus']),
);

Map<String, dynamic> _$DocumentDateConfirmationResponseToJson(
  _DocumentDateConfirmationResponse instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'documentDate': instance.documentDate?.toIso8601String(),
  'dateSource': _$DateSourceEnumMap[instance.dateSource]!,
  'dateVerified': instance.dateVerified,
  'dateVerifiedAt': instance.dateVerifiedAt?.toIso8601String(),
  'processingStatus': _$ProcessingStatusEnumMap[instance.processingStatus]!,
};
