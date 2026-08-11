import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('default base URL is the deployed Railway backend', () {
      // No --dart-define in tests → deployed backend is the default target.
      expect(
        AppConfig.apiBaseUrl,
        'https://pmdapbackend.up.railway.app/api/v1',
      );
    });

    test('default base URL has no trailing slash (safe path joins)', () {
      expect(AppConfig.apiBaseUrl.endsWith('/'), isFalse);
    });

    test('path join never produces a double slash', () {
      // baseUrl (no trailing slash) + leading-slash path → single slash.
      final joined = '${AppConfig.apiBaseUrl}/auth/login/';
      expect(joined, isNot(contains('//auth/login/')));
      expect(joined, 'https://pmdapbackend.up.railway.app/api/v1/auth/login/');
    });

    test('default points at online environment', () {
      expect(AppConfig.isOnline, isTrue);
    });

    test('apiHost extracts the host without protocol or path', () {
      expect(AppConfig.apiHost, 'pmdapbackend.up.railway.app');
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
