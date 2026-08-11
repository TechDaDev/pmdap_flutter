// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_pair.freezed.dart';
part 'token_pair.g.dart';

@freezed
abstract class TokenPair with _$TokenPair {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TokenPair({required String access, required String refresh}) =
      _TokenPair;

  factory TokenPair.fromJson(Map<String, dynamic> json) =>
      _$TokenPairFromJson(json);
}
