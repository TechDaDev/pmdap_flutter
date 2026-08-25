import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/theme/app_theme.dart';
import 'package:pmdap_mobile/features/documents/presentation/document_upload_screen.dart';
import 'package:pmdap_mobile/features/identity/presentation/identity_submit_screen.dart';
import 'package:pmdap_mobile/features/minors/presentation/minor_create_screen.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

/// P0 regression: upload + identity forms must render their BODY (not just the
/// AppBar) in both light and dark themes.
void main() {
  Widget harness(
    Widget child, {
    required Brightness brightness,
    Locale? locale,
  }) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }

  for (final brightness in [Brightness.light, Brightness.dark]) {
    final label = brightness == Brightness.light ? 'light' : 'dark';

    testWidgets('UploadDocumentScreen body visible ($label)', (tester) async {
      await tester.pumpWidget(
        harness(const DocumentUploadScreen(), brightness: brightness),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add medical document'), findsOneWidget); // AppBar
      // BODY — source actions, required type, collapsed advanced, upload.
      expect(find.text('Scan document'), findsWidgets);
      expect(find.text('Choose existing file'), findsOneWidget);
      expect(find.text('Select type'), findsOneWidget);
      expect(find.text('Advanced details'), findsOneWidget);
      expect(find.text('Upload'), findsOneWidget);
    });

    testWidgets('advanced details expands and shows optional fields ($label)', (
      tester,
    ) async {
      await tester.pumpWidget(
        harness(const DocumentUploadScreen(), brightness: brightness),
      );
      await tester.pumpAndSettle();

      // Collapsed by default — optional metadata hidden.
      expect(find.text('Title'), findsNothing);
      expect(find.text('Description'), findsNothing);

      await tester.scrollUntilVisible(
        find.text('Advanced details'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Advanced details'));
      await tester.pumpAndSettle();

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Facility'), findsOneWidget);
      expect(find.text('Report date'), findsOneWidget);
    });

    testWidgets('IdentitySubmitScreen body visible ($label)', (tester) async {
      await tester.pumpWidget(
        harness(const IdentitySubmitScreen(), brightness: brightness),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add identity document'), findsOneWidget); // AppBar
      // BODY — scan/capture flow (no manual fields before extraction).
      expect(find.text('Document type'), findsOneWidget);
      expect(find.text('Front image'), findsOneWidget);
      expect(find.text('Back image'), findsOneWidget);
      expect(find.text('Scan front'), findsOneWidget);
      expect(find.text('Scan back'), findsOneWidget);
      expect(find.text('Choose image'), findsWidgets);
      expect(find.text('Read document'), findsOneWidget);
    });

    testWidgets('MinorCreateScreen has four-step responsive wizard ($label)', (
      tester,
    ) async {
      await tester.pumpWidget(
        harness(const MinorCreateScreen(), brightness: brightness),
      );
      await tester.pumpAndSettle();

      final stepper = tester.widget<Stepper>(find.byType(Stepper));
      expect(stepper.steps, hasLength(4));
      expect((stepper.steps[0].title as Text).data, 'Child identity');
      expect((stepper.steps[1].title as Text).data, 'Review child details');
      expect((stepper.steps[2].title as Text).data, 'Relationship');
      expect((stepper.steps[3].title as Text).data, 'Submit request');
      expect(find.text('Family number'), findsNothing);
      expect(find.text('Search child'), findsNothing);
    });

    testWidgets('child National Card review fields are locked ($label)', (
      tester,
    ) async {
      await tester.pumpWidget(
        harness(const MinorCreateScreen(), brightness: brightness),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Birth document').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('National Card').last);
      await tester.pumpAndSettle();

      for (final label in [
        'First name',
        "Father's name",
        "Grandfather's name",
        'National number',
        'Card body number',
        'Family number',
      ]) {
        expect(find.text(label), findsOneWidget);
      }
      expect(find.text('Document number'), findsNothing);
      for (final label in [
        'National number',
        'Card body number',
        'Family number',
      ]) {
        expect(
          find.ancestor(
            of: find.text(label),
            matching: find.byType(TextFormField),
          ),
          findsNothing,
        );
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('child card review has no small-phone text overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
        child: harness(const MinorCreateScreen(), brightness: Brightness.light),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Birth document').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('National Card').last);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  for (final brightness in [Brightness.light, Brightness.dark]) {
    testWidgets(
      'Arabic child card review is RTL without overflow ($brightness)',
      (tester) async {
        await tester.pumpWidget(
          harness(
            const MinorCreateScreen(),
            brightness: brightness,
            locale: const Locale('ar'),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('وثيقة ميلاد').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('البطاقة الوطنية').last);
        await tester.pumpAndSettle();

        for (final label in [
          'الاسم الأول',
          'اسم الأب',
          'اسم الجد',
          'الرقم الوطني',
          'رقم جسم البطاقة',
          'رقم العائلة',
        ]) {
          expect(find.text(label), findsOneWidget);
        }
        expect(
          Directionality.of(tester.element(find.byType(Stepper))),
          TextDirection.rtl,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
