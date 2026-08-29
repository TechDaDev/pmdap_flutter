import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/archive.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/core/widgets/document_card.dart';
import 'package:pmdap_mobile/features/documents/presentation/medical_document_card.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

ArchiveDocument _cardDoc({StoredFilePublic? file}) => ArchiveDocument(
  uuid: 'a1',
  title: 'Consultation Report',
  documentType: MedicalDocumentType.consultation,
  documentDate: DateTime(2023, 11, 2),
  dateVerified: false,
  dateSource: DateSource.ocr,
  facilityName: 'City Clinic',
  department: 'General',
  physicianName: 'Dr. Y',
  processingStatus: ProcessingStatus.awaitingConfirmation,
  file: file,
);

Future<void> _pumpCard(WidgetTester tester, ArchiveDocument doc) async {
  await tester.pumpWidget(
    pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [DocumentCard(document: doc)]),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('DocumentCard renders safe metadata, never OCR text', (
    tester,
  ) async {
    final doc = _cardDoc();
    await _pumpCard(tester, doc);

    expect(find.text('Consultation Report'), findsOneWidget);
    expect(find.textContaining('City Clinic'), findsOneWidget);
    expect(find.text('2 Nov 2023'), findsOneWidget);
    // Raw OCR/date-source must never be shown:
    expect(find.text('OCR'), findsNothing);
  });

  testWidgets('DocumentCard shows PDF source tag from real pdf mime type', (
    tester,
  ) async {
    await _pumpCard(
      tester,
      _cardDoc(
        file: StoredFilePublic(
          mimeType: 'application/pdf',
          pageCount: 3,
          sizeBytes: 2048,
        ),
      ),
    );
    expect(find.text('PDF'), findsOneWidget);
    expect(find.text('Image'), findsNothing);
  });

  testWidgets('DocumentCard shows Image source tag from image mime type', (
    tester,
  ) async {
    await _pumpCard(
      tester,
      _cardDoc(
        file: StoredFilePublic(
          mimeType: 'image/png',
          pageCount: 1,
          sizeBytes: 1024,
        ),
      ),
    );
    expect(find.text('Image'), findsOneWidget);
    expect(find.text('PDF'), findsNothing);
  });

  testWidgets('DocumentCard tag comes from media type, never page_count', (
    tester,
  ) async {
    // Multi-page image must still be Image, not PDF.
    await _pumpCard(
      tester,
      _cardDoc(
        file: StoredFilePublic(
          mimeType: 'image/jpeg',
          pageCount: 5,
          sizeBytes: 4096,
        ),
      ),
    );
    expect(find.text('Image'), findsOneWidget);
    expect(find.text('PDF'), findsNothing);
  });

  testWidgets('DocumentCard hides tag when mime type unknown', (tester) async {
    await _pumpCard(tester, _cardDoc(file: StoredFilePublic(mimeType: '')));
    expect(find.text('PDF'), findsNothing);
    expect(find.text('Image'), findsNothing);

    await _pumpCard(
      tester,
      _cardDoc(file: StoredFilePublic(mimeType: 'text/plain')),
    );
    expect(find.text('PDF'), findsNothing);
    expect(find.text('Image'), findsNothing);

    // No file at all -> hidden.
    await _pumpCard(tester, _cardDoc(file: null));
    expect(find.text('PDF'), findsNothing);
    expect(find.text('Image'), findsNothing);
  });

  testWidgets('MedicalDocumentCard shows status badge + title', (tester) async {
    final doc = sampleDocument(
      title: 'Radiology Report',
      type: MedicalDocumentType.radiology,
      processing: ProcessingStatus.dateConfirmed,
    );
    await tester.pumpWidget(
      pumpApp(
        Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [MedicalDocumentCard(document: doc)]),
          ),
        ),
      ),
    );
    expect(find.text('Radiology Report'), findsOneWidget);
    expect(find.text('Date confirmed'), findsOneWidget);
  });
}
