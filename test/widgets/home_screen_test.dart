import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/archive.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/core/models/pagination.dart';
import 'package:pmdap_mobile/features/archive/application/archive_providers.dart';
import 'package:pmdap_mobile/features/documents/application/documents_providers.dart';
import 'package:pmdap_mobile/features/home/presentation/home_screen.dart';
import 'package:pmdap_mobile/features/patient/application/patient_providers.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

void main() {
  testWidgets('home renders without error', (tester) async {
    final summary = ArchiveSummary(unconfirmedDateCount: 2);
    final docs = Page<MedicalDocument>(
      count: 1,
      next: null,
      previous: null,
      results: [sampleDocument()],
    );
    await tester.pumpWidget(
      pumpApp(
        const HomeScreen(),
        overrides: [
          patientProfileProvider.overrideWith((ref) async => sampleProfile()),
          pendingDateConfirmationDocumentsProvider.overrideWith(
            (ref) async => const [],
          ),
          archiveSummaryProvider(
            const ArchiveScope.adult(),
          ).overrideWith((ref) async => summary),
          documentsProvider.overrideWith((ref) async => docs),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Greeting shows "Hello," with comma + first name
    expect(find.text('Hello, Synthetic'), findsOneWidget);
    // Digital ID is shown
    expect(find.textContaining('12345678901234567'), findsOneWidget);
  });

  testWidgets('home shows empty state without crash', (tester) async {
    final docs = const Page<MedicalDocument>(
      count: 0,
      next: null,
      previous: null,
      results: [],
    );
    await tester.pumpWidget(
      pumpApp(
        const HomeScreen(),
        overrides: [
          patientProfileProvider.overrideWith((ref) async => sampleProfile()),
          pendingDateConfirmationDocumentsProvider.overrideWith(
            (ref) async => const [],
          ),
          archiveSummaryProvider(
            const ArchiveScope.adult(),
          ).overrideWith((ref) async => const ArchiveSummary()),
          documentsProvider.overrideWith((ref) async => docs),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    // Verify greeting renders (proves providers are working)
    expect(find.text('Hello, Synthetic'), findsOneWidget);
  });

  Future<void> pumpHome(WidgetTester tester, IdentityStatus status) async {
    final docs = const Page<MedicalDocument>(
      count: 0,
      next: null,
      previous: null,
      results: [],
    );
    await tester.pumpWidget(
      pumpApp(
        const HomeScreen(),
        overrides: [
          patientProfileProvider.overrideWith(
            (ref) async => sampleProfile(status: status),
          ),
          archiveSummaryProvider(
            const ArchiveScope.adult(),
          ).overrideWith((ref) async => const ArchiveSummary()),
          documentsProvider.overrideWith((ref) async => docs),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('identity card VERIFIED: note + manage enabled', (tester) async {
    await pumpHome(tester, IdentityStatus.verified);
    expect(find.text('Your identity has been verified.'), findsOneWidget);
    final button = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Manage identity'),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('identity card PENDING: note shown + manage disabled', (
    tester,
  ) async {
    await pumpHome(tester, IdentityStatus.pendingVerification);
    expect(find.text('Your National Card is being reviewed.'), findsOneWidget);
    final button = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Manage identity'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('identity card REJECTED: needs attention + resubmit enabled', (
    tester,
  ) async {
    await pumpHome(tester, IdentityStatus.rejected);
    expect(find.text('Needs attention'), findsOneWidget);
    expect(find.text('Your National Card was not accepted.'), findsOneWidget);
    final button = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Resubmit identity'),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('identity card UNVERIFIED: add identity enabled', (tester) async {
    await pumpHome(tester, IdentityStatus.unverified);
    expect(find.text('Not submitted'), findsOneWidget);
    final button = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Add identity'),
    );
    expect(button.onPressed, isNotNull);
  });
}
