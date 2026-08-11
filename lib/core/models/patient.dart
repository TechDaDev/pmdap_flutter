// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'enum_json.dart';
import 'enums.dart';

part 'patient.freezed.dart';
part 'patient.g.dart';

/// Patient profile from `/patients/me/`.
@freezed
abstract class PatientProfile with _$PatientProfile {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PatientProfile({
    required String uuid,
    required String digitalId,
    required String fullName,
    DateTime? dateOfBirth,
    @Default(0) int age,
    @Default(false) bool isMinor,
    @JsonKey(fromJson: sexFromJson) @Default(Sex.unknown) Sex sex,
    @Default('') String nationality,
    @JsonKey(fromJson: bloodGroupFromJson)
    @Default(BloodGroup.unknown)
    BloodGroup bloodGroup,
    @JsonKey(fromJson: identityStatusFromJson)
    @Default(IdentityStatus.unknown)
    IdentityStatus identityStatus,

    /// Private authenticated avatar route hint (e.g. `/api/v1/patients/me/avatar/`).
    /// Null when the patient has no avatar. Never a public storage URL.
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PatientProfile;

  factory PatientProfile.fromJson(Map<String, dynamic> json) =>
      _$PatientProfileFromJson(json);
}
