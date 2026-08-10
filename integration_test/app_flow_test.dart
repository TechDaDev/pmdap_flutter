import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pmdap_mobile/app/app.dart';
import 'package:pmdap_mobile/core/di/providers.dart';

import 'fakes.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  ProviderScope buildApp() {
    return ProviderScope(
      overrides: [
        refreshTokenStorageProvider.overrideWithValue(FakeRefreshStorage()),
        authApiProvider.overrideWithValue(FakeAuthApi()),
        patientApiProvider.overrideWithValue(FakePatientApi()),
        documentsApiProvider.overrideWithValue(FakeDocumentsApi()),
        archiveApiProvider.overrideWithValue(FakeArchiveApi()),
        searchApiProvider.overrideWithValue(FakeSearchApi()),
        minorsApiProvider.overrideWithValue(FakeMinorsApi()),
      ],
      child: const PmdapApp(),
    );
  }

  testWidgets('login → home → logout → login', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // No session → login screen.
    expect(find.text('Sign in'), findsWidgets);

    await tester.enterText(
      find.byType(TextFormField).first,
      'patient@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'secret123');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    // Home with the synthetic patient.
    expect(find.text('Synthetic Patient'), findsOneWidget);
    expect(find.text('Lab Report'), findsOneWidget);

    // Logout from profile.
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsWidgets);
  });

  testWidgets('archive navigation and filters', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    await _login(tester);

    await tester.tap(find.text('Archive'));
    await tester.pumpAndSettle();
    expect(find.text('Archive Report'), findsOneWidget);
  });

  testWidgets('search returns results', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    await _login(tester);

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'blood');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Archive Report'), findsOneWidget);
  });

  testWidgets('minor navigation', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    await _login(tester);

    await tester.tap(find.text('Children'));
    await tester.pumpAndSettle();
    expect(find.text('Synthetic Child'), findsOneWidget);
  });
}

Future<void> _login(WidgetTester tester) async {
  await tester.enterText(
    find.byType(TextFormField).first,
    'patient@example.com',
  );
  await tester.enterText(find.byType(TextFormField).last, 'secret123');
  await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
  await tester.pumpAndSettle();
}
