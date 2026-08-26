import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/guardian_relationship_summary.dart';
import 'package:pmdap_mobile/features/minors/application/minors_providers.dart';
import 'package:pmdap_mobile/features/minors/presentation/minor_detail_screen.dart';
import 'package:pmdap_mobile/features/minors/data/minors_api.dart';

import '../helpers/pump.dart';

GuardianRelationshipSummary detail(GuardianRelationshipStatus status) =>
    GuardianRelationshipSummary(
      uuid: 'relationship-1',
      child: const GuardianChildSummary(
        uuid: 'minor-1',
        digitalId: 'PT-SAFE-0001',
        fullName: 'Synthetic Child',
      ),
      relationship: Relationship.legalGuardian,
      status: status,
      canRevoke: status == GuardianRelationshipStatus.verified,
      createdAt: DateTime(2026, 8, 25),
      verifiedAt: status == GuardianRelationshipStatus.verified
          ? DateTime(2026, 8, 25)
          : null,
    );

class _RevokeApi extends MinorsApi {
  _RevokeApi() : super(Dio());
  int calls = 0;

  @override
  Future<void> revokeRelationship(String uuid) async {
    calls++;
  }
}

void main() {
  for (final entry in {
    GuardianRelationshipStatus.pending: 'Request received',
    GuardianRelationshipStatus.rejected: 'not approved',
    GuardianRelationshipStatus.revoked: 'access has ended',
  }.entries) {
    testWidgets('${entry.key.api} detail is informative and non-medical', (
      tester,
    ) async {
      await tester.pumpWidget(
        pumpApp(
          const MinorDetailScreen(uuid: 'relationship-1'),
          overrides: [
            guardianRelationshipDetailProvider(
              'relationship-1',
            ).overrideWith((ref) async => detail(entry.key)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining(entry.value), findsOneWidget);
      expect(find.text('Documents'), findsNothing);
      expect(find.text('Revoke access'), findsNothing);
    });
  }

  testWidgets('verified detail shows Open records and revoke action', (
    tester,
  ) async {
    await tester.pumpWidget(
      pumpApp(
        const MinorDetailScreen(uuid: 'relationship-1'),
        overrides: [
          guardianRelationshipDetailProvider('relationship-1').overrideWith(
            (ref) async => detail(GuardianRelationshipStatus.verified),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Open records'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Revoke access'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Revoke access'), findsOneWidget);
  });

  testWidgets('revoke cancel calls no API; confirm calls exactly once', (
    tester,
  ) async {
    final api = _RevokeApi();
    await tester.pumpWidget(
      pumpApp(
        const MinorDetailScreen(uuid: 'relationship-1'),
        overrides: [
          minorsApiProvider.overrideWithValue(api),
          guardianRelationshipDetailProvider('relationship-1').overrideWith(
            (ref) async => detail(GuardianRelationshipStatus.verified),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Revoke access'),
      180,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.tap(find.text('Revoke access'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(api.calls, 0);

    await tester.tap(find.text('Revoke access'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Revoke access'));
    await tester.pumpAndSettle();
    expect(api.calls, 1);
  });
}
