import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/date_candidate.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/extracted_content.dart';
import 'package:pmdap_mobile/core/models/lab_results.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/core/models/pagination.dart' as pag;
import 'package:pmdap_mobile/features/documents/application/documents_providers.dart';
import 'package:pmdap_mobile/features/documents/data/documents_api.dart';
import 'package:pmdap_mobile/features/documents/presentation/document_detail_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

LabResultItem _item({
  int rowIndex = 0,
  String name = 'Glucose',
  String result = '92',
  String unit = 'mg/dL',
  String ref = '70 - 99',
  String flag = '',
}) {
  return LabResultItem(
    uuid: 'r-$rowIndex',
    pageNumber: 1,
    rowIndex: rowIndex,
    testNameRaw: name,
    resultRaw: result,
    unitRaw: unit,
    referenceRangeRaw: ref,
    flagRaw: flag,
    extractionConfidence: 0.95,
  );
}

LabResultsResponse _labResponse(List<LabResultItem> results) {
  return LabResultsResponse(
    documentUuid: 'd1',
    documentType: 'LABORATORY',
    extractionStatus: LabExtractionStatus.completed,
    pipelineVersion: 'lab-v2',
    resultCount: results.length,
    results: results,
  );
}

class _FakeDocumentsApi extends DocumentsApi {
  _FakeDocumentsApi(this._doc) : super(Dio());

  final MedicalDocumentDetail _doc;
  bool deleted = false;

  @override
  Future<MedicalDocumentDetail> detail(String uuid) async => _doc;

  @override
  Future<void> delete(String uuid) async {
    deleted = true;
  }

  @override
  Future<pag.Page<DateCandidate>> dateCandidates(
    String uuid, {
    int page = 1,
  }) async {
    return pag.Page<DateCandidate>(
      count: 0,
      next: null,
      previous: null,
      results: const [],
    );
  }
}

Future<_FakeDocumentsApi> _pumpDetail(
  WidgetTester tester,
  MedicalDocumentDetail doc, {
  List<LabResultItem> labRows = const [],
  ExtractedContentResponse? content,
  Locale? locale,
  ThemeMode themeMode = ThemeMode.light,
}) async {
  final api = _FakeDocumentsApi(doc);
  await tester.pumpWidget(
    pumpApp(
      DocumentDetailScreen(uuid: 'd1'),
      locale: locale,
      themeMode: themeMode,
      overrides: [
        documentsApiProvider.overrideWithValue(api),
        labResultsProvider.overrideWith(
          (ref, uuid) async => _labResponse(labRows),
        ),
        extractedContentProvider.overrideWith(
          (ref, uuid) async =>
              content ??
              const ExtractedContentResponse(
                documentUuid: 'd1',
                documentType: 'RADIOLOGY',
                contentKind: ExtractedContentKind.none,
                status: 'NOT_APPLICABLE',
                sections: [],
              ),
        ),
      ],
    ),
  );
  await tester.pump();
  await tester.pump();
  return api;
}

MedicalDocumentDetail _labDetail() => sampleDocumentDetail();

