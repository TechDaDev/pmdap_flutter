import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/minor.dart';
import 'package:pmdap_mobile/core/models/pagination.dart';
import 'package:pmdap_mobile/core/widgets/patient_card.dart';
import 'package:pmdap_mobile/features/minors/application/minors_providers.dart';
import 'package:pmdap_mobile/features/minors/presentation/minors_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

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
        overrides: [minorsProvider.overrideWith((ref) async => page)],
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
        overrides: [minorsProvider.overrideWith((ref) async => page)],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No children linked to your account.'), findsOneWidget);
  });
}
