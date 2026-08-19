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
import 'package:pmdap_mobile/features/documents/presentation/lab_results_section.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

LabResultItem _item({
  int rowIndex = 0,
  String name = 'Glucose',
  String result = '92',
  String unit = 'mg/dL',
  String ref = '70 - 99',
  String flag = '',
  double conf = 0.93,
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
    extractionConfidence: conf,
  );
}

LabResultsResponse _response({
  String status = LabExtractionStatus.completed,
  List<LabResultItem> results = const [],
}) {
  return LabResultsResponse(
    documentUuid: 'd1',
    documentType: 'LABORATORY',
    extractionStatus: status,
    pipelineVersion: 'lab-v1',
    resultCount: results.length,
    results: results,
  );
}

Widget _section(String status, List<LabResultItem> results) {
  return pumpApp(
    const Scaffold(
      body: SingleChildScrollView(child: LabResultsSection(uuid: 'd1')),
    ),
    overrides: [
      labResultsProvider.overrideWith(
        (ref, uuid) async => _response(status: status, results: results),
      ),
    ],
  );
}

void main() {
  testWidgets('loading shows extracting message', (tester) async {
    final completer = Completer<LabResultsResponse>();
    await tester.pumpWidget(
      pumpApp(
        const Scaffold(
          body: SingleChildScrollView(child: LabResultsSection(uuid: 'd1')),
        ),
        overrides: [
          labResultsProvider.overrideWith((ref, uuid) => completer.future),
        ],
      ),
    );
    await tester.pump();
    expect(find.text('Extracting results…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    completer.complete(
      _response(status: LabExtractionStatus.completed, results: [_item()]),
    );
    await tester.pumpAndSettle();
    expect(find.text('Glucose'), findsOneWidget);
  });

  testWidgets('completed with one row shows raw value, unit, reference, flag', (
    tester,
  ) async {
    await tester.pumpWidget(
      _section(LabExtractionStatus.completed, [
        _item(
          name: 'Creatinine',
          result: '1.25',
          unit: 'mg/dL',
          ref: '0.7 - 1.18',
          flag: 'H',
        ),
      ]),
    );
    await tester.pumpAndSettle();
    expect(find.text('Extracted results'), findsOneWidget);
    expect(find.text('1 result'), findsOneWidget);
    expect(find.text('Creatinine'), findsOneWidget);
    expect(find.text('1.25 mg/dL'), findsOneWidget);
    expect(find.text('Reference range: 0.7 - 1.18'), findsOneWidget);
    // neutral flag badge shows the printed value only (no clinical colouring)
    expect(find.text('H'), findsOneWidget);
  });

  testWidgets('completed with many rows keeps report order', (tester) async {
    final rows = [
      _item(rowIndex: 0, name: 'Alpha', result: '1'),
      _item(rowIndex: 1, name: 'Beta', result: '2'),
      _item(rowIndex: 2, name: 'Gamma', result: '3'),
    ];
    await tester.pumpWidget(_section(LabExtractionStatus.completed, rows));
    await tester.pumpAndSettle();
    expect(find.text('3 results'), findsOneWidget);
    // Order = row_index order (report order), not alphabetical.
    final alphaY = tester.getTopLeft(find.text('Alpha')).dy;
    final betaY = tester.getTopLeft(find.text('Beta')).dy;
    final gammaY = tester.getTopLeft(find.text('Gamma')).dy;
    expect(alphaY, lessThan(betaY));
    expect(betaY, lessThan(gammaY));
  });

  testWidgets('low confidence shows neutral verify hint but keeps row', (
    tester,
  ) async {
    await tester.pumpWidget(
      _section(LabExtractionStatus.completed, [
        _item(name: 'LowConf', conf: 0.4),
      ]),
    );
    await tester.pumpAndSettle();
    expect(find.text('LowConf'), findsOneWidget);
    expect(find.text('Please verify with original report'), findsOneWidget);
  });

  testWidgets('zero completed rows shows no-structure state', (tester) async {
    await tester.pumpWidget(_section(LabExtractionStatus.completed, const []));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'No structured results were detected. View the original report to review it.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('failed shows unavailable message', (tester) async {
    await tester.pumpWidget(_section(LabExtractionStatus.failed, const []));
    await tester.pumpAndSettle();
    expect(
      find.text(
        "Structured results aren't available for this report. You can still view the original document.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('not applicable hides the section entirely', (tester) async {
    await tester.pumpWidget(
      _section(LabExtractionStatus.notApplicable, const []),
    );
    await tester.pumpAndSettle();
    expect(find.text('Extracted results'), findsNothing);
    expect(find.byType(Card), findsNothing);
  });

  testWidgets('renders in RTL Arabic without exceptions', (tester) async {
    await tester.pumpWidget(
      pumpApp(
        const Scaffold(
          body: SingleChildScrollView(child: LabResultsSection(uuid: 'd1')),
        ),
        overrides: [
          labResultsProvider.overrideWith(
            (ref, uuid) async => _response(
              status: LabExtractionStatus.completed,
              results: [_item(name: 'Glucose', result: '92', unit: 'mg/dL')],
            ),
          ),
        ],
        locale: const Locale('ar'),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('النتائج المستخرجة'), findsOneWidget);
  });

  group('document detail integration', () {
    testWidgets('laboratory document shows extracted results section', (
      tester,
    ) async {
      await _pumpDetail(
        tester,
        sampleDocumentDetail(processing: ProcessingStatus.awaitingConfirmation),
      );
      await tester.pumpAndSettle();
      expect(find.text('Extracted results'), findsOneWidget);
      expect(find.text('Glucose'), findsOneWidget);
      expect(find.text('92 mg/dL'), findsOneWidget);
    });

    testWidgets(
      'radiology document shows narrative extracted report, hides lab',
      (tester) async {
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
        await _pumpDetail(tester, doc, content: _narrativeContent());
        await tester.pumpAndSettle();
        // structured lab section is never shown for radiology
        expect(find.text('Extracted results'), findsNothing);
        expect(find.text('Glucose'), findsNothing);
        // narrative extracted report is shown
        expect(find.text('Extracted report'), findsOneWidget);
        expect(find.text('ABDOMINAL US'), findsOneWidget);
        expect(
          find.text('Liver is of normal size showing normal texture.'),
          findsOneWidget,
        );
      },
    );
  });
}

class _FakeDocumentsApi extends DocumentsApi {
  _FakeDocumentsApi(this._doc) : super(Dio());

  final MedicalDocumentDetail _doc;

  @override
  Future<MedicalDocumentDetail> detail(String uuid) async => _doc;

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

ExtractedContentResponse _narrativeContent() {
  return const ExtractedContentResponse(
    documentUuid: 'd1',
    documentType: 'RADIOLOGY',
    contentKind: ExtractedContentKind.narrative,
    status: 'COMPLETED',
    sections: [
      ExtractedContentSection(
        heading: 'ABDOMINAL US',
        body: 'Liver is of normal size showing normal texture.',
      ),
    ],
  );
}

Future<void> _pumpDetail(
  WidgetTester tester,
  MedicalDocumentDetail doc, {
  ExtractedContentResponse? content,
}) async {
  await tester.pumpWidget(
    pumpApp(
      DocumentDetailScreen(uuid: 'd1'),
      overrides: [
        documentsApiProvider.overrideWithValue(_FakeDocumentsApi(doc)),
        labResultsProvider.overrideWith(
          (ref, uuid) async => _response(
            status: LabExtractionStatus.completed,
            results: [_item(name: 'Glucose', result: '92', unit: 'mg/dL')],
          ),
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
}
