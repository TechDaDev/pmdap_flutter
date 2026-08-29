import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/archive.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/core/models/pagination.dart' as models;
import 'package:pmdap_mobile/features/archive/application/archive_providers.dart';
import 'package:pmdap_mobile/features/archive/data/archive_api.dart';
import 'package:pmdap_mobile/features/archive/presentation/archive_screen.dart';
import 'package:pmdap_mobile/features/documents/application/documents_providers.dart';
import 'package:pmdap_mobile/features/home/presentation/home_screen.dart';
import 'package:pmdap_mobile/features/patient/application/patient_providers.dart';
import 'package:pmdap_mobile/features/search/application/search_providers.dart';
import 'package:pmdap_mobile/features/search/data/search_api.dart';
import 'package:pmdap_mobile/features/search/presentation/search_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

/// Regression tests for defects observed on the physical device.
void main() {
  Future<void> pumpHome(WidgetTester tester, {double width = 360}) async {
    tester.view.physicalSize = Size(width * 3, 800 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      pumpApp(
        const HomeScreen(),
        overrides: [
          patientProfileProvider.overrideWith((ref) async => sampleProfile()),
          pendingDateConfirmationDocumentsProvider.overrideWith(
            (ref) async => const [],
          ),
          documentsProvider.overrideWith(
            (ref) async => models.Page<MedicalDocument>(
              count: 1,
              next: null,
              previous: null,
              results: [sampleDocument()],
            ),
          ),
          archiveSummaryProvider(const ArchiveScope.adult()).overrideWith(
            (ref) async => const ArchiveSummary(unconfirmedDateCount: 2),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
  }

  group('home shortcut no word breaking', () {
    for (final width in [360.0, 390.0, 430.0]) {
      testWidgets('no overflow at ${width.toInt()}dp', (tester) async {
        await pumpHome(tester, width: width);
        expect(find.text('Confirm dates'), findsOneWidget);
        expect(find.text('Upload document'), findsOneWidget);
        expect(find.text('My children'), findsOneWidget);
        expect(find.text('Identity'), findsOneWidget);
        // No RenderFlex / overflow exceptions.
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('no overflow at 200% text scale', (tester) async {
      tester.view.physicalSize = const Size(360 * 3, 800 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: pumpApp(
            const HomeScreen(),
            overrides: [
              patientProfileProvider.overrideWith(
                (ref) async => sampleProfile(),
              ),
              documentsProvider.overrideWith(
                (ref) async => models.Page<MedicalDocument>(
                  count: 1,
                  next: null,
                  previous: null,
                  results: [sampleDocument()],
                ),
              ),
              archiveSummaryProvider(const ArchiveScope.adult()).overrideWith(
                (ref) async => const ArchiveSummary(unconfirmedDateCount: 0),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Confirm dates'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Confirm dates'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('search empty states', () {
    testWidgets('empty query shows search prompt', (tester) async {
      await tester.pumpWidget(
        pumpApp(
          const SearchScreen(),
          overrides: [
            searchResultsProvider.overrideWith(
              (ref) async => const models.Page<ArchiveDocument>(
                count: 0,
                next: null,
                previous: null,
                results: [],
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Search your medical records'), findsOneWidget);
      expect(find.text('No results found.'), findsNothing);
    });

    testWidgets('non-empty query with zero results shows no-results', (
      tester,
    ) async {
      await tester.pumpWidget(
        pumpApp(
          const SearchScreen(),
          overrides: [
            searchQueryProvider.overrideWith(
              (ref) => const SearchQuery(q: 'x-ray'),
            ),
            searchResultsProvider.overrideWith(
              (ref) async => const models.Page<ArchiveDocument>(
                count: 0,
                next: null,
                previous: null,
                results: [],
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No results found.'), findsOneWidget);
    });
  });

  group('archive empty states', () {
    testWidgets('default empty shows upload CTA', (tester) async {
      await tester.pumpWidget(
        pumpApp(
          const ArchiveScreen(),
          overrides: [
            archiveProvider(const ArchiveScope.adult()).overrideWith(
              (ref) async => const models.ArchivePage<ArchiveDocument>(
                count: 0,
                next: null,
                previous: null,
                results: [],
                unconfirmedDateCount: 0,
              ),
            ),
            archiveSummaryProvider(
              const ArchiveScope.adult(),
            ).overrideWith((ref) async => const ArchiveSummary()),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No documents in the archive.'), findsOneWidget);
      expect(find.text('Upload document'), findsOneWidget);
    });

    testWidgets('UNCONFIRMED empty shows its own message, no CTA', (
      tester,
    ) async {
      await tester.pumpWidget(
        pumpApp(
          const ArchiveScreen(),
          overrides: [
            archiveFilterProvider('adult').overrideWith(
              (ref) => const ArchiveQuery(dateStatus: 'UNCONFIRMED'),
            ),
            archiveProvider(const ArchiveScope.adult()).overrideWith(
              (ref) async => const models.ArchivePage<ArchiveDocument>(
                count: 0,
                next: null,
                previous: null,
                results: [],
                unconfirmedDateCount: 0,
              ),
            ),
            archiveSummaryProvider(
              const ArchiveScope.adult(),
            ).overrideWith((ref) async => const ArchiveSummary()),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No documents need date confirmation.'), findsOneWidget);
      expect(find.text('Upload document'), findsNothing);
    });
  });
}
