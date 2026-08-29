import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/date_candidate.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/lab_results.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/core/models/pagination.dart' as pag;
import 'package:pmdap_mobile/features/documents/data/documents_api.dart';
import 'package:pmdap_mobile/features/documents/presentation/document_detail_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

class _FakeDocumentsApi extends DocumentsApi {
  _FakeDocumentsApi(this._doc) : super(Dio());

  MedicalDocumentDetail _doc;
  List<DateCandidate> candidates = [];
  int detailCalls = 0;
  int candidateCalls = 0;

  @override
  Future<MedicalDocumentDetail> detail(String uuid) async {
    detailCalls++;
    return _doc;
  }

  @override
  Future<pag.Page<DateCandidate>> dateCandidates(
    String uuid, {
    int page = 1,
  }) async {
    candidateCalls++;
    return pag.Page<DateCandidate>(
      count: candidates.length,
      next: null,
      previous: null,
      results: candidates,
    );
  }

  @override
  Future<LabResultsResponse> labResults(String uuid) async {
    return LabResultsResponse(
      documentUuid: uuid,
      documentType: 'LABORATORY',
      extractionStatus: LabExtractionStatus.notApplicable,
      pipelineVersion: null,
      resultCount: 0,
      results: const [],
    );
  }
}

DateCandidate _cand(
  String uuid,
  DateTime date, {
  bool isSuggested = false,
  double score = 0.5,
}) {
  return DateCandidate(
    uuid: uuid,
    date: date,
    type: 'UNKNOWN',
    score: score,
    pageNumber: 1,
    source: Source.ocr,
    isSuggested: isSuggested,
  );
}

MedicalDocumentDetail _confirmedDoc() {
  return MedicalDocumentDetail(
    uuid: 'd1',
    documentType: MedicalDocumentType.laboratory,
    classificationSource: ClassificationSource.systemDefault,
    title: 'Lab Report',
    description: 'Synthetic',
    documentDate: DateTime(2024, 3, 15),
    dateSource: DateSource.userConfirmed,
    dateVerified: true,
    facilityName: 'Central Lab',
    processingStatus: ProcessingStatus.dateConfirmed,
    archiveStatus: ArchiveStatus.active,
  );
}

