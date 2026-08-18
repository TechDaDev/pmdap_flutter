import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/lab_results.dart';

void main() {
  group('LabResultsResponse.fromJson', () {
    test('parses full response with decimal strings and raw fields', () {
      final json = <String, dynamic>{
        'data': {
          'document_uuid': 'doc-1',
          'document_type': 'LABORATORY',
          'extraction_status': 'COMPLETED',
          'pipeline_version': 'lab-v1',
          'result_count': 1,
          'results': [
            {
              'uuid': 'r-1',
              'page_number': 1,
              'row_index': 0,
              'test_name_raw': 'Glucose',
              'test_name_normalized': 'GLUCOSE',
              'result_raw': '92',
              'result_numeric': '92',
              'result_text': '',
              'unit_raw': 'mg/dL',
              'unit_normalized': 'mg/dL',
              'reference_range_raw': '70 - 99',
              'reference_low': '70',
              'reference_high': '99',
              'flag_raw': '',
              'extraction_confidence': 0.93,
            },
          ],
        },
      };
      final data =
          (json['data'] as Map<String, dynamic>)['results'] as List<dynamic>;

      // Response wrapper is decoded by decodeData; here we verify item parse.
      final item = LabResultItem.fromJson(data.first as Map<String, dynamic>);
      expect(item.testNameRaw, 'Glucose');
      expect(item.resultRaw, '92');
      expect(item.resultNumeric, '92'); // safe string, never float
      expect(item.unitRaw, 'mg/dL');
      expect(item.referenceRangeRaw, '70 - 99');
      expect(item.referenceLow, '70');
      expect(item.referenceHigh, '99');
      expect(item.extractionConfidence, closeTo(0.93, 0.0001));
    });

    test('defaults survive absent optional fields', () {
      final item = LabResultItem.fromJson({
        'uuid': 'r-2',
        'test_name_raw': 'WBC',
        'result_raw': '6.7',
      });
      expect(item.pageNumber, 1);
      expect(item.rowIndex, 0);
      expect(item.resultNumeric, isNull);
      expect(item.unitRaw, '');
      expect(item.referenceRangeRaw, '');
      expect(item.flagRaw, '');
      expect(item.extractionConfidence, 0.0);
    });

    test('wrapper parses response envelope', () {
      final response = LabResultsResponse.fromJson({
        'document_uuid': 'doc-1',
        'document_type': 'LABORATORY',
        'extraction_status': 'COMPLETED',
        'pipeline_version': 'lab-v1',
        'result_count': 2,
        'results': [
          {'uuid': 'r-1', 'test_name_raw': 'A', 'result_raw': '1'},
          {'uuid': 'r-2', 'test_name_raw': 'B', 'result_raw': '2'},
        ],
      });
      expect(response.documentUuid, 'doc-1');
      expect(response.extractionStatus, LabExtractionStatus.completed);
      expect(response.resultCount, 2);
      expect(response.results, hasLength(2));
      expect(response.results[1].testNameRaw, 'B');
    });

    test('failed status parses', () {
      final response = LabResultsResponse.fromJson({
        'document_uuid': 'doc-2',
        'document_type': 'LABORATORY',
        'extraction_status': 'FAILED',
        'pipeline_version': null,
        'result_count': 0,
        'results': <Map<String, dynamic>>[],
      });
      expect(response.extractionStatus, LabExtractionStatus.failed);
      expect(response.results, isEmpty);
    });
  });
}
