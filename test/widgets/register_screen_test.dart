import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/user.dart';
import 'package:pmdap_mobile/features/auth/data/auth_api.dart';
import 'package:pmdap_mobile/features/auth/presentation/register_screen.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

class _FakeAuthApi extends AuthApi {
  _FakeAuthApi() : super(Dio());

  int registerCalls = 0;

  @override
  Future<PublicUser> register({
    required String email,
    String? phone,
    required String password,
    required PatientRegistrationInput patient,
  }) async {
    registerCalls++;
    return const PublicUser(
      uuid: 'u1',
      email: 'x@example.com',
      role: Role.patient,
    );
  }
}

Future<void> _pump(
  WidgetTester tester, {
  List<Override> overrides = const [],
}) async {
  final router = GoRouter(
    initialLocation: '/register',
    routes: [
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
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
      overrides: overrides,
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
}

Future<void> _fillAndSubmit(WidgetTester tester) async {
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Full name'),
    'Test User',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Email'),
    'test@example.com',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Password'),
    'secret123',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Nationality'),
    'IQ',
  );
  // Adult DOB is required before submission (backend: adult account).
  await tester.ensureVisible(
    find.widgetWithText(TextFormField, 'Date of birth'),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(TextFormField, 'Date of birth'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
  await tester.ensureVisible(
    find.widgetWithText(FilledButton, 'Create account'),
  );
  await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  testWidgets('register renders the form', (tester) async {
    await _pump(tester);
    expect(find.text('Create account'), findsWidgets);
    expect(find.widgetWithText(TextFormField, 'Full name'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
  });

  testWidgets('registration calls backend and shows success', (tester) async {
    final api = _FakeAuthApi();
    await _pump(tester, overrides: [authApiProvider.overrideWithValue(api)]);
    await _fillAndSubmit(tester);
    expect(api.registerCalls, 1);
    expect(find.text('Account created. Please sign in.'), findsOneWidget);
  });
}
