import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/api/api_exception.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/features/auth/data/password_reset_api.dart';
import 'package:pmdap_mobile/features/auth/presentation/password_reset_screen.dart';

import '../helpers/pump.dart';

class _FakePasswordResetApi extends PasswordResetApi {
  _FakePasswordResetApi() : super(Dio());

  int requestCalls = 0;
  int verifyCalls = 0;
  int confirmCalls = 0;
  ApiException? nextError;
  String? lastEmail;
  String? lastCode;
  String? lastToken;
  String? lastPassword;

  void _maybeThrow() {
    final error = nextError;
    nextError = null;
    if (error != null) throw error;
  }

  @override
  Future<int> request({required String email}) async {
    requestCalls++;
    lastEmail = email;
    _maybeThrow();
    return 0;
  }

  @override
  Future<PasswordResetVerification> verify({
    required String email,
    required String code,
  }) async {
    verifyCalls++;
    lastEmail = email;
    lastCode = code;
    _maybeThrow();
    return PasswordResetVerification(
      token: 'opaque-reset-capability',
      expiresAt: DateTime.now().add(const Duration(minutes: 5)),
    );
  }

  @override
  Future<void> confirm({
    required String resetToken,
    required String newPassword,
  }) async {
    confirmCalls++;
    lastToken = resetToken;
    lastPassword = newPassword;
    _maybeThrow();
  }
}

Future<void> _pump(
  WidgetTester tester,
  _FakePasswordResetApi api, {
  Locale? locale,
  ThemeMode themeMode = ThemeMode.light,
}) => tester.pumpWidget(
  pumpApp(
    const PasswordResetScreen(),
    overrides: [passwordResetApiProvider.overrideWithValue(api)],
    locale: locale,
    themeMode: themeMode,
  ),
);

Future<void> _request(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField), 'owner@example.com');
  await tester.tap(find.widgetWithText(FilledButton, 'Send code'));
  await tester.pumpAndSettle();
}

Future<void> _verify(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField), '123456');
  await tester.tap(find.widgetWithText(FilledButton, 'Verify code'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('request, verify, set password, success flow', (tester) async {
    final api = _FakePasswordResetApi();
    await _pump(tester, api);

    expect(find.text('Reset password'), findsWidgets);
    await _request(tester);
    expect(api.lastEmail, 'owner@example.com');
    expect(find.text('Check your email'), findsOneWidget);

    await _verify(tester);
    expect(api.lastCode, '123456');
    expect(find.text('Choose a new password'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Fresh-Correct-Horse-84!');
    await tester.enterText(fields.at(1), 'Fresh-Correct-Horse-84!');
    await tester.tap(find.widgetWithText(FilledButton, 'Reset password'));
    await tester.pumpAndSettle();

    expect(api.lastToken, 'opaque-reset-capability');
    expect(api.lastPassword, 'Fresh-Correct-Horse-84!');
    expect(find.text('Password reset complete'), findsOneWidget);
    expect(find.text('Back to sign in'), findsOneWidget);
  });

  testWidgets('invalid OTP remains retryable and resend works', (tester) async {
    final api = _FakePasswordResetApi();
    await _pump(tester, api);
    await _request(tester);
    api.nextError = const ApiException(
      statusCode: 400,
      code: 'password_reset_otp_invalid',
      message: 'unsafe backend text',
    );

    await _verify(tester);

    expect(find.text('Code is invalid, expired, or locked.'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Resend code'));
    await tester.pumpAndSettle();
    expect(api.requestCalls, 2);
  });

  testWidgets('expired capability and network errors remain retryable', (
    tester,
  ) async {
    final api = _FakePasswordResetApi();
    await _pump(tester, api);
    await _request(tester);
    await _verify(tester);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Fresh-Correct-Horse-84!');
    await tester.enterText(fields.at(1), 'Fresh-Correct-Horse-84!');
    api.nextError = const ApiException(
      statusCode: 400,
      code: 'password_reset_capability_invalid',
      message: 'unsafe backend text',
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Reset password'));
    await tester.pumpAndSettle();
    expect(
      find.text('Reset session expired. Request a new code.'),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(TextButton, 'Start over'));
    await tester.pumpAndSettle();
    api.nextError = const ApiException.network();
    await _request(tester);
    expect(
      find.text('Network error. Check connection and retry.'),
      findsOneWidget,
    );
    expect(find.widgetWithText(FilledButton, 'Send code'), findsOneWidget);
  });

  testWidgets('password confirmation mismatch stays client-side', (
    tester,
  ) async {
    final api = _FakePasswordResetApi();
    await _pump(tester, api);
    await _request(tester);
    await _verify(tester);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Fresh-Correct-Horse-84!');
    await tester.enterText(fields.at(1), 'different');

    await tester.tap(find.widgetWithText(FilledButton, 'Reset password'));
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match.'), findsOneWidget);
    expect(api.confirmCalls, 0);
  });

  testWidgets('Arabic is RTL and translated', (tester) async {
    final api = _FakePasswordResetApi();
    await _pump(tester, api, locale: const Locale('ar'));

    expect(find.text('إعادة تعيين كلمة المرور'), findsWidgets);
    expect(
      Directionality.of(tester.element(find.byType(Scaffold))),
      TextDirection.rtl,
    );
  });

  for (final themeMode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('no overflow on small phone in ${themeMode.name}', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      });
      await _pump(tester, _FakePasswordResetApi(), themeMode: themeMode);
      expect(tester.takeException(), isNull);
    });
  }
}
