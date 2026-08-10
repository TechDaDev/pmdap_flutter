import 'package:flutter/foundation.dart';

/// Environment-driven application configuration.
///
/// Base URL is injected at build/run time via:
///   --dart-define=PMDAP_API_BASE_URL=http://192.168.x.x:8000/api/v1
///
/// Never scatter IPs through source code — always read from this object.
class AppConfig {
  AppConfig._();

  static const String _apiBaseUrlOverride = String.fromEnvironment(
    'PMDAP_API_BASE_URL',
  );

  static const String env = String.fromEnvironment(
    'PMDAP_ENV',
    defaultValue: 'debug',
  );

  /// Default API base. `localhost` is valid only for desktop/testing.
  /// On a physical phone you MUST pass the LAN IP via --dart-define.
  static String get apiBaseUrl {
    if (_apiBaseUrlOverride.isNotEmpty) {
      final value = _apiBaseUrlOverride.trim();
      return value.endsWith('/') ? value.substring(0, value.length - 1) : value;
    }
    return 'http://localhost:8000/api/v1';
  }

  static bool get isDebug => env == 'debug' || kDebugMode;

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 60);
}
