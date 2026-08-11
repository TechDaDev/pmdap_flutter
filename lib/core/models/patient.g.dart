// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PatientProfile _$PatientProfileFromJson(Map<String, dynamic> json) =>
    _PatientProfile(
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
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PatientProfileToJson(_PatientProfile instance) =>
    <String, dynamic>{
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
