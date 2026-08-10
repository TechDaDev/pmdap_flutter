import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('default base URL is localhost (desktop/testing only)', () {
      // No --dart-define in tests → fallback localhost.
      expect(AppConfig.apiBaseUrl, 'http://localhost:8000/api/v1');
    });

    test('does not end with trailing slash', () {
      expect(AppConfig.apiBaseUrl.endsWith('/'), isFalse);
    });

    test('default env is debug', () {
      expect(AppConfig.env, 'debug');
      expect(AppConfig.isDebug, isTrue);
    });

    test('timeouts are configured', () {
      expect(AppConfig.connectTimeout, isNotNull);
      expect(AppConfig.receiveTimeout, isNotNull);
      expect(AppConfig.sendTimeout, isNotNull);
    });
  });
}
