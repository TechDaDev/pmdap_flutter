// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'enum_json.dart';
import 'enums.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Public user returned by `/auth/me/` and `/auth/register/`.
@freezed
abstract class PublicUser with _$PublicUser {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PublicUser({
    required String uuid,
    required String email,
    @Default('') String phone,
    @JsonKey(fromJson: roleFromJson) @Default(Role.unknown) Role role,
    @Default(false) bool emailVerified,
    @Default(false) bool phoneVerified,
    DateTime? createdAt,
  }) = _PublicUser;

  factory PublicUser.fromJson(Map<String, dynamic> json) =>
      _$PublicUserFromJson(json);
}
