/// Local appearance/language preferences. Never sent to the backend.
library;

import 'package:flutter/foundation.dart';

/// Language preference: follow the device, or force a language.
enum AppLanguagePreference {
  system,
  english,
  arabic;

  static AppLanguagePreference fromStored(String? value) {
    return switch (value) {
      'en' => AppLanguagePreference.english,
      'ar' => AppLanguagePreference.arabic,
      _ => AppLanguagePreference.system,
    };
  }

  String toStored() => switch (this) {
    AppLanguagePreference.system => 'system',
    AppLanguagePreference.english => 'en',
    AppLanguagePreference.arabic => 'ar',
  };
}

/// Appearance preference: follow the device, or force light/dark.
enum AppThemePreference {
  system,
  light,
  dark;

  static AppThemePreference fromStored(String? value) {
    return switch (value) {
      'light' => AppThemePreference.light,
      'dark' => AppThemePreference.dark,
      _ => AppThemePreference.system,
    };
  }

  String toStored() => switch (this) {
    AppThemePreference.system => 'system',
    AppThemePreference.light => 'light',
    AppThemePreference.dark => 'dark',
  };
}

/// Immutable snapshot of the user's local UI preferences.
@immutable
class AppPreferences {
  const AppPreferences({
    this.language = AppLanguagePreference.system,
    this.theme = AppThemePreference.system,
  });

  final AppLanguagePreference language;
  final AppThemePreference theme;

  AppPreferences copyWith({
    AppLanguagePreference? language,
    AppThemePreference? theme,
  }) {
    return AppPreferences(
      language: language ?? this.language,
      theme: theme ?? this.theme,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppPreferences &&
      other.language == language &&
      other.theme == theme;

  @override
  int get hashCode => Object.hash(language, theme);
}
