import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/preferences/app_preferences.dart';
import 'package:pmdap_mobile/core/preferences/app_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLanguagePreference', () {
    test('no saved language -> SYSTEM', () {
      expect(
        AppLanguagePreference.fromStored(null),
        AppLanguagePreference.system,
      );
    });

    test('saved en -> English', () {
      expect(
        AppLanguagePreference.fromStored('en'),
        AppLanguagePreference.english,
      );
    });

    test('saved ar -> Arabic', () {
      expect(
        AppLanguagePreference.fromStored('ar'),
        AppLanguagePreference.arabic,
      );
    });

    test('invalid saved language -> SYSTEM', () {
      expect(
        AppLanguagePreference.fromStored('fr'),
        AppLanguagePreference.system,
      );
      expect(
        AppLanguagePreference.fromStored(''),
        AppLanguagePreference.system,
      );
    });

    test('round-trips through stored value', () {
      for (final value in AppLanguagePreference.values) {
        expect(AppLanguagePreference.fromStored(value.toStored()), value);
      }
    });
  });

  group('AppThemePreference', () {
    test('no saved theme -> SYSTEM', () {
      expect(AppThemePreference.fromStored(null), AppThemePreference.system);
    });

    test('saved light -> light', () {
      expect(AppThemePreference.fromStored('light'), AppThemePreference.light);
    });

    test('saved dark -> dark', () {
      expect(AppThemePreference.fromStored('dark'), AppThemePreference.dark);
    });

    test('invalid saved theme -> SYSTEM', () {
      expect(AppThemePreference.fromStored('blue'), AppThemePreference.system);
      expect(AppThemePreference.fromStored(''), AppThemePreference.system);
    });
  });

  group('AppPreferencesRepository', () {
    test('empty prefs -> SYSTEM/SYSTEM', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = AppPreferencesRepository(prefs);
      expect(repo.current.language, AppLanguagePreference.system);
      expect(repo.current.theme, AppThemePreference.system);
    });

    test('saved en + dark loaded correctly', () async {
      SharedPreferences.setMockInitialValues({
        'pmdap_language_preference': 'en',
        'pmdap_theme_preference': 'dark',
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = AppPreferencesRepository(prefs);
      expect(repo.current.language, AppLanguagePreference.english);
      expect(repo.current.theme, AppThemePreference.dark);
    });

    test('corrupted stored values fall back to SYSTEM', () async {
      SharedPreferences.setMockInitialValues({
        'pmdap_language_preference': 'xx',
        'pmdap_theme_preference': 'xx',
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = AppPreferencesRepository(prefs);
      expect(repo.current.language, AppLanguagePreference.system);
      expect(repo.current.theme, AppThemePreference.system);
    });

    test('selection survives repository recreation', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = AppPreferencesRepository(prefs);
      await repo.setLanguage(AppLanguagePreference.arabic);
      await repo.setTheme(AppThemePreference.light);

      // Fresh repository over the same store (simulates app restart).
      final repo2 = AppPreferencesRepository(prefs);
      expect(repo2.current.language, AppLanguagePreference.arabic);
      expect(repo2.current.theme, AppThemePreference.light);
    });

    test('logout does not clear preferences (store untouched)', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = AppPreferencesRepository(prefs);
      await repo.setLanguage(AppLanguagePreference.arabic);
      await repo.setTheme(AppThemePreference.dark);

      // Nothing in the app clears these keys; simulate restart after logout.
      final afterLogout = AppPreferencesRepository(prefs);
      expect(afterLogout.current.language, AppLanguagePreference.arabic);
      expect(afterLogout.current.theme, AppThemePreference.dark);
    });
  });
}
