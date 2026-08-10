import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/archive.dart';
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
}
