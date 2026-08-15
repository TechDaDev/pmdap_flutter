import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import '../core/config/app_config.dart';
import '../core/preferences/app_preferences_controller.dart';
import '../core/preferences/app_preferences_repository.dart';

/// App entry point.
///
/// Preferences load before the first frame so the app never flashes the
/// wrong locale or theme at startup.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    debugPrint(
      'pmdap_build sha=${AppConfig.buildSha.isEmpty ? 'unknown' : AppConfig.buildSha}',
    );
  }
  final prefs = await SharedPreferences.getInstance();
  final repository = AppPreferencesRepository(prefs);
  runApp(
    ProviderScope(
      overrides: [
        appPreferencesRepositoryProvider.overrideWithValue(repository),
      ],
      child: const PmdapApp(),
    ),
  );
}
