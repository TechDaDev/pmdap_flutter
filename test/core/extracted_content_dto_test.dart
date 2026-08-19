import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/extracted_content.dart';

void main() {
  test('parses narrative response with sections', () {
    final json = {
      'document_uuid': 'd1',
      'document_type': 'RADIOLOGY',
      'content_kind': 'NARRATIVE',
      'status': 'COMPLETED',
      'sections': [
        {
          'heading': 'ABDOMINAL US',
          'body': 'Liver is of normal size showing normal texture.',
          'page_number': 1,
          'sequence': 13,
        },
      ],
    };
    final parsed = ExtractedContentResponse.fromJson(json);
    expect(parsed.contentKind, ExtractedContentKind.narrative);
    expect(parsed.status, 'COMPLETED');
    expect(parsed.sections, hasLength(1));
    expect(parsed.sections.first.heading, 'ABDOMINAL US');
    expect(parsed.sections.first.body, contains('Liver is of normal size'));
    expect(parsed.sections.first.pageNumber, 1);
    expect(parsed.sections.first.sequence, 13);
  });

  test('defaults for empty sections and LAB kind', () {
    final json = {
      'document_uuid': 'd1',
      'document_type': 'LABORATORY',
      'content_kind': 'LAB',
      'status': 'COMPLETED',
      'sections': <Map<String, dynamic>>[],
    };
    final parsed = ExtractedContentResponse.fromJson(json);
    expect(parsed.contentKind, ExtractedContentKind.lab);
    expect(parsed.sections, isEmpty);
    expect(parsed.documentType, 'LABORATORY');
  });
}
