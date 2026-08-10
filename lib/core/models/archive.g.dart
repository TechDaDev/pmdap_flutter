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
      documentType: json['documentType'] == null
          ? MedicalDocumentType.unknown
          : medicalDocumentTypeFromJson(json['documentType']),
      documentDate: json['documentDate'] == null
          ? null
          : DateTime.parse(json['documentDate'] as String),
      dateVerified: json['dateVerified'] as bool? ?? false,
      dateSource: json['dateSource'] == null
          ? DateSource.unknown
          : dateSourceFromJson(json['dateSource']),
      healthcareFacility: json['healthcareFacility'] == null
          ? null
          : ArchiveFacilitySummary.fromJson(
              json['healthcareFacility'] as Map<String, dynamic>,
            ),
      facilityName: json['facilityName'] as String? ?? '',
      locationText: json['locationText'] as String? ?? '',
      department: json['department'] as String? ?? '',
      physicianName: json['physicianName'] as String? ?? '',
      processingStatus: json['processingStatus'] == null
          ? ProcessingStatus.unknown
          : processingStatusFromJson(json['processingStatus']),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ArchiveDocumentToJson(_ArchiveDocument instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'title': instance.title,
      'documentType': _$MedicalDocumentTypeEnumMap[instance.documentType]!,
      'documentDate': instance.documentDate?.toIso8601String(),
      'dateVerified': instance.dateVerified,
      'dateSource': _$DateSourceEnumMap[instance.dateSource]!,
      'healthcareFacility': instance.healthcareFacility,
      'facilityName': instance.facilityName,
      'locationText': instance.locationText,
      'department': instance.department,
      'physicianName': instance.physicianName,
      'processingStatus': _$ProcessingStatusEnumMap[instance.processingStatus]!,
      'createdAt': instance.createdAt?.toIso8601String(),
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
  documentType: json['documentType'] == null
      ? MedicalDocumentType.unknown
      : medicalDocumentTypeFromJson(json['documentType']),
  count: (json['count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ArchiveSummaryDocumentTypeToJson(
  _ArchiveSummaryDocumentType instance,
) => <String, dynamic>{
  'documentType': _$MedicalDocumentTypeEnumMap[instance.documentType]!,
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
      (json['documentTypes'] as List<dynamic>?)
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
  unconfirmedDateCount: (json['unconfirmedDateCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ArchiveSummaryToJson(_ArchiveSummary instance) =>
    <String, dynamic>{
      'years': instance.years,
      'documentTypes': instance.documentTypes,
      'facilities': instance.facilities,
      'unconfirmedDateCount': instance.unconfirmedDateCount,
    };
