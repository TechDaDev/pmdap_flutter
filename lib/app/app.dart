import 'package:flutter/material.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import '../core/preferences/app_preferences_controller.dart';
import '../core/theme/app_theme.dart';

/// Root widget. Locale + theme follow the device by default (SYSTEM) but can
/// be overridden locally from App settings. Switching updates the whole app
/// immediately — no restart, no logout.
class PmdapApp extends ConsumerWidget {
  const PmdapApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(resolvedLocaleProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'PMDAP',
      debugShowCheckedModeBanner: false,
      locale: locale,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
