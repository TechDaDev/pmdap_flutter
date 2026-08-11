// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_candidate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DateCandidate _$DateCandidateFromJson(Map<String, dynamic> json) =>
    _DateCandidate(
      uuid: json['uuid'] as String,
      date: json['date'] == null
          ? null
          : DateTime.parse(json['date'] as String),
      alternativeDate: json['alternative_date'] == null
          ? null
          : DateTime.parse(json['alternative_date'] as String),
      type: json['type'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0,
      pageNumber: (json['page_number'] as num?)?.toInt() ?? 0,
      context: json['context'] as String? ?? '',
      source: json['source'] == null
          ? Source.unknown
          : sourceFromJson(json['source']),
      ambiguous: json['ambiguous'] as bool? ?? false,
      isSuggested: json['is_suggested'] as bool? ?? false,
    );

Map<String, dynamic> _$DateCandidateToJson(_DateCandidate instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'date': instance.date?.toIso8601String(),
      'alternative_date': instance.alternativeDate?.toIso8601String(),
      'type': instance.type,
      'score': instance.score,
      'page_number': instance.pageNumber,
      'context': instance.context,
      'source': _$SourceEnumMap[instance.source]!,
      'ambiguous': instance.ambiguous,
      'is_suggested': instance.isSuggested,
    };

const _$SourceEnumMap = {
  Source.pdfText: 'pdfText',
  Source.ocr: 'ocr',
  Source.unknown: 'unknown',
};
