import 'package:flutter/foundation.dart';

/// Environment-driven application configuration.
///
/// Base URL injected at build/run time via:
///   --dart-define=PMDAP_API_BASE_URL=https://pmdapbackend.up.railway.app/api/v1
///   --dart-define=PMDAP_API_BASE_URL=http://<LAN-IP>:8000/api/v1
///
/// Default (no override) is the deployed Railway backend. Never scatter IPs
/// through source code — always read from this object.
class AppConfig {
  AppConfig._();

  /// Deployed backend used when no `--dart-define` override is provided.
  static const String onlineApiBaseUrl =
      'https://pmdapbackend.up.railway.app/api/v1';

  static const String _apiBaseUrlOverride = String.fromEnvironment(
    'PMDAP_API_BASE_URL',
  );

  static const String env = String.fromEnvironment(
    'PMDAP_ENV',
    defaultValue: 'debug',
  );

  /// Git short SHA baked in via `--dart-define=PMDAP_BUILD_SHA=...`.
  /// Debug-only identifier proving which code a build runs. Empty in builds
  /// created without the define (or in production builds that omit it).
  static const String buildSha = String.fromEnvironment('PMDAP_BUILD_SHA');

  /// API base URL with any trailing slash normalized away so path joins never
  /// produce a double slash (`/api/v1//auth/login/`).
  static String get apiBaseUrl => _normalize(
    _apiBaseUrlOverride.isNotEmpty ? _apiBaseUrlOverride : onlineApiBaseUrl,
  );

  static String _normalize(String value) {
    final trimmed = value.trim();
    return trimmed.endsWith('/')
        ? trimmed.substring(0, trimmed.length - 1)
        : trimmed;
  }

  /// True when pointing at the deployed Railway backend.
  static bool get isOnline => apiBaseUrl == onlineApiBaseUrl;

  static String get apiHost => Uri.parse(apiBaseUrl).host;

  static bool get isDebug => env == 'debug' || kDebugMode;

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 60);

  /// Identity document uploads carry large front/back images over the
  /// multipart body. A tiny send timeout would abort legitimate slow-upload
  /// sessions, so these use a longer, still-finite window. Deliberately
  /// separated from [sendTimeout]/[receiveTimeout] so transport timeouts are
  /// not conflated with upload throughput.
  static const Duration uploadSendTimeout = Duration(seconds: 120);
  static const Duration uploadReceiveTimeout = Duration(seconds: 90);
}
