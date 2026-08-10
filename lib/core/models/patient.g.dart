// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PatientProfile _$PatientProfileFromJson(Map<String, dynamic> json) =>
    _PatientProfile(
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
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PatientProfileToJson(_PatientProfile instance) =>
    <String, dynamic>{
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
