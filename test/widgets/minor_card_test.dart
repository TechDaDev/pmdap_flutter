import 'package:flutter/material.dart' hide Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/minor.dart';
import 'package:pmdap_mobile/core/models/pagination.dart';
import 'package:pmdap_mobile/core/widgets/patient_card.dart';
import 'package:pmdap_mobile/features/minors/application/minors_providers.dart';
import 'package:pmdap_mobile/features/minors/presentation/minors_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

final _eligible = AsyncValue.data(
  const GuardianEligibility(isEligible: true, checkedIdentity: true),
);

void main() {
  testWidgets('minor card shows name, digital id and identity status', (
    tester,
  ) async {
    final minor = sampleMinor();
    await tester.pumpWidget(
      pumpApp(Scaffold(body: PatientCard.fromMinor(minor: minor))),
    );

    expect(find.text('Synthetic Child'), findsOneWidget);
    expect(find.textContaining('98765432101234567'), findsOneWidget);
    expect(find.text('Pending verification'), findsOneWidget);
  });

  testWidgets('minors screen lists minors and add button', (tester) async {
    final page = Page<Minor>(
      count: 1,
      next: null,
      previous: null,
      results: [sampleMinor()],
    );
    await tester.pumpWidget(
      pumpApp(
        const MinorsScreen(),
        overrides: [
          minorsProvider.overrideWith((ref) async => page),
          guardianEligibilityProvider.overrideWithValue(_eligible),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Synthetic Child'), findsOneWidget);
    expect(find.text('Add child'), findsOneWidget);
  });

  testWidgets('minors screen empty state', (tester) async {
    final page = const Page<Minor>(
      count: 0,
      next: null,
      previous: null,
      results: [],
    );
    await tester.pumpWidget(
      pumpApp(
        const MinorsScreen(),
        overrides: [
          minorsProvider.overrideWith((ref) async => page),
          guardianEligibilityProvider.overrideWithValue(_eligible),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No children linked to your account.'), findsOneWidget);
  });

  testWidgets('pending relationship is not navigable', (tester) async {
    final pending = Minor(
      uuid: 'm-pending',
      digitalId: '98765432101234567',
      fullName: 'Pending Child',
      dateOfBirth: DateTime(2015, 8, 20),
      age: 10,
      isMinor: true,
      sex: Sex.unspecified,
      nationality: 'ZZ',
      bloodGroup: BloodGroup.oPos,
      identityStatus: IdentityStatus.unverified,
      relationship: GuardianRelationship(
        uuid: 'r1',
        relationship: Relationship.father,
        verificationStatus: VerificationStatus.pending,
        active: false,
      ),
    );
    final page = Page<Minor>(
      count: 1,
      next: null,
      previous: null,
      results: [pending],
    );
    await tester.pumpWidget(
      pumpApp(
        const MinorsScreen(),
        overrides: [
          minorsProvider.overrideWith((ref) async => page),
          guardianEligibilityProvider.overrideWithValue(_eligible),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pending Child'), findsOneWidget);
    expect(find.text('Relationship pending verification'), findsWidgets);
    final tile = tester.widget<ListTile>(find.byType(ListTile).first);
    expect(tile.enabled, isFalse);
    expect(tile.onTap, isNull);
    // Tapping must not navigate / crash.
    await tester.tap(find.text('Pending Child'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('Pending Child'), findsOneWidget);
  });

  testWidgets('verified relationship is navigable', (tester) async {
    final verified = Minor(
      uuid: 'm-verified',
      digitalId: '98765432101234567',
      fullName: 'Verified Child',
      dateOfBirth: DateTime(2015, 8, 20),
      age: 10,
      isMinor: true,
      sex: Sex.unspecified,
      nationality: 'ZZ',
      bloodGroup: BloodGroup.oPos,
      identityStatus: IdentityStatus.unverified,
      relationship: GuardianRelationship(
        uuid: 'r2',
        relationship: Relationship.father,
        verificationStatus: VerificationStatus.verified,
        active: true,
      ),
    );
    final page = Page<Minor>(
      count: 1,
      next: null,
      previous: null,
      results: [verified],
    );
    await tester.pumpWidget(
      pumpApp(
        const MinorsScreen(),
        overrides: [
          minorsProvider.overrideWith((ref) async => page),
          guardianEligibilityProvider.overrideWithValue(_eligible),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Verified Child'), findsOneWidget);
    final tile = tester.widget<ListTile>(find.byType(ListTile).first);
    expect(tile.enabled, isTrue);
    expect(tile.onTap, isNotNull);
  });
}
