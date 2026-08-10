import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/archive.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/pagination.dart';
import 'package:pmdap_mobile/features/archive/application/archive_providers.dart';
import 'package:pmdap_mobile/features/archive/presentation/archive_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

void main() {
  const adult = ArchiveScope.adult();

  testWidgets('archive renders documents and unconfirmed state', (
    tester,
  ) async {
    final page = ArchivePage<ArchiveDocument>(
      count: 1,
      next: null,
      previous: null,
      results: [
        sampleArchiveDocument(
          verified: false,
          processing: ProcessingStatus.awaitingConfirmation,
        ),
      ],
      unconfirmedDateCount: 1,
    );
    await tester.pumpWidget(
      pumpApp(
        const ArchiveScreen(),
        overrides: [
          archiveProvider(adult).overrideWith((ref) async => page),
          archiveSummaryProvider(
            adult,
          ).overrideWith((ref) async => const ArchiveSummary()),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Archive Report'), findsOneWidget);
    expect(find.text('2 Nov 2023'), findsOneWidget);
  });

  testWidgets('archive empty state', (tester) async {
    final page = const ArchivePage<ArchiveDocument>(
      count: 0,
      next: null,
      previous: null,
      results: [],
      unconfirmedDateCount: 0,
    );
    await tester.pumpWidget(
      pumpApp(
        const ArchiveScreen(),
        overrides: [
          archiveProvider(adult).overrideWith((ref) async => page),
          archiveSummaryProvider(
            adult,
          ).overrideWith((ref) async => const ArchiveSummary()),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No documents in the archive.'), findsOneWidget);
  });

  testWidgets('archive error state shows retry', (tester) async {
    await tester.pumpWidget(
      pumpApp(
        const ArchiveScreen(),
        overrides: [
          archiveProvider(adult).overrideWith(
            (ref) =>
                Future<ArchivePage<ArchiveDocument>>.error(Exception('boom')),
          ),
          archiveSummaryProvider(
            adult,
          ).overrideWith((ref) async => const ArchiveSummary()),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('year filter chip updates the applied filter', (tester) async {
    final page = ArchivePage<ArchiveDocument>(
      count: 0,
      next: null,
      previous: null,
      results: const [],
      unconfirmedDateCount: 0,
    );
    await tester.pumpWidget(
      pumpApp(
        const ArchiveScreen(),
        overrides: [
          archiveProvider(adult).overrideWith((ref) async => page),
          archiveSummaryProvider(
            adult,
          ).overrideWith((ref) async => const ArchiveSummary()),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Open the year filter.
    await tester.tap(find.text('All years'));
    await tester.pumpAndSettle();
    // Choose a year.
    final currentYear = DateTime.now().year.toString();
    await tester.tap(find.text(currentYear).last);
    await tester.pumpAndSettle();

    // The "All years" chip is replaced by the selected year label.
    expect(find.text('All years'), findsNothing);
    expect(find.text(currentYear), findsWidgets);
  });
}
