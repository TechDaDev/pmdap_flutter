import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/preferences/app_preferences.dart';
import 'package:pmdap_mobile/core/preferences/app_preferences_controller.dart';
import 'package:pmdap_mobile/core/preferences/app_preferences_repository.dart';
import 'package:pmdap_mobile/features/settings/presentation/settings_screen.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mirrors the app root: resolves locale + theme from the preferences provider
/// so changing a setting rebuilds the whole tree immediately.
Widget harness(AppPreferencesRepository repo) {
  return ProviderScope(
    overrides: [appPreferencesRepositoryProvider.overrideWithValue(repo)],
    child: Consumer(
      builder: (context, ref, _) {
        final locale = ref.watch(resolvedLocaleProvider);
        final themeMode = ref.watch(themeModeProvider);
        return MaterialApp(
          locale: locale,
          themeMode: themeMode,
          theme: ThemeData(brightness: Brightness.light),
          darkTheme: ThemeData(brightness: Brightness.dark),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsScreen(),
        );
      },
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<AppPreferencesRepository> repo(Map<String, Object> seed) async {
    SharedPreferences.setMockInitialValues(seed);
    final prefs = await SharedPreferences.getInstance();
    return AppPreferencesRepository(prefs);
  }

  testWidgets('English selection switches app to English', (tester) async {
    // Start Arabic so switching to English is observable.
    final r = await repo({'pmdap_language_preference': 'ar'});
    await tester.pumpWidget(harness(r));
    await tester.pumpAndSettle();
    expect(find.text('إعدادات التطبيق'), findsOneWidget);

    await tester.tap(find.text('اللغة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('الإنجليزية'));
    await tester.pumpAndSettle();

    expect(find.text('App settings'), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).locale,
      const Locale('en'),
    );
  });

  testWidgets('Arabic selection switches to ar + RTL immediately', (
    tester,
  ) async {
    final r = await repo({});
    await tester.pumpWidget(harness(r));
    await tester.pumpAndSettle();
    expect(find.text('App settings'), findsOneWidget);

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    expect(find.text('إعدادات التطبيق'), findsOneWidget);
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('ar'));
    // Page direction becomes RTL.
    final direction = Directionality.of(
      tester.element(find.text('إعدادات التطبيق')),
    );
    expect(direction, TextDirection.rtl);
  });

  testWidgets('theme Light maps to ThemeMode.light', (tester) async {
    final r = await repo({'pmdap_theme_preference': 'light'});
    await tester.pumpWidget(harness(r));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
  });

  testWidgets('theme Dark maps to ThemeMode.dark', (tester) async {
    final r = await repo({'pmdap_theme_preference': 'dark'});
    await tester.pumpWidget(harness(r));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  testWidgets('theme System maps to ThemeMode.system', (tester) async {
    final r = await repo({});
    await tester.pumpWidget(harness(r));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.system,
    );
  });

  testWidgets('Appearance selection persists via controller', (tester) async {
    final r = await repo({});
    await tester.pumpWidget(harness(r));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(r.current.theme, AppThemePreference.dark);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  group('providers', () {
    test('resolvedLocaleProvider maps preferences', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = AppPreferencesRepository(prefs);
      final container = ProviderContainer(
        overrides: [appPreferencesRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      expect(
        container.read(resolvedLocaleProvider),
        isNull, // SYSTEM -> follow platform
      );

      await container
          .read(appPreferencesProvider.notifier)
          .setLanguage(AppLanguagePreference.english);
      expect(container.read(resolvedLocaleProvider), const Locale('en'));

      await container
          .read(appPreferencesProvider.notifier)
          .setLanguage(AppLanguagePreference.arabic);
      expect(container.read(resolvedLocaleProvider), const Locale('ar'));
    });
  });
}
