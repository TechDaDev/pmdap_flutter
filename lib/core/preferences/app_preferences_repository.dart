import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences.dart';

/// Persists local UI preferences (language + theme) in SharedPreferences.
///
/// Loaded once during bootstrap so the app never flashes the wrong
/// locale/theme. Unknown or corrupted stored values fall back to SYSTEM.
class AppPreferencesRepository {
  AppPreferencesRepository(this._prefs) : _current = _read(_prefs);

  static const _languageKey = 'pmdap_language_preference';
  static const _themeKey = 'pmdap_theme_preference';

  final SharedPreferences _prefs;
  AppPreferences _current;

  /// In-memory snapshot loaded at construction (bootstrap time).
  AppPreferences get current => _current;

  static AppPreferences _read(SharedPreferences prefs) {
    return AppPreferences(
      language: AppLanguagePreference.fromStored(prefs.getString(_languageKey)),
      theme: AppThemePreference.fromStored(prefs.getString(_themeKey)),
    );
  }

  Future<void> setLanguage(AppLanguagePreference value) async {
    _current = _current.copyWith(language: value);
    await _prefs.setString(_languageKey, value.toStored());
  }

  Future<void> setTheme(AppThemePreference value) async {
    _current = _current.copyWith(theme: value);
    await _prefs.setString(_themeKey, value.toStored());
  }
}
