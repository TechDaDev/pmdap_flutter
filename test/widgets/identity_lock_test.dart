import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/pagination.dart';
import 'package:pmdap_mobile/core/models/identity.dart';
import 'package:pmdap_mobile/features/identity/application/identity_providers.dart';
import 'package:pmdap_mobile/features/identity/presentation/identity_documents_screen.dart';
import 'package:pmdap_mobile/features/patient/application/patient_providers.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

void main() {
  Future<void> pumpIdentity(WidgetTester tester, IdentityStatus status) async {
    await tester.pumpWidget(
      pumpApp(
        const IdentityDocumentsScreen(),
        overrides: [
          patientProfileProvider.overrideWith(
            (ref) async => sampleProfile(status: status),
          ),
          identityDocumentsProvider.overrideWith(
            (ref) async => const Page<IdentityDocumentSummary>(
              count: 0,
              next: null,
              previous: null,
              results: [],
            ),
          ),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('identity page PENDING: no add FAB', (tester) async {
    await pumpIdentity(tester, IdentityStatus.pendingVerification);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('identity page VERIFIED: no add FAB', (tester) async {
    await pumpIdentity(tester, IdentityStatus.verified);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('identity page REJECTED: resubmit FAB present', (tester) async {
    await pumpIdentity(tester, IdentityStatus.rejected);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Resubmit identity'), findsOneWidget);
  });

  testWidgets('identity page UNVERIFIED: add identity FAB present', (
    tester,
  ) async {
    await pumpIdentity(tester, IdentityStatus.unverified);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Add identity document'), findsOneWidget);
  });
}
