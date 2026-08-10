import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/date_candidate.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/core/models/pagination.dart';
import 'package:pmdap_mobile/features/documents/data/documents_api.dart';
import 'package:pmdap_mobile/features/documents/presentation/date_confirmation_screen.dart';

import '../helpers/pump.dart';

class _FakeDocumentsApi extends DocumentsApi {
  _FakeDocumentsApi() : super(Dio());

  String? confirmedCandidateId;
  DateTime? confirmedDate;

  @override
  Future<Page<DateCandidate>> dateCandidates(
    String uuid, {
    int page = 1,
  }) async {
    return Page<DateCandidate>(
      count: 2,
      next: null,
      previous: null,
      results: [
        DateCandidate(
          uuid: 'c1',
          date: DateTime(2024, 3, 15),
          type: 'report_date',
          score: 0.92,
          pageNumber: 1,
          source: Source.ocr,
          ambiguous: false,
          isSuggested: true,
        ),
        DateCandidate(
          uuid: 'c2',
          date: DateTime(2024, 3, 14),
          type: 'report_date',
          score: 0.5,
          pageNumber: 2,
          source: Source.ocr,
          ambiguous: true,
          isSuggested: false,
        ),
      ],
    );
  }

  @override
  Future<DocumentDateConfirmationResponse> confirmDate(
    String uuid, {
    String? candidateId,
    DateTime? date,
  }) async {
    confirmedCandidateId = candidateId;
    confirmedDate = date;
    return DocumentDateConfirmationResponse(
      uuid: uuid,
      documentDate: date ?? DateTime(2024, 3, 15),
      dateSource: DateSource.userConfirmed,
      dateVerified: true,
      processingStatus: ProcessingStatus.dateConfirmed,
    );
  }
}

void main() {
  testWidgets('lists candidates with safe metadata', (tester) async {
    final api = _FakeDocumentsApi();
    await tester.pumpWidget(
      pumpApp(
        DateConfirmationScreen(documentUuid: 'd1'),
        overrides: [documentsApiProvider.overrideWithValue(api)],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('2024-03-15'), findsOneWidget);
    expect(find.text('2024-03-14'), findsOneWidget);
    expect(find.textContaining('Score: 0.92'), findsOneWidget);
    expect(find.textContaining('Ambiguous'), findsOneWidget);
  });

  testWidgets('tapping a candidate confirms with candidate_id', (tester) async {
    final api = _FakeDocumentsApi();
    await tester.pumpWidget(
      pumpApp(
        DateConfirmationScreen(documentUuid: 'd1'),
        overrides: [documentsApiProvider.overrideWithValue(api)],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('2024-03-15'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(api.confirmedCandidateId, 'c1');
    expect(api.confirmedDate, isNull);
    expect(find.text('Date confirmed.'), findsOneWidget);
  });

  testWidgets('manual date confirmation sends date', (tester) async {
    final api = _FakeDocumentsApi();
    await tester.pumpWidget(
      pumpApp(
        DateConfirmationScreen(documentUuid: 'd1'),
        overrides: [documentsApiProvider.overrideWithValue(api)],
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.widgetWithText(OutlinedButton, 'Enter date manually'),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(OutlinedButton, 'Enter date manually'),
    );
    await tester.pumpAndSettle();

    // Confirm the picker with the default selection; the picked day is read
    // back from the manual-date button label so the assertion is robust.
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    final manualLabel = tester
        .widget<Text>(
          find.descendant(
            of: find.byType(OutlinedButton),
            matching: find.byType(Text),
          ),
        )
        .data!;
    final expected = DateTime.parse(manualLabel);

    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Confirm date'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Confirm date'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(api.confirmedDate, isNotNull);
    expect(api.confirmedDate, expected);
  });
}
