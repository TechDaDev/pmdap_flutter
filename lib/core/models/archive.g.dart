// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArchiveFacilitySummary _$ArchiveFacilitySummaryFromJson(
  Map<String, dynamic> json,
) => _ArchiveFacilitySummary(
  uuid: json['uuid'] as String?,
  name: json['name'] as String? ?? '',
);

Map<String, dynamic> _$ArchiveFacilitySummaryToJson(
  _ArchiveFacilitySummary instance,
) => <String, dynamic>{'uuid': instance.uuid, 'name': instance.name};

_ArchiveDocument _$ArchiveDocumentFromJson(Map<String, dynamic> json) =>
    _ArchiveDocument(
      uuid: json['uuid'] as String,
      title: json['title'] as String? ?? '',
      documentType: json['document_type'] == null
          ? MedicalDocumentType.unknown
          : medicalDocumentTypeFromJson(json['document_type']),
      documentDate: json['document_date'] == null
          ? null
          : DateTime.parse(json['document_date'] as String),
      dateVerified: json['date_verified'] as bool? ?? false,
      dateSource: json['date_source'] == null
          ? DateSource.unknown
          : dateSourceFromJson(json['date_source']),
      healthcareFacility: json['healthcare_facility'] == null
          ? null
          : ArchiveFacilitySummary.fromJson(
              json['healthcare_facility'] as Map<String, dynamic>,
            ),
      facilityName: json['facility_name'] as String? ?? '',
      locationText: json['location_text'] as String? ?? '',
      department: json['department'] as String? ?? '',
      physicianName: json['physician_name'] as String? ?? '',
      processingStatus: json['processing_status'] == null
          ? ProcessingStatus.unknown
          : processingStatusFromJson(json['processing_status']),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      file: json['file'] == null
          ? null
          : StoredFilePublic.fromJson(json['file'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ArchiveDocumentToJson(
  _ArchiveDocument instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'title': instance.title,
  'document_type': _$MedicalDocumentTypeEnumMap[instance.documentType]!,
  'document_date': instance.documentDate?.toIso8601String(),
  'date_verified': instance.dateVerified,
  'date_source': _$DateSourceEnumMap[instance.dateSource]!,
  'healthcare_facility': instance.healthcareFacility,
  'facility_name': instance.facilityName,
  'location_text': instance.locationText,
  'department': instance.department,
  'physician_name': instance.physicianName,
  'processing_status': _$ProcessingStatusEnumMap[instance.processingStatus]!,
  'created_at': instance.createdAt?.toIso8601String(),
  'file': instance.file,
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
  ProcessingStatus.duplicateDetected: 'duplicateDetected',
  ProcessingStatus.partial: 'partial',
  ProcessingStatus.failed: 'failed',
  ProcessingStatus.unknown: 'unknown',
};

_ArchiveSummaryMonth _$ArchiveSummaryMonthFromJson(Map<String, dynamic> json) =>
    _ArchiveSummaryMonth(
      month: (json['month'] as num?)?.toInt() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ArchiveSummaryMonthToJson(
  _ArchiveSummaryMonth instance,
) => <String, dynamic>{'month': instance.month, 'count': instance.count};

_ArchiveSummaryYear _$ArchiveSummaryYearFromJson(Map<String, dynamic> json) =>
    _ArchiveSummaryYear(
      year: (json['year'] as num?)?.toInt() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
      months:
          (json['months'] as List<dynamic>?)
              ?.map(
                (e) => ArchiveSummaryMonth.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <ArchiveSummaryMonth>[],
    );

Map<String, dynamic> _$ArchiveSummaryYearToJson(_ArchiveSummaryYear instance) =>
    <String, dynamic>{
      'year': instance.year,
      'count': instance.count,
      'months': instance.months,
    };

_ArchiveSummaryDocumentType _$ArchiveSummaryDocumentTypeFromJson(
  Map<String, dynamic> json,
) => _ArchiveSummaryDocumentType(
  documentType: json['document_type'] == null
      ? MedicalDocumentType.unknown
      : medicalDocumentTypeFromJson(json['document_type']),
  count: (json['count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ArchiveSummaryDocumentTypeToJson(
  _ArchiveSummaryDocumentType instance,
) => <String, dynamic>{
  'document_type': _$MedicalDocumentTypeEnumMap[instance.documentType]!,
  'count': instance.count,
};

_ArchiveSummaryFacility _$ArchiveSummaryFacilityFromJson(
  Map<String, dynamic> json,
) => _ArchiveSummaryFacility(
  uuid: json['uuid'] as String?,
  name: json['name'] as String? ?? '',
  count: (json['count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ArchiveSummaryFacilityToJson(
  _ArchiveSummaryFacility instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'count': instance.count,
};

_ArchiveSummary _$ArchiveSummaryFromJson(
  Map<String, dynamic> json,
) => _ArchiveSummary(
  years:
      (json['years'] as List<dynamic>?)
          ?.map((e) => ArchiveSummaryYear.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ArchiveSummaryYear>[],
  documentTypes:
      (json['document_types'] as List<dynamic>?)
          ?.map(
            (e) =>
                ArchiveSummaryDocumentType.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <ArchiveSummaryDocumentType>[],
  facilities:
      (json['facilities'] as List<dynamic>?)
          ?.map(
            (e) => ArchiveSummaryFacility.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <ArchiveSummaryFacility>[],
  unconfirmedDateCount: (json['unconfirmed_date_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ArchiveSummaryToJson(_ArchiveSummary instance) =>
    <String, dynamic>{
      'years': instance.years,
      'document_types': instance.documentTypes,
      'facilities': instance.facilities,
      'unconfirmed_date_count': instance.unconfirmedDateCount,
    };