Future<void> _pumpFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  testWidgets(
    'AWAITING_CONFIRMATION + one candidate shows Detected date + Suggested badge',
    (tester) async {
      final api = _FakeDocumentsApi(
        sampleDocumentDetail(processing: ProcessingStatus.awaitingConfirmation),
      );
      api.candidates = [
        _cand('c1', DateTime(2025, 6, 30), isSuggested: true, score: 0.9),
      ];
      await tester.pumpWidget(
        pumpApp(
          DocumentDetailScreen(uuid: 'd1'),
          overrides: [documentsApiProvider.overrideWithValue(api)],
        ),
      );
      await _pumpFrames(tester);

      expect(find.text('Detected date'), findsOneWidget);
      expect(find.text('30 Jun 2025'), findsOneWidget);
      expect(find.text('Suggested date'), findsOneWidget);
      expect(find.text('Needs confirmation'), findsOneWidget);
      // OCR candidate must never be presented as the authoritative report date.
      expect(find.text('Report date'), findsNothing);
      expect(find.text('Confirmed'), findsNothing);
    },
  );

  testWidgets('zero candidates renders Not detected + manual entry hint', (
    tester,
  ) async {
    final api = _FakeDocumentsApi(
      sampleDocumentDetail(processing: ProcessingStatus.awaitingConfirmation),
    );
    api.candidates = [];
    await tester.pumpWidget(
      pumpApp(
        DocumentDetailScreen(uuid: 'd1'),
        overrides: [documentsApiProvider.overrideWithValue(api)],
      ),
    );
    await _pumpFrames(tester);

    expect(find.text('Detected date'), findsOneWidget);
    expect(find.text('Not detected'), findsOneWidget);
    expect(find.text('Needs confirmation'), findsOneWidget);
    expect(find.text('Suggested date'), findsNothing);
    expect(find.text('Confirm date'), findsOneWidget);
  });

  testWidgets('multiple candidates shows top suggestion + count hint', (
    tester,
  ) async {
    final api = _FakeDocumentsApi(
      sampleDocumentDetail(processing: ProcessingStatus.awaitingConfirmation),
    );
    api.candidates = [
      _cand('c1', DateTime(2025, 6, 30), isSuggested: true, score: 0.9),
      _cand('c2', DateTime(2024, 1, 15), isSuggested: false, score: 0.4),
    ];
    await tester.pumpWidget(
      pumpApp(
        DocumentDetailScreen(uuid: 'd1'),
        overrides: [documentsApiProvider.overrideWithValue(api)],
      ),
    );
    await _pumpFrames(tester);

    expect(find.text('Detected date'), findsOneWidget);
    expect(find.text('30 Jun 2025'), findsOneWidget);
    expect(find.text('2 possible dates detected'), findsOneWidget);
    expect(find.text('Suggested date'), findsOneWidget);
    expect(find.text('Needs confirmation'), findsOneWidget);
  });

  testWidgets('confirmed date renders Report date + Confirmed, no suggestion', (
    tester,
  ) async {
    final api = _FakeDocumentsApi(_confirmedDoc());
    // Stale candidates must be ignored once confirmed.
    api.candidates = [
      _cand('c1', DateTime(2025, 6, 30), isSuggested: true, score: 0.9),
    ];
    await tester.pumpWidget(
      pumpApp(
        DocumentDetailScreen(uuid: 'd1'),
        overrides: [documentsApiProvider.overrideWithValue(api)],
      ),
    );
    await _pumpFrames(tester);

    expect(find.text('Report date'), findsOneWidget);
    expect(find.text('15 Mar 2024'), findsOneWidget);
    expect(find.text('Confirmed'), findsOneWidget);
    expect(find.text('Detected date'), findsNothing);
    expect(find.text('Suggested date'), findsNothing);
    expect(find.text('Confirm date'), findsNothing);
  });

  testWidgets('processing state does not render stale candidate display', (
    tester,
  ) async {
    final api = _FakeDocumentsApi(
      sampleDocumentDetail(processing: ProcessingStatus.ocrProcessing),
    );
    api.candidates = [
      _cand('c1', DateTime(2025, 6, 30), isSuggested: true, score: 0.9),
    ];
    await tester.pumpWidget(
      pumpApp(
        DocumentDetailScreen(uuid: 'd1'),
        overrides: [documentsApiProvider.overrideWithValue(api)],
      ),
    );
    await _pumpFrames(tester);

    expect(find.text('Detected date'), findsNothing);
    expect(find.text('Suggested date'), findsNothing);
  });

  testWidgets('terminal OCR transition invalidates candidate provider', (
    tester,
  ) async {
    final api = _FakeDocumentsApi(
      sampleDocumentDetail(processing: ProcessingStatus.ocrProcessing),
    );
    await tester.pumpWidget(
      pumpApp(
        DocumentDetailScreen(uuid: 'd1'),
        overrides: [documentsApiProvider.overrideWithValue(api)],
      ),
    );
    await _pumpFrames(tester);
    // Detail watches candidates even while processing, so it fetches once.
    final candidateCallsBefore = api.candidateCalls;
    expect(candidateCallsBefore, greaterThan(0));

    // OCR completes: awaiting confirmation + a detected candidate now exists.
    api._doc = sampleDocumentDetail(
      processing: ProcessingStatus.awaitingConfirmation,
    );
    api.candidates = [
      _cand('c1', DateTime(2025, 6, 30), isSuggested: true, score: 0.9),
    ];

    await tester.pump(const Duration(seconds: 3));
    await _pumpFrames(tester);

    // Status change invalidated the candidate provider -> refetched, and the
    // detail view now shows the detected candidate (not a stale empty state).
    expect(api.candidateCalls, greaterThan(candidateCallsBefore));
    expect(find.text('30 Jun 2025'), findsOneWidget);
    expect(find.text('Not detected'), findsNothing);
  });
}
