// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extracted_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExtractedContentSection _$ExtractedContentSectionFromJson(
  Map<String, dynamic> json,
) => _ExtractedContentSection(
  heading: json['heading'] as String? ?? '',
  body: json['body'] as String? ?? '',
  pageNumber: (json['page_number'] as num?)?.toInt() ?? 1,
  sequence: (json['sequence'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ExtractedContentSectionToJson(
  _ExtractedContentSection instance,
) => <String, dynamic>{
  'heading': instance.heading,
  'body': instance.body,
  'page_number': instance.pageNumber,
  'sequence': instance.sequence,
};

_ExtractedContentResponse _$ExtractedContentResponseFromJson(
  Map<String, dynamic> json,
) => _ExtractedContentResponse(
  documentUuid: json['document_uuid'] as String,
  documentType: json['document_type'] as String? ?? '',
  contentKind: json['content_kind'] as String? ?? '',
  status: json['status'] as String? ?? '',
  sections:
      (json['sections'] as List<dynamic>?)
          ?.map(
            (e) => ExtractedContentSection.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <ExtractedContentSection>[],
);

Map<String, dynamic> _$ExtractedContentResponseToJson(
  _ExtractedContentResponse instance,
) => <String, dynamic>{
  'document_uuid': instance.documentUuid,
  'document_type': instance.documentType,
  'content_kind': instance.contentKind,
  'status': instance.status,
  'sections': instance.sections,
};
