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
      alternativeDate: json['alternativeDate'] == null
          ? null
          : DateTime.parse(json['alternativeDate'] as String),
      type: json['type'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0,
      pageNumber: (json['pageNumber'] as num?)?.toInt() ?? 0,
      context: json['context'] as String? ?? '',
      source: json['source'] == null
          ? Source.unknown
          : sourceFromJson(json['source']),
      ambiguous: json['ambiguous'] as bool? ?? false,
      isSuggested: json['isSuggested'] as bool? ?? false,
    );

Map<String, dynamic> _$DateCandidateToJson(_DateCandidate instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'date': instance.date?.toIso8601String(),
      'alternativeDate': instance.alternativeDate?.toIso8601String(),
      'type': instance.type,
      'score': instance.score,
      'pageNumber': instance.pageNumber,
      'context': instance.context,
      'source': _$SourceEnumMap[instance.source]!,
      'ambiguous': instance.ambiguous,
      'isSuggested': instance.isSuggested,
    };

const _$SourceEnumMap = {
  Source.pdfText: 'pdfText',
  Source.ocr: 'ocr',
  Source.unknown: 'unknown',
};
