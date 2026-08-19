// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'extracted_content.freezed.dart';
part 'extracted_content.g.dart';

/// One narrative section (report title + paragraph body) rebuilt from the
/// persisted OCR text. Read-only; no geometry is exposed by the backend.
@freezed
abstract class ExtractedContentSection with _$ExtractedContentSection {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ExtractedContentSection({
    @Default('') String heading,
    @Default('') String body,
    @Default(1) int pageNumber,
    @Default(0) int sequence,
  }) = _ExtractedContentSection;

  factory ExtractedContentSection.fromJson(Map<String, dynamic> json) =>
      _$ExtractedContentSectionFromJson(json);
}

/// Extracted-content response for one document.
///
/// ``contentKind`` is ``LAB`` for structured lab tables (client reads the
/// dedicated lab-results endpoint), ``NARRATIVE`` for narrative reports
/// (radiology etc.), or ``NONE`` when no extracted content is applicable.
@freezed
abstract class ExtractedContentResponse with _$ExtractedContentResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ExtractedContentResponse({
    required String documentUuid,
    @Default('') String documentType,
    @Default('') String contentKind,
    @Default('') String status,
    @Default(<ExtractedContentSection>[])
    List<ExtractedContentSection> sections,
  }) = _ExtractedContentResponse;

  factory ExtractedContentResponse.fromJson(Map<String, dynamic> json) =>
      _$ExtractedContentResponseFromJson(json);
}

/// Backend content-kind values mirrored as constants.
class ExtractedContentKind {
  ExtractedContentKind._();

  static const lab = 'LAB';
  static const narrative = 'NARRATIVE';
  static const none = 'NONE';
}
