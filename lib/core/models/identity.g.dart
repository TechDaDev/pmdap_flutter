// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IdentityDocumentSummary _$IdentityDocumentSummaryFromJson(
  Map<String, dynamic> json,
) => _IdentityDocumentSummary(
  uuid: json['uuid'] as String,
  documentType: json['document_type'] == null
      ? IdentityDocumentType.unknown
      : identityDocumentTypeFromJson(json['document_type']),
  issuingCountry: json['issuing_country'] as String? ?? '',
  issueDate: json['issue_date'] == null
      ? null
      : DateTime.parse(json['issue_date'] as String),
  expiryDate: json['expiry_date'] == null
      ? null
      : DateTime.parse(json['expiry_date'] as String),
  verificationStatus: json['verification_status'] == null
      ? VerificationStatus.unknown
      : verificationStatusFromJson(json['verification_status']),
  status: json['status'] == null
      ? IdentityDocumentLifecycleStatus.unknown
      : identityLifecycleFromJson(json['status']),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$IdentityDocumentSummaryToJson(
  _IdentityDocumentSummary instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'document_type': _$IdentityDocumentTypeEnumMap[instance.documentType]!,
  'issuing_country': instance.issuingCountry,
  'issue_date': instance.issueDate?.toIso8601String(),
  'expiry_date': instance.expiryDate?.toIso8601String(),
  'verification_status':
      _$VerificationStatusEnumMap[instance.verificationStatus]!,
  'status': _$IdentityDocumentLifecycleStatusEnumMap[instance.status]!,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$IdentityDocumentTypeEnumMap = {
  IdentityDocumentType.unifiedNationalCard: 'unifiedNationalCard',
  IdentityDocumentType.passport: 'passport',
  IdentityDocumentType.birthDocument: 'birthDocument',
  IdentityDocumentType.otherGovernmentId: 'otherGovernmentId',
  IdentityDocumentType.unknown: 'unknown',
};

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'pending',
  VerificationStatus.verified: 'verified',
  VerificationStatus.rejected: 'rejected',
  VerificationStatus.unknown: 'unknown',
};

const _$IdentityDocumentLifecycleStatusEnumMap = {
  IdentityDocumentLifecycleStatus.current: 'current',
  IdentityDocumentLifecycleStatus.expired: 'expired',
  IdentityDocumentLifecycleStatus.replaced: 'replaced',
  IdentityDocumentLifecycleStatus.revoked: 'revoked',
  IdentityDocumentLifecycleStatus.unknown: 'unknown',
};

_IdentityDocumentDetail _$IdentityDocumentDetailFromJson(
  Map<String, dynamic> json,
) => _IdentityDocumentDetail(
  uuid: json['uuid'] as String,
  documentType: json['document_type'] == null
      ? IdentityDocumentType.unknown
      : identityDocumentTypeFromJson(json['document_type']),
  issuingCountry: json['issuing_country'] as String? ?? '',
  issueDate: json['issue_date'] == null
      ? null
      : DateTime.parse(json['issue_date'] as String),
  expiryDate: json['expiry_date'] == null
      ? null
      : DateTime.parse(json['expiry_date'] as String),
  verificationStatus: json['verification_status'] == null
      ? VerificationStatus.unknown
      : verificationStatusFromJson(json['verification_status']),
  status: json['status'] == null
      ? IdentityDocumentLifecycleStatus.unknown
      : identityLifecycleFromJson(json['status']),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  documentNumber: json['document_number'] as String? ?? '',
  nationalNumber: json['national_number'] as String? ?? '',
  familyNumber: json['family_number'] as String? ?? '',
  verifiedAt: json['verified_at'] == null
      ? null
      : DateTime.parse(json['verified_at'] as String),
  rejectionReason: json['rejection_reason'] as String? ?? '',
  availableImages:
      (json['available_images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  replaces: json['replaces'] as String?,
);

Map<String, dynamic> _$IdentityDocumentDetailToJson(
  _IdentityDocumentDetail instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'document_type': _$IdentityDocumentTypeEnumMap[instance.documentType]!,
  'issuing_country': instance.issuingCountry,
  'issue_date': instance.issueDate?.toIso8601String(),
  'expiry_date': instance.expiryDate?.toIso8601String(),
  'verification_status':
      _$VerificationStatusEnumMap[instance.verificationStatus]!,
  'status': _$IdentityDocumentLifecycleStatusEnumMap[instance.status]!,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'document_number': instance.documentNumber,
  'national_number': instance.nationalNumber,
  'family_number': instance.familyNumber,
  'verified_at': instance.verifiedAt?.toIso8601String(),
  'rejection_reason': instance.rejectionReason,
  'available_images': instance.availableImages,
  'replaces': instance.replaces,
};
