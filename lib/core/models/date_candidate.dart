import 'package:freezed_annotation/freezed_annotation.dart';

import 'enum_json.dart';
import 'enums.dart';

part 'date_candidate.freezed.dart';
part 'date_candidate.g.dart';

/// A suggested report date candidate from OCR/PDF extraction.
@freezed
abstract class DateCandidate with _$DateCandidate {
  const factory DateCandidate({
    required String uuid,
    DateTime? date,
    DateTime? alternativeDate,
    @Default('') String type,
    @Default(0) double score,
    @Default(0) int pageNumber,
    @Default('') String context,
    @JsonKey(fromJson: sourceFromJson) @Default(Source.unknown) Source source,
    @Default(false) bool ambiguous,
    @Default(false) bool isSuggested,
  }) = _DateCandidate;

  factory DateCandidate.fromJson(Map<String, dynamic> json) =>
      _$DateCandidateFromJson(json);
}