void main() {
  testWidgets('app bar title is Document details', (tester) async {
    await _pumpDetail(tester, _labDetail());
    await tester.pumpAndSettle();
    expect(find.text('Document details'), findsOneWidget);
  });

  testWidgets(
    'laboratory rows are compact with reference below and flag badge',
    (tester) async {
      await _pumpDetail(
        tester,
        _labDetail(),
        labRows: [
          _item(
            name: 'Creatinine',
            result: '1.25',
            unit: 'mg/dL',
            ref: '0.7 - 1.18',
            flag: 'H',
          ),
          _item(
            rowIndex: 1,
            name: 'Urea',
            result: '31.0',
            unit: 'mg/dL',
            ref: '12.9 - 42.9',
          ),
        ],
      );
      await tester.pumpAndSettle();
      expect(find.text('Extracted results'), findsOneWidget);
      expect(find.text('2 results'), findsOneWidget);
      expect(find.text('Creatinine'), findsOneWidget);
      expect(find.text('1.25 mg/dL'), findsOneWidget);
      // reference full-width below the row, prefixed with the label
      expect(find.text('Reference range: 0.7 - 1.18'), findsOneWidget);
      // neutral flag badge (value only)
      expect(find.text('H'), findsOneWidget);
      expect(find.text('Report flag: H'), findsNothing);
      // reference sits below its value (full-width line)
      final refY = tester
          .getTopLeft(find.text('Reference range: 0.7 - 1.18'))
          .dy;
      final valY = tester.getTopLeft(find.text('1.25 mg/dL')).dy;
      expect(refY, greaterThan(valY));
    },
  );

  testWidgets('many CBC rows render densely without overflow', (tester) async {
    final rows = [
      for (var i = 0; i < 21; i++)
        _item(
          rowIndex: i,
          name: i.isEven ? 'WBC-$i' : 'RBC-$i',
          result: '${i + 1}.${i}',
          unit: 'x10^3/µL',
          ref: '3.60 - 10.20',
        ),
    ];
    await _pumpDetail(tester, _labDetail(), labRows: rows);
    await tester.pumpAndSettle();
    expect(find.text('21 results'), findsOneWidget);
    expect(tester.takeException(), isNull);
    // scroll to the last row (index 20 is even -> WBC-20) still present
    await tester.scrollUntilVisible(find.text('WBC-20'), 300);
    expect(find.text('WBC-20'), findsOneWidget);
  });

  testWidgets('long reference range wraps full-width without overflow', (
    tester,
  ) async {
    await _pumpDetail(
      tester,
      _labDetail(),
      labRows: [
        _item(
          name: 'TSH',
          result: '1.24',
          unit: 'uIU/mL',
          ref:
              'Newborn 0-6 Days - 3 Month: 0.72 - 4 Month - 12 Month: 0.73-8.35 '
              '1 Year - 6 Years: 0.70 - > 6 Years <11 Years 0.60-4.84',
        ),
      ],
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Newborn 0-6 Days'), findsOneWidget);
    // long range spans the full row width (wraps, no horizontal overflow)
    final box = tester.getRect(find.textContaining('Newborn 0-6 Days'));
    expect(box.width, greaterThan(200));
  });

  testWidgets('radiology shows narrative extracted report', (tester) async {
    final doc = MedicalDocumentDetail(
      uuid: 'd1',
      documentType: MedicalDocumentType.radiology,
      classificationSource: ClassificationSource.systemDefault,
      title: 'Radiology',
      description: '',
      documentDate: DateTime(2024, 3, 15),
      dateSource: DateSource.ocr,
      dateVerified: false,
      facilityName: '',
      locationText: '',
      department: '',
      physicianName: '',
      processingStatus: ProcessingStatus.awaitingConfirmation,
      archiveStatus: ArchiveStatus.active,
      file: StoredFilePublic(
        originalFilename: 'x.jpg',
        mimeType: 'image/jpeg',
        sizeBytes: 10,
        integrityStatus: IntegrityStatus.valid,
        malwareScanStatus: MalwareScanStatus.clean,
      ),
    );
    await _pumpDetail(
      tester,
      doc,
      content: const ExtractedContentResponse(
        documentUuid: 'd1',
        documentType: 'RADIOLOGY',
        contentKind: ExtractedContentKind.narrative,
        status: 'COMPLETED',
        sections: [
          ExtractedContentSection(
            heading: 'ABDOMINAL US',
            body:
                'Liver is of normal size showing normal texture.\n'
                'No focal lesion is seen.',
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Extracted report'), findsOneWidget);
    expect(find.text('ABDOMINAL US'), findsOneWidget);
    expect(
      find.textContaining('Liver is of normal size showing normal texture.'),
      findsOneWidget,
    );
    // no fake lab section for radiology
    expect(find.text('Extracted results'), findsNothing);
    expect(find.text('Glucose'), findsNothing);
  });

  testWidgets('document actions card exposes delete with trash icon', (
    tester,
  ) async {
    final api = await _pumpDetail(tester, _labDetail());
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Delete document'), 300);
    expect(find.text('Document actions'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    await tester.tap(find.text('Delete document'));
    await tester.pumpAndSettle();
    expect(
      find.text('Delete this document from your archive?'),
      findsOneWidget,
    );
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(api.deleted, isTrue);
  });

  testWidgets('short viewport keeps delete reachable (scroll, SafeArea)', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 480));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpDetail(
      tester,
      _labDetail(),
      labRows: [for (var i = 0; i < 8; i++) _item(rowIndex: i, name: 'Row-$i')],
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Delete document'), 200);
    expect(find.text('Delete document'), findsOneWidget);
  });

  testWidgets('renders in RTL Arabic without exceptions', (tester) async {
    await _pumpDetail(
      tester,
      _labDetail(),
      labRows: [
        _item(name: 'Glucose', result: '92', unit: 'mg/dL', ref: '70 - 99'),
      ],
      locale: const Locale('ar'),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('تفاصيل الوثيقة'), findsOneWidget);
    expect(find.text('النتائج المستخرجة'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('إجراءات الوثيقة'), 200);
    expect(find.text('إجراءات الوثيقة'), findsOneWidget);
  });

  testWidgets('renders in dark theme without exceptions', (tester) async {
    await tester.pumpWidget(
      pumpApp(
        DocumentDetailScreen(uuid: 'd1'),
        themeMode: ThemeMode.dark,
        overrides: [
          documentsApiProvider.overrideWithValue(
            _FakeDocumentsApi(_labDetail()),
          ),
          labResultsProvider.overrideWith(
            (ref, uuid) async =>
                _labResponse([_item(name: 'Glucose', result: '92')]),
          ),
          extractedContentProvider.overrideWith(
            (ref, uuid) async => const ExtractedContentResponse(
              documentUuid: 'd1',
              documentType: 'RADIOLOGY',
              contentKind: ExtractedContentKind.none,
              status: 'NOT_APPLICABLE',
              sections: [],
            ),
          ),
        ],
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Glucose'), findsOneWidget);
  });
}
