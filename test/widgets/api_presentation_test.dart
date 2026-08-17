import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/archive.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/core/models/minor.dart';
import 'package:pmdap_mobile/core/models/pagination.dart' as models;
import 'package:pmdap_mobile/core/models/pending_date_confirmation.dart';
import 'package:pmdap_mobile/features/archive/application/archive_providers.dart';
import 'package:pmdap_mobile/features/documents/application/documents_providers.dart';
import 'package:pmdap_mobile/features/documents/presentation/medical_document_card.dart';
import 'package:pmdap_mobile/features/home/presentation/home_screen.dart';
import 'package:pmdap_mobile/features/minors/application/minors_providers.dart';
import 'package:pmdap_mobile/features/minors/presentation/minors_screen.dart';
import 'package:pmdap_mobile/features/patient/application/patient_providers.dart';
import 'package:pmdap_mobile/features/patient/presentation/profile_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

/// Verifies patient-facing screens map realistic (snake_case) API responses
/// to localized labels, semantic badges, and LTR digital IDs.
PendingDateConfirmation _pendingDoc(String uuid) => PendingDateConfirmation(
  documentUuid: uuid,
  documentType: MedicalDocumentType.laboratory,
  processingStatus: ProcessingStatus.awaitingConfirmation,
  createdAt: DateTime(2026, 3, 15),
  detectedCandidates: const [],
  requiresManualDate: true,
);

void main() {
  /// True when [text] sits under a LTR [Directionality].
  bool ltrAncestor(WidgetTester tester, String text) {
    final dirs = tester.widgetList<Directionality>(
      find.ancestor(of: find.text(text), matching: find.byType(Directionality)),
    );
    return dirs.any((d) => d.textDirection == TextDirection.ltr);
  }

  group('profile', () {
    testWidgets('verified identity uses success badge + initials avatar', (
      tester,
    ) async {
      await tester.pumpWidget(
        pumpApp(
          const ProfileScreen(),
          overrides: [
            patientProfileProvider.overrideWith(
              (ref) async => sampleProfile(status: IdentityStatus.verified),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Semantic badge label, not a raw enum.
      expect(find.text('Verified'), findsOneWidget);
      // Arabic-safe first+last initials from fullName.
      expect(find.text('SP'), findsOneWidget);
      // Digital ID is forced LTR.
      expect(ltrAncestor(tester, '12345678901234567'), isTrue);
      // Localized date for 1990-05-10.
      expect(find.text('10 May 1990'), findsOneWidget);
    });

    testWidgets('rejected identity shows error-state label', (tester) async {
      await tester.pumpWidget(
        pumpApp(
          const ProfileScreen(),
          overrides: [
            patientProfileProvider.overrideWith(
              (ref) async => sampleProfile(status: IdentityStatus.rejected),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Rejected'), findsOneWidget);
    });
  });

  group('medical document card', () {
    testWidgets('blank title falls back to localized type; facility shown', (
      tester,
    ) async {
      final doc = MedicalDocument(
        uuid: 'x1',
        documentType: MedicalDocumentType.laboratory,
        title: '',
        documentDate: DateTime(2024, 3, 15),
        facilityName: 'Central Lab',
        locationText: '',
        department: 'Hematology',
        processingStatus: ProcessingStatus.dateConfirmed,
      );
      await tester.pumpWidget(
        pumpApp(Material(child: MedicalDocumentCard(document: doc))),
      );

      expect(find.text('Laboratory'), findsOneWidget); // type fallback title
      expect(find.textContaining('Central Lab'), findsOneWidget); // facility
      expect(find.text('15 Mar 2024'), findsOneWidget); // localized date
    });

    testWidgets('facility falls back to canonical healthcare facility', (
      tester,
    ) async {
      final doc = MedicalDocument(
        uuid: 'x2',
        documentType: MedicalDocumentType.prescription,
        title: 'Rx',
        documentDate: DateTime(2024, 3, 15),
        facilityName: '',
        locationText: 'Baghdad',
        processingStatus: ProcessingStatus.dateConfirmed,
      );
      await tester.pumpWidget(
        pumpApp(Material(child: MedicalDocumentCard(document: doc))),
      );

      // Empty facilityName -> locationText fallback.
      expect(find.text('Baghdad'), findsOneWidget);
    });
  });

  group('home', () {
    testWidgets('shows digital ID LTR and unconfirmed shortcut count', (
      tester,
    ) async {
      await tester.pumpWidget(
        pumpApp(
          const HomeScreen(),
          overrides: [
            patientProfileProvider.overrideWith((ref) async => sampleProfile()),
            documentsProvider.overrideWith(
              (ref) async => models.Page<MedicalDocument>(
                count: 1,
                next: null,
                previous: null,
                results: [sampleDocument()],
              ),
            ),
            pendingDateConfirmationDocumentsProvider.overrideWith(
              (ref) async => [
                _pendingDoc('d1'),
                _pendingDoc('d2'),
                _pendingDoc('d3'),
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Greeting from profile fullName.
      expect(find.textContaining('Hello'), findsOneWidget);
      // Digital ID card kept LTR.
      expect(ltrAncestor(tester, '12345678901234567'), isTrue);
      // Needs-confirmation shortcut surfaces the single-source queue count.
      expect(find.text('3'), findsOneWidget);
    });
  });

  group('minors', () {
    testWidgets('shows digital id LTR + verified relationship badge', (
      tester,
    ) async {
      await tester.pumpWidget(
        pumpApp(
          const MinorsScreen(),
          overrides: [
            guardianEligibilityProvider.overrideWithValue(
              const AsyncValue.data(GuardianEligibility(isEligible: true)),
            ),
            minorsProvider.overrideWith(
              (ref) async => models.Page<Minor>(
                count: 1,
                next: null,
                previous: null,
                results: [sampleMinor()],
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Synthetic Child'), findsOneWidget);
      expect(find.textContaining('98765432101234567'), findsOneWidget);
      // Relationship verification badge label.
      expect(find.text('Verified'), findsOneWidget);
    });
  });
}
