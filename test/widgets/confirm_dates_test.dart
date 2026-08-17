import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/date_candidate.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/core/models/pagination.dart';
import 'package:pmdap_mobile/core/models/pending_date_confirmation.dart';
import 'package:pmdap_mobile/features/documents/application/documents_providers.dart';
import 'package:pmdap_mobile/features/documents/data/documents_api.dart';
import 'package:pmdap_mobile/features/documents/presentation/confirm_dates_screen.dart';
import 'package:pmdap_mobile/features/documents/presentation/date_confirmation_screen.dart';

import 'package:pmdap_mobile/core/widgets/buttons.dart';
import '../helpers/pump.dart';

PendingDateConfirmation _pending({
  String uuid = 'd1',
  List<PendingDateCandidate> candidates = const [],
}) {
  return PendingDateConfirmation(
    documentUuid: uuid,
    documentType: MedicalDocumentType.laboratory,
    processingStatus: ProcessingStatus.awaitingConfirmation,
    createdAt: DateTime(2026, 3, 15),
    detectedCandidates: candidates,
    requiresManualDate: candidates.isEmpty,
  );
}

PendingDateCandidate _candidate(String uuid, DateTime date, {bool suggested = true}) {
  return PendingDateCandidate(
    uuid: uuid,
    date: date,
    confidence: suggested ? 0.92 : 0.4,
    type: 'REPORT_DATE',
    ambiguous: false,
    isSuggested: suggested,
  );
}

/// Fake API for the per-document confirmation screen (manual fallback).
class _FakeDocumentsApi extends DocumentsApi {
  _FakeDocumentsApi() : super(Dio());

  String? confirmedCandidateId;
  DateTime? confirmedDate;
  int confirmCalls = 0;

  @override
  Future<Page<DateCandidate>> dateCandidates(
    String uuid, {
    int page = 1,
  }) async {
    return Page<DateCandidate>(
      count: 0,
      next: null,
      previous: null,
      results: const [],
    );
  }

  @override
  Future<DocumentDateConfirmationResponse> confirmDate(
    String uuid, {
    String? candidateId,
    DateTime? date,
  }) async {
    confirmCalls++;
    confirmedCandidateId = candidateId;
    confirmedDate = date;
    return DocumentDateConfirmationResponse(
      uuid: uuid,
      documentDate: date ?? DateTime(2026, 3, 14),
      dateSource: DateSource.userCorrected,
      dateVerified: true,
      processingStatus: ProcessingStatus.dateConfirmed,
    );
  }
}

void main() {
  group('ConfirmDatesScreen queue', () {
    testWidgets('zero-candidate document shows manual date fallback', (
      tester,
    ) async {
      await tester.pumpWidget(
        pumpApp(
          const ConfirmDatesScreen(),
          overrides: [
            pendingDateConfirmationDocumentsProvider.overrideWith(
              (ref) async => [_pending()],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No date was detected.'), findsOneWidget);
      expect(find.text('Please enter the report date.'), findsOneWidget);
      expect(find.text('Confirm date'), findsWidgets);
    });

    testWidgets('one candidate shows the suggested date', (tester) async {
      await tester.pumpWidget(
        pumpApp(
          const ConfirmDatesScreen(),
          overrides: [
            pendingDateConfirmationDocumentsProvider.overrideWith(
              (ref) async => [
                _pending(candidates: [_candidate('c1', DateTime(2026, 3, 14))]),
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Suggested date'), findsOneWidget);
      expect(find.text('2026-03-14'), findsOneWidget);
      expect(find.text('No date was detected.'), findsNothing);
    });

    testWidgets('multiple candidates all shown, none auto-selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        pumpApp(
          const ConfirmDatesScreen(),
          overrides: [
            pendingDateConfirmationDocumentsProvider.overrideWith(
              (ref) async => [
                _pending(
                  candidates: [
                    _candidate('c1', DateTime(2026, 3, 14), suggested: true),
                    _candidate('c2', DateTime(2026, 3, 12), suggested: false),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('2026-03-14'), findsOneWidget);
      expect(find.text('2026-03-12'), findsOneWidget);
      // No "Confirm" on the card alone — the user picks on the detail screen.
      expect(find.text('Confirm date'), findsWidgets);
    });

    testWidgets('empty queue shows empty state', (tester) async {
      await tester.pumpWidget(
        pumpApp(
          const ConfirmDatesScreen(),
          overrides: [
            pendingDateConfirmationDocumentsProvider.overrideWith(
              (ref) async => [],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('No documents need date confirmation.'),
        findsOneWidget,
      );
    });
  });

  group('manual date fallback on detail confirm route', () {
    testWidgets('zero-candidate document confirms a manually entered date', (
      tester,
    ) async {
      final api = _FakeDocumentsApi();
      await tester.pumpWidget(
        pumpApp(
          const DateConfirmationScreen(documentUuid: 'd1'),
          overrides: [documentsApiProvider.overrideWithValue(api)],
        ),
      );
      await tester.pumpAndSettle();

      // Manual date button (label also used by the section title).
      final manualButton = find.widgetWithText(OutlinedButton, 'Enter date manually');
      expect(manualButton, findsOneWidget);

      // Pick today via the date-picker dialog.
      await tester.tap(manualButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Confirm button appears after a manual date is set.
      final confirm = find.widgetWithText(PrimaryButton, 'Confirm date');
      expect(confirm, findsOneWidget);
      await tester.tap(confirm);
      await tester.pumpAndSettle();

      expect(api.confirmCalls, 1);
      expect(api.confirmedCandidateId, isNull);
      expect(api.confirmedDate, isNotNull);
    });
  });
}
