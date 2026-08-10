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
  verificationStatus: json['verificationStatus'] == null
      ? VerificationStatus.unknown
      : verificationStatusFromJson(json['verificationStatus']),
  active: json['active'] as bool? ?? false,
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  verifiedAt: json['verifiedAt'] == null
      ? null
      : DateTime.parse(json['verifiedAt'] as String),
  endedAt: json['endedAt'] == null
      ? null
      : DateTime.parse(json['endedAt'] as String),
  endedReason: json['endedReason'] as String?,
);

Map<String, dynamic> _$GuardianRelationshipToJson(
  _GuardianRelationship instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'relationship': _$RelationshipEnumMap[instance.relationship]!,
  'verificationStatus':
      _$VerificationStatusEnumMap[instance.verificationStatus]!,
  'active': instance.active,
  'startedAt': instance.startedAt?.toIso8601String(),
  'verifiedAt': instance.verifiedAt?.toIso8601String(),
  'endedAt': instance.endedAt?.toIso8601String(),
  'endedReason': instance.endedReason,
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
  digitalId: json['digitalId'] as String,
  fullName: json['fullName'] as String,
  dateOfBirth: json['dateOfBirth'] == null
      ? null
      : DateTime.parse(json['dateOfBirth'] as String),
  age: (json['age'] as num?)?.toInt() ?? 0,
  isMinor: json['isMinor'] as bool? ?? false,
  sex: json['sex'] == null ? Sex.unknown : sexFromJson(json['sex']),
  nationality: json['nationality'] as String? ?? '',
  bloodGroup: json['bloodGroup'] == null
      ? BloodGroup.unknown
      : bloodGroupFromJson(json['bloodGroup']),
  identityStatus: json['identityStatus'] == null
      ? IdentityStatus.unknown
      : identityStatusFromJson(json['identityStatus']),
  relationship: json['relationship'] == null
      ? null
      : GuardianRelationship.fromJson(
          json['relationship'] as Map<String, dynamic>,
        ),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$MinorToJson(_Minor instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'digitalId': instance.digitalId,
  'fullName': instance.fullName,
  'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
  'age': instance.age,
  'isMinor': instance.isMinor,
  'sex': _$SexEnumMap[instance.sex]!,
  'nationality': instance.nationality,
  'bloodGroup': _$BloodGroupEnumMap[instance.bloodGroup]!,
  'identityStatus': _$IdentityStatusEnumMap[instance.identityStatus]!,
  'relationship': instance.relationship,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
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
      digitalId: json['digitalId'] as String,
      fullName: json['fullName'] as String,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      age: (json['age'] as num?)?.toInt() ?? 0,
      isMinor: json['isMinor'] as bool? ?? false,
      sex: json['sex'] == null ? Sex.unknown : sexFromJson(json['sex']),
      nationality: json['nationality'] as String? ?? '',
      bloodGroup: json['bloodGroup'] == null
          ? BloodGroup.unknown
          : bloodGroupFromJson(json['bloodGroup']),
      identityStatus: json['identityStatus'] == null
          ? IdentityStatus.unknown
          : identityStatusFromJson(json['identityStatus']),
      relationship: json['relationship'] == null
          ? null
          : GuardianRelationship.fromJson(
              json['relationship'] as Map<String, dynamic>,
            ),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MinorCreateResponseToJson(
  _MinorCreateResponse instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'digitalId': instance.digitalId,
  'fullName': instance.fullName,
  'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
  'age': instance.age,
  'isMinor': instance.isMinor,
  'sex': _$SexEnumMap[instance.sex]!,
  'nationality': instance.nationality,
  'bloodGroup': _$BloodGroupEnumMap[instance.bloodGroup]!,
  'identityStatus': _$IdentityStatusEnumMap[instance.identityStatus]!,
  'relationship': instance.relationship,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
