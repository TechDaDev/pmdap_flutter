// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GuardianRelationship _$GuardianRelationshipFromJson(
  Map<String, dynamic> json,
) => _GuardianRelationship(
  uuid: json['uuid'] as String,
  relationship: json['relationship'] == null
      ? Relationship.unknown
      : relationshipFromJson(json['relationship']),
  verificationStatus: json['verification_status'] == null
      ? VerificationStatus.unknown
      : verificationStatusFromJson(json['verification_status']),
  active: json['active'] as bool? ?? false,
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  verifiedAt: json['verified_at'] == null
      ? null
      : DateTime.parse(json['verified_at'] as String),
  endedAt: json['ended_at'] == null
      ? null
      : DateTime.parse(json['ended_at'] as String),
  endedReason: json['ended_reason'] as String?,
);

Map<String, dynamic> _$GuardianRelationshipToJson(
  _GuardianRelationship instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'relationship': _$RelationshipEnumMap[instance.relationship]!,
  'verification_status':
      _$VerificationStatusEnumMap[instance.verificationStatus]!,
  'active': instance.active,
  'started_at': instance.startedAt?.toIso8601String(),
  'verified_at': instance.verifiedAt?.toIso8601String(),
  'ended_at': instance.endedAt?.toIso8601String(),
  'ended_reason': instance.endedReason,
};

const _$RelationshipEnumMap = {
  Relationship.father: 'father',
  Relationship.mother: 'mother',
  Relationship.legalGuardian: 'legalGuardian',
  Relationship.unknown: 'unknown',
};

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'pending',
  VerificationStatus.verified: 'verified',
  VerificationStatus.rejected: 'rejected',
  VerificationStatus.unknown: 'unknown',
};

_Minor _$MinorFromJson(Map<String, dynamic> json) => _Minor(
  uuid: json['uuid'] as String,
  digitalId: json['digital_id'] as String,
  fullName: json['full_name'] as String,
  dateOfBirth: json['date_of_birth'] == null
      ? null
      : DateTime.parse(json['date_of_birth'] as String),
  age: (json['age'] as num?)?.toInt() ?? 0,
  isMinor: json['is_minor'] as bool? ?? false,
  sex: json['sex'] == null ? Sex.unknown : sexFromJson(json['sex']),
  nationality: json['nationality'] as String? ?? '',
  bloodGroup: json['blood_group'] == null
      ? BloodGroup.unknown
      : bloodGroupFromJson(json['blood_group']),
  identityStatus: json['identity_status'] == null
      ? IdentityStatus.unknown
      : identityStatusFromJson(json['identity_status']),
  relationship: json['relationship'] == null
      ? null
      : GuardianRelationship.fromJson(
          json['relationship'] as Map<String, dynamic>,
        ),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$MinorToJson(_Minor instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'digital_id': instance.digitalId,
  'full_name': instance.fullName,
  'date_of_birth': instance.dateOfBirth?.toIso8601String(),
  'age': instance.age,
  'is_minor': instance.isMinor,
  'sex': _$SexEnumMap[instance.sex]!,
  'nationality': instance.nationality,
  'blood_group': _$BloodGroupEnumMap[instance.bloodGroup]!,
  'identity_status': _$IdentityStatusEnumMap[instance.identityStatus]!,
  'relationship': instance.relationship,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$SexEnumMap = {
  Sex.female: 'female',
  Sex.male: 'male',
  Sex.unspecified: 'unspecified',
  Sex.unknown: 'unknown',
};

const _$BloodGroupEnumMap = {
  BloodGroup.aPos: 'aPos',
  BloodGroup.aNeg: 'aNeg',
  BloodGroup.bPos: 'bPos',
  BloodGroup.bNeg: 'bNeg',
  BloodGroup.abPos: 'abPos',
  BloodGroup.abNeg: 'abNeg',
  BloodGroup.oPos: 'oPos',
  BloodGroup.oNeg: 'oNeg',
  BloodGroup.unknown: 'unknown',
};

const _$IdentityStatusEnumMap = {
  IdentityStatus.unverified: 'unverified',
  IdentityStatus.pendingVerification: 'pendingVerification',
  IdentityStatus.verified: 'verified',
  IdentityStatus.rejected: 'rejected',
  IdentityStatus.unknown: 'unknown',
};

_MinorCreateResponse _$MinorCreateResponseFromJson(Map<String, dynamic> json) =>
    _MinorCreateResponse(
      uuid: json['uuid'] as String,
      digitalId: json['digital_id'] as String,
      fullName: json['full_name'] as String,
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      age: (json['age'] as num?)?.toInt() ?? 0,
      isMinor: json['is_minor'] as bool? ?? false,
      sex: json['sex'] == null ? Sex.unknown : sexFromJson(json['sex']),
      nationality: json['nationality'] as String? ?? '',
      bloodGroup: json['blood_group'] == null
          ? BloodGroup.unknown
          : bloodGroupFromJson(json['blood_group']),
      identityStatus: json['identity_status'] == null
          ? IdentityStatus.unknown
          : identityStatusFromJson(json['identity_status']),
      relationship: json['relationship'] == null
          ? null
          : GuardianRelationship.fromJson(
              json['relationship'] as Map<String, dynamic>,
            ),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MinorCreateResponseToJson(
  _MinorCreateResponse instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'digital_id': instance.digitalId,
  'full_name': instance.fullName,
  'date_of_birth': instance.dateOfBirth?.toIso8601String(),
  'age': instance.age,
  'is_minor': instance.isMinor,
  'sex': _$SexEnumMap[instance.sex]!,
  'nationality': instance.nationality,
  'blood_group': _$BloodGroupEnumMap[instance.bloodGroup]!,
  'identity_status': _$IdentityStatusEnumMap[instance.identityStatus]!,
  'relationship': instance.relationship,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
