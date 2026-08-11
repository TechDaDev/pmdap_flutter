import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_preferences.dart';
import 'app_preferences_repository.dart';

/// Repository instance. Injected at bootstrap with pre-loaded SharedPreferences
/// so locale/theme are known before the first frame renders.
final appPreferencesRepositoryProvider = Provider<AppPreferencesRepository>(
  (ref) => throw UnimplementedError(
    'appPreferencesRepositoryProvider must be overridden in bootstrap',
  ),
);

/// Current local UI preferences (language + theme).
final appPreferencesProvider =
    NotifierProvider<AppPreferencesNotifier, AppPreferences>(
      AppPreferencesNotifier.new,
    );

class AppPreferencesNotifier extends Notifier<AppPreferences> {
  @override
  AppPreferences build() {
    return ref.watch(appPreferencesRepositoryProvider).current;
  }

  Future<void> setLanguage(AppLanguagePreference value) async {
    final repo = ref.read(appPreferencesRepositoryProvider);
    await repo.setLanguage(value);
    state = repo.current;
  }

  Future<void> setTheme(AppThemePreference value) async {
    final repo = ref.read(appPreferencesRepositoryProvider);
    await repo.setTheme(value);
    state = repo.current;
  }
}

/// Resolved app locale. `null` (SYSTEM) lets Flutter follow the platform locale.
final resolvedLocaleProvider = Provider<Locale?>((ref) {
  final language = ref.watch(appPreferencesProvider.select((p) => p.language));
  return switch (language) {
    AppLanguagePreference.english => const Locale('en'),
    AppLanguagePreference.arabic => const Locale('ar'),
    AppLanguagePreference.system => null,
  };
});

/// Resolved [ThemeMode] mapped from the appearance preference.
final themeModeProvider = Provider<ThemeMode>((ref) {
  final theme = ref.watch(appPreferencesProvider.select((p) => p.theme));
  return switch (theme) {
    AppThemePreference.system => ThemeMode.system,
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
  };
});
