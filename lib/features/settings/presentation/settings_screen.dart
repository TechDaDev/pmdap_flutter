import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../../core/preferences/app_preferences.dart';
import '../../../core/preferences/app_preferences_controller.dart';
import '../../../core/theme/app_theme.dart';

/// App settings — local language + appearance overrides.
///
/// Preferences are device-local, persist across restart/logout, and are never
/// sent to the backend.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prefs = ref.watch(appPreferencesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appSettings)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _SettingRow(
            icon: Icons.language_rounded,
            title: l10n.language,
            value: _languageLabel(l10n, prefs.language),
            onTap: () => _pickLanguage(context, ref),
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingRow(
            icon: Icons.brightness_6_rounded,
            title: l10n.appearance,
            value: _themeLabel(l10n, prefs.theme),
            onTap: () => _pickTheme(context, ref),
          ),
        ],
      ),
    );
  }

  String _languageLabel(AppLocalizations l10n, AppLanguagePreference p) =>
      switch (p) {
        AppLanguagePreference.system => l10n.systemDefault,
        AppLanguagePreference.english => l10n.english,
        AppLanguagePreference.arabic => l10n.arabic,
      };

  String _themeLabel(AppLocalizations l10n, AppThemePreference p) =>
      switch (p) {
        AppThemePreference.system => l10n.systemDefault,
        AppThemePreference.light => l10n.light,
        AppThemePreference.dark => l10n.dark,
      };

  Future<void> _pickLanguage(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final prefs = ref.read(appPreferencesProvider);
    final selected = await showModalBottomSheet<AppLanguagePreference>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: _OptionSheet<AppLanguagePreference>(
          title: l10n.language,
          current: prefs.language,
          options: const [
            AppLanguagePreference.system,
            AppLanguagePreference.english,
            AppLanguagePreference.arabic,
          ],
          label: (value) => switch (value) {
            AppLanguagePreference.system => l10n.systemDefault,
            AppLanguagePreference.english => l10n.english,
            AppLanguagePreference.arabic => l10n.arabic,
          },
        ),
      ),
    );
    if (selected == null || selected == prefs.language) return;
    await ref.read(appPreferencesProvider.notifier).setLanguage(selected);
  }

  Future<void> _pickTheme(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final prefs = ref.read(appPreferencesProvider);
    final selected = await showModalBottomSheet<AppThemePreference>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: _OptionSheet<AppThemePreference>(
          title: l10n.appearance,
          current: prefs.theme,
          options: const [
            AppThemePreference.system,
            AppThemePreference.light,
            AppThemePreference.dark,
          ],
          label: (value) => switch (value) {
            AppThemePreference.system => l10n.useDeviceSettings,
            AppThemePreference.light => l10n.light,
            AppThemePreference.dark => l10n.dark,
          },
        ),
      ),
    );
    if (selected == null || selected == prefs.theme) return;
    await ref.read(appPreferencesProvider.notifier).setTheme(selected);
  }
}

/// Tappable settings row with icon, title and current value.
class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primaryBlue),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

/// Modal radio list. Selection applies immediately (parent persists it).
class _OptionSheet<T> extends StatelessWidget {
  const _OptionSheet({
    required this.title,
    required this.current,
    required this.options,
    required this.label,
  });

  final String title;
  final T current;
  final List<T> options;
  final String Function(T) label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(height: 8),
          RadioGroup<T>(
            groupValue: current,
            onChanged: (value) {
              if (value != null) Navigator.of(context).pop(value);
            },
            child: Column(
              children: [
                for (final value in options)
                  RadioListTile<T>(
                    value: value,
                    title: Text(label(value)),
                    // Ensure the sheet fits even at large text scale.
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
