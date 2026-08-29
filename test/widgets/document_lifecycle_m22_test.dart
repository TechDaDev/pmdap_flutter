import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/api/api_exception.dart';
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
import 'package:pmdap_mobile/features/documents/presentation/document_viewer_screen.dart';

import '../helpers/pump.dart';

// 1x1 transparent PNG.
final Uint8List _pngBytes = Uint8List.fromList(const [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x62,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

class _FakeApi extends DocumentsApi {
  _FakeApi({required this.detailDoc, this.bytes, this.fetchError})
    : super(Dio());

  MedicalDocumentDetail detailDoc;
  Uint8List? bytes;
  ApiException? fetchError;
  int detailCalls = 0;

  @override
  Future<MedicalDocumentDetail> detail(String uuid) async {
    detailCalls++;
    return detailDoc;
  }

  @override
  Future<Uint8List> fetchFile(String uuid) async {
    if (fetchError != null) throw fetchError!;
    return bytes!;
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

MedicalDocumentDetail _activeDoc() => MedicalDocumentDetail(
  uuid: 'd1',
  documentType: MedicalDocumentType.laboratory,
  classificationSource: ClassificationSource.systemDefault,
  title: 'Lab Report',
  description: 'Synthetic',
  documentDate: DateTime(2024, 3, 15),
  dateSource: DateSource.ocr,
  dateVerified: false,
  facilityName: 'Central Lab',
  locationText: '',
  department: 'Hematology',
  physicianName: 'Dr. X',
  processingStatus: ProcessingStatus.ocrProcessing,
  archiveStatus: ArchiveStatus.active,
  file: StoredFilePublic(
    originalFilename: 'lab.png',
    mimeType: 'image/png',
    sizeBytes: 1024,
    integrityStatus: IntegrityStatus.valid,
    malwareScanStatus: MalwareScanStatus.clean,
  ),
  textAvailable: true,
);

MedicalDocumentDetail _duplicateDoc() => _activeDoc().copyWith(
  processingStatus: ProcessingStatus.duplicateDetected,
  duplicateOf: 'existing-1',
);

void main() {
  group('processing poll retains UI (no full-page flash)', () {
    testWidgets('metadata stays rendered across a poll tick', (tester) async {
      final api = _FakeApi(detailDoc: _activeDoc());
      await tester.pumpWidget(
        pumpApp(
          DocumentDetailScreen(uuid: 'd1'),
          overrides: [documentsApiProvider.overrideWithValue(api)],
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(find.text('Lab Report'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      final callsBefore = api.detailCalls;

      // Trigger the 3s poll: a new fetch is issued but the rendered ListView
      // must NOT be replaced by a full-screen loading spinner.
      await tester.pump(const Duration(seconds: 3));
      await tester.pump();
      await tester.pump();

      expect(api.detailCalls, greaterThan(callsBefore));
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Lab Report'), findsOneWidget);
      expect(find.text('Central Lab'), findsOneWidget);
    });
  });

  group('duplicate detected', () {
    testWidgets('shows banner with view existing + remove actions', (
      tester,
    ) async {
      final api = _FakeApi(detailDoc: _duplicateDoc());
      await tester.pumpWidget(
        pumpApp(
          DocumentDetailScreen(uuid: 'd1'),
          overrides: [
            documentsApiProvider.overrideWithValue(api),
            labResultsProvider.overrideWith(
              (ref, uuid) async => LabResultsResponse(
                documentUuid: uuid,
                documentType: 'LABORATORY',
                extractionStatus: LabExtractionStatus.notApplicable,
                pipelineVersion: null,
                resultCount: 0,
                results: const [],
              ),
            ),
            extractedContentProvider.overrideWith(
              (ref, uuid) async => const ExtractedContentResponse(
                documentUuid: 'd1',
                documentType: 'LABORATORY',
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
      expect(find.text('Possible duplicate'), findsOneWidget);
      expect(
        find.text('This document appears to already exist in your archive.'),
        findsOneWidget,
      );
      expect(find.text('View existing'), findsOneWidget);
      expect(find.text('Remove this upload'), findsOneWidget);
    });
  });

  group('in-app viewer', () {
    testWidgets('image renders inside PMDAP (no external app)', (tester) async {
      final api = _FakeApi(detailDoc: _activeDoc(), bytes: _pngBytes);
      await tester.pumpWidget(
        pumpApp(
          DocumentViewerScreen(uuid: 'd1'),
          overrides: [documentsApiProvider.overrideWithValue(api)],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(InteractiveViewer), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('fetch failure shows safe message + retry', (tester) async {
      final api = _FakeApi(
        detailDoc: _activeDoc(),
        fetchError: const ApiException(
          statusCode: 404,
          code: 'medical_document_not_found',
          message: 'Medical document not found.',
        ),
      );
      await tester.pumpWidget(
        pumpApp(
          DocumentViewerScreen(uuid: 'd1'),
          overrides: [documentsApiProvider.overrideWithValue(api)],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text("We couldn't open this document."), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
