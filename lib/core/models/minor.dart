// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'enum_json.dart';
import 'enums.dart';

part 'minor.freezed.dart';
part 'minor.g.dart';

/// Guardian relationship embedded in a minor.
@freezed
abstract class GuardianRelationship with _$GuardianRelationship {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GuardianRelationship({
    required String uuid,
    @JsonKey(fromJson: relationshipFromJson)
    @Default(Relationship.unknown)
    Relationship relationship,
    @JsonKey(fromJson: verificationStatusFromJson)
    @Default(VerificationStatus.unknown)
    VerificationStatus verificationStatus,
    @Default(false) bool active,
    DateTime? startedAt,
    DateTime? verifiedAt,
    DateTime? endedAt,
    String? endedReason,
  }) = _GuardianRelationship;

  factory GuardianRelationship.fromJson(Map<String, dynamic> json) =>
      _$GuardianRelationshipFromJson(json);
}

/// Minor patient as seen by an authorized guardian.
@freezed
abstract class Minor with _$Minor {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Minor({
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
    GuardianRelationship? relationship,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Minor;

  factory Minor.fromJson(Map<String, dynamic> json) => _$MinorFromJson(json);
}

/// Response payload of `POST /minors/`.
@freezed
abstract class MinorCreateResponse with _$MinorCreateResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MinorCreateResponse({
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
    GuardianRelationship? relationship,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MinorCreateResponse;

  factory MinorCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$MinorCreateResponseFromJson(json);
}
