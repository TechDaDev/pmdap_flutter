import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/features/auth/presentation/login_screen.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/token_pair.dart';
import 'package:pmdap_mobile/core/models/user.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/features/auth/data/auth_api.dart';
import 'package:pmdap_mobile/core/api/api_exception.dart';
import 'package:dio/dio.dart';

import '../helpers/pump.dart';
import 'package:pmdap_mobile/core/storage/refresh_token_storage.dart';

class _FakeStorage implements RefreshTokenStorage {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String token) async => value = token;
  @override
  Future<void> clear() async => value = null;
}

class _FakeAuthApi extends AuthApi {
  _FakeAuthApi() : super(Dio());

  bool fail = false;
  String? failCode;
  int loginCalls = 0;

  @override
  Future<TokenPair> login({
    required String email,
    required String password,
  }) async {
    loginCalls++;
    if (fail) {
      throw ApiException(
        statusCode: 401,
        code: failCode ?? 'invalid_credentials',
        message: failCode == 'account_unavailable'
            ? 'Account unavailable.'
            : 'Invalid credentials.',
      );
    }
    return const TokenPair(access: 'access', refresh: 'refresh');
  }

  @override
  Future<PublicUser> me() async =>
      const PublicUser(uuid: 'u1', email: 'p@example.com', role: Role.patient);
}

Future<void> _submit(WidgetTester tester) async {
  await tester.enterText(
    find.byType(TextFormField).first,
    'patient@example.com',
  );
  await tester.enterText(find.byType(TextFormField).last, 'secret123');
  await tester.ensureVisible(find.widgetWithText(FilledButton, 'Sign in'));
  await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  testWidgets('login does not overflow on a small phone at 150% text scale', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    await tester.pumpWidget(pumpApp(const LoginScreen()));

    expect(tester.takeException(), isNull);
  });

  testWidgets('login renders title and fields', (tester) async {
    await tester.pumpWidget(pumpApp(const LoginScreen()));
    expect(find.text('Sign in'), findsWidgets);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });

  testWidgets('valid credentials call login without error', (tester) async {
    final api = _FakeAuthApi();
    await tester.pumpWidget(
      pumpApp(
        const LoginScreen(),
        overrides: [
          authApiProvider.overrideWithValue(api),
          refreshTokenStorageProvider.overrideWithValue(_FakeStorage()),
        ],
      ),
    );
    await _submit(tester);
    expect(api.loginCalls, 1);
    expect(find.text('Could not sign in.'), findsNothing);
  });

  testWidgets('invalid credentials show safe message', (tester) async {
    final api = _FakeAuthApi()..fail = true;
    await tester.pumpWidget(
      pumpApp(
        const LoginScreen(),
        overrides: [
          authApiProvider.overrideWithValue(api),
          refreshTokenStorageProvider.overrideWithValue(_FakeStorage()),
        ],
      ),
    );
    await _submit(tester);
    expect(find.text('Incorrect email or password.'), findsOneWidget);
  });

  testWidgets('unavailable account shows its message', (tester) async {
    final api = _FakeAuthApi()
      ..fail = true
      ..failCode = 'account_unavailable';
    await tester.pumpWidget(
      pumpApp(
        const LoginScreen(),
        overrides: [
          authApiProvider.overrideWithValue(api),
          refreshTokenStorageProvider.overrideWithValue(_FakeStorage()),
        ],
      ),
    );
    await _submit(tester);
    expect(
      find.text(
        'This account is not available. Contact support if this is unexpected.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('validation requires both fields', (tester) async {
    await tester.pumpWidget(pumpApp(const LoginScreen()));
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Please check the highlighted fields.'), findsNWidgets(2));
  });
}
