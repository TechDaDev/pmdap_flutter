import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/app/router.dart';
import 'package:pmdap_mobile/features/auth/application/session_controller.dart';
import 'package:pmdap_mobile/core/models/user.dart';
import 'package:pmdap_mobile/core/models/enums.dart';

void main() {
  const user = PublicUser(
    uuid: 'u1',
    email: 'p@example.com',
    role: Role.patient,
  );

  group('authRedirect', () {
    test('unknown state allows only splash', () {
      expect(authRedirect(const AuthUnknown(), Routes.splash), isNull);
      expect(authRedirect(const AuthUnknown(), Routes.home), Routes.splash);
      expect(authRedirect(const AuthUnknown(), Routes.login), Routes.splash);
    });

    test('unauthenticated allows login/register/password reset', () {
      expect(authRedirect(const AuthUnauthenticated(), Routes.login), isNull);
      expect(
        authRedirect(const AuthUnauthenticated(), Routes.register),
        isNull,
      );
      expect(
        authRedirect(const AuthUnauthenticated(), Routes.passwordReset),
        isNull,
      );
      expect(
        authRedirect(const AuthUnauthenticated(), Routes.home),
        Routes.login,
      );
      expect(
        authRedirect(const AuthUnauthenticated(), Routes.archive),
        Routes.login,
      );
    });

    test('unauthenticated allows public claim and activation routes', () {
      expect(authRedirect(const AuthUnauthenticated(), Routes.claims), isNull);
      expect(
        authRedirect(const AuthUnauthenticated(), Routes.accountActivation),
        isNull,
      );
    });

    test('unauthenticated redirects protected routes to login', () {
      expect(
        authRedirect(const AuthUnauthenticated(), Routes.profile),
        Routes.login,
      );
      expect(
        authRedirect(const AuthUnauthenticated(), Routes.minors),
        Routes.login,
      );
    });

    test('authenticated blocks splash/login/register/password reset', () {
      expect(authRedirect(const AuthAuthenticated(user), Routes.home), isNull);
      expect(
        authRedirect(const AuthAuthenticated(user), Routes.splash),
        Routes.home,
      );
      expect(
        authRedirect(const AuthAuthenticated(user), Routes.login),
        Routes.home,
      );
      expect(
        authRedirect(const AuthAuthenticated(user), Routes.register),
        Routes.home,
      );
      expect(
        authRedirect(const AuthAuthenticated(user), Routes.passwordReset),
        Routes.home,
      );
    });

    test('authenticated allows protected secondary routes', () {
      expect(
        authRedirect(const AuthAuthenticated(user), Routes.identity),
        isNull,
      );
      expect(
        authRedirect(const AuthAuthenticated(user), Routes.documents),
        isNull,
      );
      expect(
        authRedirect(const AuthAuthenticated(user), '/documents/uuid'),
        isNull,
      );
    });
  });
}
