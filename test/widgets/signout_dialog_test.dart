import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/user.dart';
import 'package:pmdap_mobile/features/auth/application/session_controller.dart';
import 'package:pmdap_mobile/features/patient/application/patient_providers.dart';
import 'package:pmdap_mobile/features/patient/presentation/profile_screen.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../helpers/fixtures.dart';

class _FakeSession extends SessionController {
  int logoutCalls = 0;
  @override
  AuthState build() => const AuthAuthenticated(
    PublicUser(uuid: 'u1', email: 'x@example.com', role: Role.patient),
  );
  @override
  Future<void> logout() async {
    logoutCalls++;
    state = const AuthUnauthenticated();
  }
}

void main() {
  Future<_FakeSession> pumpProfile(WidgetTester tester) async {
    final session = _FakeSession();
    final router = GoRouter(
      initialLocation: '/profile',
      routes: [
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('login-screen'))),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          patientProfileProvider.overrideWith(
            (ref) async => sampleProfile(status: IdentityStatus.verified),
          ),
          sessionControllerProvider.overrideWith(() => session),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return session;
  }

  testWidgets('sign out dialog opens with compact destructive layout', (
    tester,
  ) async {
    await pumpProfile(tester);
    await tester.tap(find.byIcon(Icons.logout).first);
    await tester.pumpAndSettle();

    expect(find.text('Sign out'), findsWidgets);
    expect(find.text('Sign out of PMDAP?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    // Destructive button uses error color, not the primary CTA tone.
    final signOut = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Sign out'),
    );
    final scheme = Theme.of(
      tester.element(find.byType(ProfileScreen)),
    ).colorScheme;
    expect(signOut.style?.backgroundColor?.resolve({}), scheme.error);
  });

  testWidgets('cancel dismisses without logging out', (tester) async {
    final session = await pumpProfile(tester);
    await tester.tap(find.byIcon(Icons.logout).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(session.logoutCalls, 0);
    expect(find.text('Sign out of PMDAP?'), findsNothing);
  });

  testWidgets('sign out calls logout once and routes to login', (tester) async {
    final session = await pumpProfile(tester);
    await tester.tap(find.byIcon(Icons.logout).first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
    await tester.pumpAndSettle();

    expect(session.logoutCalls, 1);
    expect(find.text('login-screen'), findsOneWidget);
  });

  testWidgets('logout failure keeps user signed in', (tester) async {
    final session = _FailingSession();
    final router = GoRouter(
      initialLocation: '/profile',
      routes: [
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('login-screen'))),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          patientProfileProvider.overrideWith(
            (ref) async => sampleProfile(status: IdentityStatus.verified),
          ),
          sessionControllerProvider.overrideWith(() => session),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.logout).first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
    await tester.pumpAndSettle();

    // Still on profile (no login), error snackbar shown.
    expect(find.text('login-screen'), findsNothing);
    expect(
      find.text('Something went wrong. Please try again.'),
      findsOneWidget,
    );
    expect(session.logoutCalls, 1);
  });
}

class _FailingSession extends _FakeSession {
  @override
  Future<void> logout() async {
    logoutCalls++;
    throw Exception('backend down');
  }
}
