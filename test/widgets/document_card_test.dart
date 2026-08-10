import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/archive.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/widgets/document_card.dart';
import 'package:pmdap_mobile/features/documents/presentation/medical_document_card.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

void main() {
  testWidgets('DocumentCard renders safe metadata, never OCR text', (
    tester,
  ) async {
    final doc = ArchiveDocument(
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
    );
    await tester.pumpWidget(
      pumpApp(
        Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [DocumentCard(document: doc)]),
          ),
        ),
      ),
    );

    expect(find.text('Consultation Report'), findsOneWidget);
    expect(find.textContaining('City Clinic'), findsOneWidget);
    expect(find.text('2 Nov 2023'), findsOneWidget);
    // Raw OCR/date-source must never be shown:
    expect(find.text('OCR'), findsNothing);
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
