import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/date_candidate.dart';
import 'package:pmdap_mobile/core/models/document_page.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/lab_results.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/core/models/pagination.dart' as pag;
import 'package:pmdap_mobile/core/models/pending_date_confirmation.dart';
import 'package:pmdap_mobile/features/documents/data/documents_api.dart';
import 'package:pmdap_mobile/features/documents/presentation/confirm_dates_screen.dart';
import 'package:pmdap_mobile/features/documents/presentation/document_detail_screen.dart';
import 'package:pmdap_mobile/features/documents/presentation/document_page_results_screen.dart';

import '../helpers/pump.dart';

MedicalDocumentPageSummary _summary() => MedicalDocumentPageSummary(
  documentUuid: 'd1',
  pageCount: 3,
  pages: [
    MedicalDocumentPageSummaryItem(
      pageNumber: 1,
      reportSubtype: ReportSubtype.labChemistry,
      processingStatus: 'READY',
      documentDate: DateTime(2025, 6, 30),
      dateVerified: true,
      labResultCount: 14,
    ),
    MedicalDocumentPageSummaryItem(
      pageNumber: 2,
      reportSubtype: ReportSubtype.labHormones,
      processingStatus: 'AWAITING_CONFIRMATION',
      dateVerified: false,
      labResultCount: 6,
    ),
    MedicalDocumentPageSummaryItem(
      pageNumber: 3,
      reportSubtype: ReportSubtype.labCbc,
      processingStatus: 'FAILED',
      dateVerified: false,
      labResultCount: 0,
    ),
  ],
);

MedicalDocumentPageDetail _pageDetail(int pageNumber) =>
    MedicalDocumentPageDetail(
      documentUuid: 'd1',
      pageNumber: pageNumber,
      pageCount: 3,
      reportSubtype: pageNumber == 1
          ? ReportSubtype.labChemistry
          : pageNumber == 2
          ? ReportSubtype.labHormones
          : ReportSubtype.labCbc,
      processingStatus: pageNumber == 3 ? 'FAILED' : 'READY',
      documentDate: pageNumber == 1 ? DateTime(2025, 6, 30) : null,
      dateVerified: pageNumber == 1,
      labResultCount: pageNumber == 3 ? 0 : (pageNumber == 1 ? 14 : 6),
      labResults: pageNumber == 3
          ? const []
          : [
              LabResultItem(
                uuid: 'r$pageNumber',
                pageNumber: pageNumber,
                rowIndex: 0,
                testNameRaw: pageNumber == 1 ? 'Glucose' : 'TSH',
                resultRaw: pageNumber == 1 ? '92' : '1.24',
                unitRaw: pageNumber == 1 ? 'mg/dL' : 'mIU/mL',
                referenceRangeRaw: '70 - 99',
                extractionConfidence: 0.95,
              ),
            ],
    );

MedicalDocumentDetail _detailDoc({int pageCount = 3}) => MedicalDocumentDetail(
  uuid: 'd1',
  documentType: MedicalDocumentType.laboratory,
  classificationSource: ClassificationSource.systemDefault,
  title: 'Chemistry Multi',
  description: 'Synthetic 3-page',
  dateVerified: false,
  facilityName: 'Central Lab',
  processingStatus: ProcessingStatus.awaitingConfirmation,
  archiveStatus: ArchiveStatus.active,
  file: StoredFilePublic(
    originalFilename: 'report.pdf',
    mimeType: 'application/pdf',
    sizeBytes: 1000,
    pageCount: pageCount,
    integrityStatus: IntegrityStatus.valid,
    malwareScanStatus: MalwareScanStatus.clean,
  ),
);

class _FakeApi extends DocumentsApi {
  _FakeApi() : super(Dio());

  @override
  Future<MedicalDocumentDetail> detail(String uuid) async => _detailDoc();

  @override
  Future<MedicalDocumentPageSummary> documentPages(String uuid) async =>
      _summary();

  @override
  Future<MedicalDocumentPageDetail> documentPageDetail(
    String uuid,
    int pageNumber,
  ) async => _pageDetail(pageNumber);

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

  @override
  Future<List<PendingDateConfirmation>> pendingDateConfirmations() async => [
    PendingDateConfirmation(
      documentUuid: 'd1',
      documentType: MedicalDocumentType.laboratory,
      processingStatus: ProcessingStatus.awaitingConfirmation,
      createdAt: DateTime(2025, 6, 30),
      detectedCandidates: const [],
      requiresManualDate: true,
      pageNumber: 1,
      pageCount: 3,
      reportSubtype: ReportSubtype.labChemistry,
    ),
    PendingDateConfirmation(
      documentUuid: 'd1',
      documentType: MedicalDocumentType.laboratory,
      processingStatus: ProcessingStatus.awaitingConfirmation,
      createdAt: DateTime(2025, 6, 30),
      detectedCandidates: const [],
      requiresManualDate: true,
      pageNumber: 2,
      pageCount: 3,
      reportSubtype: ReportSubtype.labHormones,
    ),
    PendingDateConfirmation(
      documentUuid: 'd1',
      documentType: MedicalDocumentType.laboratory,
      processingStatus: ProcessingStatus.awaitingConfirmation,
      createdAt: DateTime(2025, 6, 30),
      detectedCandidates: const [],
      requiresManualDate: true,
      pageNumber: 3,
      pageCount: 3,
      reportSubtype: ReportSubtype.labCbc,
    ),
  ];
}

