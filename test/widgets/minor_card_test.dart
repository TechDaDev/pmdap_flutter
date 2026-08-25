import 'package:flutter/material.dart' hide Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/guardian_relationship_summary.dart';
import 'package:pmdap_mobile/core/models/pagination.dart';
import 'package:pmdap_mobile/core/widgets/patient_card.dart';
import 'package:pmdap_mobile/features/minors/application/minors_providers.dart';
import 'package:pmdap_mobile/features/minors/presentation/minors_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

const _eligible = AsyncValue.data(GuardianEligibility(isEligible: true));

GuardianRelationshipSummary relationship(
  GuardianRelationshipStatus status, {
  String name = 'Synthetic Child',
}) => GuardianRelationshipSummary(
  uuid: 'relationship-${status.api}',
  child: GuardianChildSummary(
    uuid: 'minor-${status.api}',
    digitalId: 'PT-SAFE-0001',
    fullName: name,
  ),
  relationship: Relationship.mother,
  status: status,
  canRevoke: status == GuardianRelationshipStatus.verified,
  createdAt: DateTime(2026, 8, 25),
);

void main() {
  testWidgets('minor patient card remains available for medical contexts', (
    tester,
  ) async {
    await tester.pumpWidget(
      pumpApp(Scaffold(body: PatientCard.fromMinor(minor: sampleMinor()))),
    );
    expect(find.text('Synthetic Child'), findsOneWidget);
  });

  testWidgets('My children renders pending verified rejected and revoked', (
    tester,
  ) async {
    final values = GuardianRelationshipStatus.values
        .where((status) => status != GuardianRelationshipStatus.unknown)
        .map((status) => relationship(status, name: status.api))
        .toList();
    await tester.pumpWidget(
      pumpApp(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: MinorsScreen(),
        ),
        overrides: [
          guardianEligibilityProvider.overrideWithValue(_eligible),
          guardianRelationshipsProvider.overrideWith(
            (ref) async => Page(
              count: values.length,
              next: null,
              previous: null,
              results: values,
            ),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    for (final name in ['PENDING', 'VERIFIED', 'REJECTED', 'REVOKED']) {
      expect(find.text(name), findsOneWidget);
    }
    expect(find.text('Add child'), findsOneWidget);
    expect(find.textContaining('PT-SAFE'), findsNothing);
  });

  testWidgets('My children empty state explains verification', (tester) async {
    await tester.pumpWidget(
      pumpApp(
        const MinorsScreen(),
        overrides: [
          guardianEligibilityProvider.overrideWithValue(_eligible),
          guardianRelationshipsProvider.overrideWith(
            (ref) async => const Page<GuardianRelationshipSummary>(
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

    expect(find.textContaining('No child relationships'), findsOneWidget);
    expect(find.textContaining('reviewed before access'), findsOneWidget);
  });

  testWidgets('unknown backend state has safe fallback label', (tester) async {
    await tester.pumpWidget(
      pumpApp(
        const MinorsScreen(),
        overrides: [
          guardianEligibilityProvider.overrideWithValue(_eligible),
          guardianRelationshipsProvider.overrideWith(
            (ref) async => Page(
              count: 1,
              next: null,
              previous: null,
              results: [relationship(GuardianRelationshipStatus.unknown)],
            ),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Status unavailable'), findsOneWidget);
  });

  testWidgets('Arabic RTL dark mode fits a 320px phone without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      pumpApp(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: MinorsScreen(),
        ),
        locale: const Locale('ar'),
        themeMode: ThemeMode.dark,
        overrides: [
          guardianEligibilityProvider.overrideWithValue(_eligible),
          guardianRelationshipsProvider.overrideWith(
            (ref) async => Page(
              count: 1,
              next: null,
              previous: null,
              results: [
                relationship(
                  GuardianRelationshipStatus.pending,
                  name: 'طفل تجريبي',
                ),
              ],
            ),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('طفل تجريبي'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('طفل تجريبي'))),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('app resume refreshes relationship state once', (tester) async {
    var loads = 0;
    await tester.pumpWidget(
      pumpApp(
        const MinorsScreen(),
        overrides: [
          guardianEligibilityProvider.overrideWithValue(_eligible),
          guardianRelationshipsProvider.overrideWith((ref) async {
            loads++;
            return const Page<GuardianRelationshipSummary>(
              count: 0,
              next: null,
              previous: null,
              results: [],
            );
          }),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(loads, 1);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    expect(loads, 2);
  });
}
