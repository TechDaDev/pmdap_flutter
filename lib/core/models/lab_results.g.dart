// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LabResultItem _$LabResultItemFromJson(Map<String, dynamic> json) =>
    _LabResultItem(
      uuid: json['uuid'] as String,
      pageNumber: (json['page_number'] as num?)?.toInt() ?? 1,
      rowIndex: (json['row_index'] as num?)?.toInt() ?? 0,
      testNameRaw: json['test_name_raw'] as String? ?? '',
      testNameNormalized: json['test_name_normalized'] as String? ?? '',
      resultRaw: json['result_raw'] as String? ?? '',
      resultNumeric: json['result_numeric'] as String?,
      resultText: json['result_text'] as String? ?? '',
      unitRaw: json['unit_raw'] as String? ?? '',
      unitNormalized: json['unit_normalized'] as String? ?? '',
      referenceRangeRaw: json['reference_range_raw'] as String? ?? '',
      referenceLow: json['reference_low'] as String?,
      referenceHigh: json['reference_high'] as String?,
      flagRaw: json['flag_raw'] as String? ?? '',
      extractionConfidence:
          (json['extraction_confidence'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$LabResultItemToJson(_LabResultItem instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'page_number': instance.pageNumber,
      'row_index': instance.rowIndex,
      'test_name_raw': instance.testNameRaw,
      'test_name_normalized': instance.testNameNormalized,
      'result_raw': instance.resultRaw,
      'result_numeric': instance.resultNumeric,
      'result_text': instance.resultText,
      'unit_raw': instance.unitRaw,
      'unit_normalized': instance.unitNormalized,
      'reference_range_raw': instance.referenceRangeRaw,
      'reference_low': instance.referenceLow,
      'reference_high': instance.referenceHigh,
      'flag_raw': instance.flagRaw,
      'extraction_confidence': instance.extractionConfidence,
    };

_LabResultsResponse _$LabResultsResponseFromJson(Map<String, dynamic> json) =>
    _LabResultsResponse(
      documentUuid: json['document_uuid'] as String,
      documentType: json['document_type'] as String? ?? '',
      extractionStatus: json['extraction_status'] as String? ?? '',
      pipelineVersion: json['pipeline_version'] as String?,
      resultCount: (json['result_count'] as num?)?.toInt() ?? 0,
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => LabResultItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <LabResultItem>[],
    );

Map<String, dynamic> _$LabResultsResponseToJson(_LabResultsResponse instance) =>
    <String, dynamic>{
      'document_uuid': instance.documentUuid,
      'document_type': instance.documentType,
      'extraction_status': instance.extractionStatus,
      'pipeline_version': instance.pipelineVersion,
      'result_count': instance.resultCount,
      'results': instance.results,
    };