void main() {
  final overrides = [documentsApiProvider.overrideWithValue(_FakeApi())];

  testWidgets('detail shows extracted reports with 3 page cards', (
    tester,
  ) async {
    await tester.pumpWidget(
      pumpApp(const DocumentDetailScreen(uuid: 'd1'), overrides: overrides),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Extracted reports'), findsOneWidget);
    expect(find.textContaining('Chemistry'), findsWidgets);
    expect(find.textContaining('Hormones'), findsWidgets);
    expect(find.textContaining('CBC'), findsWidgets);
  });

  testWidgets('single-page detail keeps flat view (no page cards)', (
    tester,
  ) async {
    await tester.pumpWidget(
      pumpApp(
        const DocumentDetailScreen(uuid: 'd1'),
        overrides: [
          documentsApiProvider.overrideWithValue(_SinglePageFakeApi()),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Extracted reports'), findsNothing);
  });

  testWidgets('page results screen shows ready page results', (tester) async {
    await tester.pumpWidget(
      pumpApp(
        const DocumentPageResultsScreen(uuid: 'd1', pageNumber: 1),
        overrides: overrides,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Glucose'), findsOneWidget);
    expect(find.text('92'), findsOneWidget);
    expect(find.textContaining('Page'), findsWidgets);
  });

  testWidgets('page results screen shows failed page state', (tester) async {
    await tester.pumpWidget(
      pumpApp(
        const DocumentPageResultsScreen(uuid: 'd1', pageNumber: 3),
        overrides: overrides,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('could not be extracted'), findsOneWidget);
  });

  testWidgets('confirm queue shows per-page entries for 3-page PDF', (
    tester,
  ) async {
    await tester.pumpWidget(
      pumpApp(const ConfirmDatesScreen(), overrides: overrides),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Page 1'), findsOneWidget);
    expect(find.textContaining('Page 2'), findsOneWidget);
    expect(find.textContaining('Page 3'), findsOneWidget);
  });

  testWidgets('multi-page detail shows Preparing pages while units not ready', (
    tester,
  ) async {
    await tester.pumpWidget(
      pumpApp(
        const DocumentDetailScreen(uuid: 'd1'),
        overrides: [
          documentsApiProvider.overrideWithValue(_PreparingFakeApi()),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.textContaining('Preparing pages'), findsOneWidget);
    expect(find.textContaining('Extracted reports'), findsNothing);
  });

  testWidgets('multi-page parent detail shows pages need confirmation', (
    tester,
  ) async {
    await tester.pumpWidget(
      pumpApp(const DocumentDetailScreen(uuid: 'd1'), overrides: overrides),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('3 pages need confirmation'), findsOneWidget);
  });

  testWidgets('page results shows confirm CTA when awaiting with candidates', (
    tester,
  ) async {
    await tester.pumpWidget(
      pumpApp(
        const DocumentPageResultsScreen(uuid: 'd1', pageNumber: 1),
        overrides: [documentsApiProvider.overrideWithValue(_AwaitingApi())],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Confirm this page'), findsOneWidget);
    expect(find.textContaining('2025-06-30'), findsWidgets);
    expect(find.textContaining('manual'), findsWidgets);
  });
}

class _AwaitingApi extends DocumentsApi {
  _AwaitingApi() : super(Dio());

  @override
  Future<MedicalDocumentPageDetail> documentPageDetail(
    String uuid,
    int pageNumber,
  ) async => MedicalDocumentPageDetail(
    documentUuid: 'd1',
    pageNumber: pageNumber,
    pageCount: 3,
    reportSubtype: ReportSubtype.labChemistry,
    processingStatus: 'AWAITING_CONFIRMATION',
    labResultCount: 14,
    labResults: [
      LabResultItem(
        uuid: 'r',
        pageNumber: pageNumber,
        rowIndex: 0,
        testNameRaw: 'Glucose',
        resultRaw: '92',
        unitRaw: 'mg/dL',
        referenceRangeRaw: '70 - 99',
        extractionConfidence: 0.95,
      ),
    ],
    detectedCandidates: [
      DateCandidate(
        uuid: 'c1',
        date: DateTime(2025, 6, 30),
        type: 'REPORT_DATE',
        score: 0.99,
        pageNumber: pageNumber,
        isSuggested: true,
      ),
    ],
  );
}

class _PreparingFakeApi extends DocumentsApi {
  _PreparingFakeApi() : super(Dio());

  @override
  Future<MedicalDocumentDetail> detail(String uuid) async =>
      _detailDoc(pageCount: 3);

  @override
  Future<MedicalDocumentPageSummary> documentPages(String uuid) async =>
      const MedicalDocumentPageSummary(
        documentUuid: 'd1',
        pageCount: 0,
        pages: [],
      );

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

class _SinglePageFakeApi extends DocumentsApi {
  _SinglePageFakeApi() : super(Dio());

  @override
  Future<MedicalDocumentDetail> detail(String uuid) async =>
      _detailDoc(pageCount: 1);

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
