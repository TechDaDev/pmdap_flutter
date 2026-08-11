// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PublicUser _$PublicUserFromJson(Map<String, dynamic> json) => _PublicUser(
  uuid: json['uuid'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String? ?? '',
  role: json['role'] == null ? Role.unknown : roleFromJson(json['role']),
  emailVerified: json['email_verified'] as bool? ?? false,
  phoneVerified: json['phone_verified'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$PublicUserToJson(_PublicUser instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'email': instance.email,
      'phone': instance.phone,
      'role': _$RoleEnumMap[instance.role]!,
      'email_verified': instance.emailVerified,
      'phone_verified': instance.phoneVerified,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$RoleEnumMap = {
  Role.patient: 'patient',
  Role.identityVerificationAgent: 'identityVerificationAgent',
  Role.admin: 'admin',
  Role.unknown: 'unknown',
};
