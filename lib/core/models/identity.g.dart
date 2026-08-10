// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IdentityDocumentSummary _$IdentityDocumentSummaryFromJson(
  Map<String, dynamic> json,
) => _IdentityDocumentSummary(
  uuid: json['uuid'] as String,
  documentType: json['documentType'] == null
      ? IdentityDocumentType.unknown
      : identityDocumentTypeFromJson(json['documentType']),
  issuingCountry: json['issuingCountry'] as String? ?? '',
  issueDate: json['issueDate'] == null
      ? null
      : DateTime.parse(json['issueDate'] as String),
  expiryDate: json['expiryDate'] == null
      ? null
      : DateTime.parse(json['expiryDate'] as String),
  verificationStatus: json['verificationStatus'] == null
      ? VerificationStatus.unknown
      : verificationStatusFromJson(json['verificationStatus']),
  status: json['status'] == null
      ? IdentityDocumentLifecycleStatus.unknown
      : identityLifecycleFromJson(json['status']),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$IdentityDocumentSummaryToJson(
  _IdentityDocumentSummary instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'documentType': _$IdentityDocumentTypeEnumMap[instance.documentType]!,
  'issuingCountry': instance.issuingCountry,
  'issueDate': instance.issueDate?.toIso8601String(),
  'expiryDate': instance.expiryDate?.toIso8601String(),
  'verificationStatus':
      _$VerificationStatusEnumMap[instance.verificationStatus]!,
  'status': _$IdentityDocumentLifecycleStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
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
  documentType: json['documentType'] == null
      ? IdentityDocumentType.unknown
      : identityDocumentTypeFromJson(json['documentType']),
  issuingCountry: json['issuingCountry'] as String? ?? '',
  issueDate: json['issueDate'] == null
      ? null
      : DateTime.parse(json['issueDate'] as String),
  expiryDate: json['expiryDate'] == null
      ? null
      : DateTime.parse(json['expiryDate'] as String),
  verificationStatus: json['verificationStatus'] == null
      ? VerificationStatus.unknown
      : verificationStatusFromJson(json['verificationStatus']),
  status: json['status'] == null
      ? IdentityDocumentLifecycleStatus.unknown
      : identityLifecycleFromJson(json['status']),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  documentNumber: json['documentNumber'] as String? ?? '',
  nationalNumber: json['nationalNumber'] as String? ?? '',
  familyNumber: json['familyNumber'] as String? ?? '',
  verifiedAt: json['verifiedAt'] == null
      ? null
      : DateTime.parse(json['verifiedAt'] as String),
  rejectionReason: json['rejectionReason'] as String? ?? '',
  availableImages:
      (json['availableImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  replaces: json['replaces'] as String?,
);

Map<String, dynamic> _$IdentityDocumentDetailToJson(
  _IdentityDocumentDetail instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'documentType': _$IdentityDocumentTypeEnumMap[instance.documentType]!,
  'issuingCountry': instance.issuingCountry,
  'issueDate': instance.issueDate?.toIso8601String(),
  'expiryDate': instance.expiryDate?.toIso8601String(),
  'verificationStatus':
      _$VerificationStatusEnumMap[instance.verificationStatus]!,
  'status': _$IdentityDocumentLifecycleStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'documentNumber': instance.documentNumber,
  'nationalNumber': instance.nationalNumber,
  'familyNumber': instance.familyNumber,
  'verifiedAt': instance.verifiedAt?.toIso8601String(),
  'rejectionReason': instance.rejectionReason,
  'availableImages': instance.availableImages,
  'replaces': instance.replaces,
};
