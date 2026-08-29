import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/api/api_exception.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/token_pair.dart';
import 'package:pmdap_mobile/features/auth/application/session_controller.dart';
import 'package:pmdap_mobile/features/auth/data/password_change_api.dart';
import 'package:pmdap_mobile/features/auth/presentation/password_change_screen.dart';

import '../helpers/pump.dart';

class _FakePasswordChangeApi extends PasswordChangeApi {
  _FakePasswordChangeApi() : super(Dio());

  int requestCalls = 0;
  int verifyCalls = 0;
  int confirmCalls = 0;
  ApiException? nextError;
  String? lastCurrentPassword;
  String? lastCode;
  String? lastCapability;
  String? lastNewPassword;

  void _maybeThrow() {
    final error = nextError;
    nextError = null;
    if (error != null) throw error;
  }

  @override
  Future<int> request({required String currentPassword}) async {
    requestCalls++;
    lastCurrentPassword = currentPassword;
    _maybeThrow();
    return 0;
  }

  @override
  Future<PasswordChangeVerification> verify({required String code}) async {
    verifyCalls++;
    lastCode = code;
    _maybeThrow();
    return PasswordChangeVerification(
      capability: 'opaque-change-capability',
      expiresAt: DateTime.now().add(const Duration(minutes: 5)),
    );
  }

  @override
  Future<TokenPair> confirm({
    required String capability,
    required String newPassword,
  }) async {
    confirmCalls++;
    lastCapability = capability;
    lastNewPassword = newPassword;
    _maybeThrow();
    return const TokenPair(access: 'fresh-access', refresh: 'fresh-refresh');
  }
}

class _FakeSessionController extends SessionController {
  int applyFreshSessionCalls = 0;
  TokenPair? appliedPair;

  @override
  Future<void> applyFreshSession(TokenPair pair) async {
    applyFreshSessionCalls++;
    appliedPair = pair;
  }
}

Future<_FakeSessionController> _pump(
  WidgetTester tester,
  _FakePasswordChangeApi api, {
  Locale? locale,
  ThemeMode themeMode = ThemeMode.light,
}) async {
  final session = _FakeSessionController();
  await tester.pumpWidget(
    pumpApp(
      const PasswordChangeScreen(),
      overrides: [
        passwordChangeApiProvider.overrideWithValue(api),
        sessionControllerProvider.overrideWith(() => session),
      ],
      locale: locale,
      themeMode: themeMode,
    ),
  );
  return session;
}

Future<void> _enterCurrentPassword(WidgetTester tester, String password) async {
  await tester.enterText(find.byType(TextFormField), password);
  await tester.tap(find.widgetWithText(FilledButton, 'Send code'));
  await tester.pumpAndSettle();
}

Future<void> _verifyCode(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField), '123456');
  await tester.tap(find.widgetWithText(FilledButton, 'Verify code'));
  await tester.pumpAndSettle();
}

Future<void> _setNewPassword(WidgetTester tester) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), 'Fresh-Correct-Horse-84!');
  await tester.enterText(fields.at(1), 'Fresh-Correct-Horse-84!');
  await tester.tap(find.widgetWithText(FilledButton, 'Change password'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('current password, code, new password, success flow', (
    tester,
  ) async {
    final api = _FakePasswordChangeApi();
    final session = await _pump(tester, api);

    expect(find.text('Change password'), findsWidgets);
    await _enterCurrentPassword(tester, 'Correct-Horse-42!');
    expect(api.lastCurrentPassword, 'Correct-Horse-42!');
    expect(find.text('Check your email'), findsOneWidget);

    await _verifyCode(tester);
    expect(api.lastCode, '123456');
    expect(find.text('Choose a new password'), findsOneWidget);

    await _setNewPassword(tester);
    expect(api.lastCapability, 'opaque-change-capability');
    expect(api.lastNewPassword, 'Fresh-Correct-Horse-84!');
    expect(session.applyFreshSessionCalls, 1);
    expect(session.appliedPair?.access, 'fresh-access');
    expect(session.appliedPair?.refresh, 'fresh-refresh');
    expect(find.text('Password changed'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
  });

  testWidgets('wrong current password stays retryable', (tester) async {
    final api = _FakePasswordChangeApi();
    await _pump(tester, api);
    api.nextError = const ApiException(
      statusCode: 400,
      code: 'password_change_wrong_current_password',
      message: 'unsafe backend text',
    );

    await _enterCurrentPassword(tester, 'Wrong-Pass-1!');

    expect(find.text('Current password is incorrect.'), findsOneWidget);
    // Still on the current-password step, can retry.
    expect(find.text('Send code'), findsOneWidget);
  });

  testWidgets('invalid OTP remains retryable and resend works', (tester) async {
    final api = _FakePasswordChangeApi();
    await _pump(tester, api);
    await _enterCurrentPassword(tester, 'Correct-Horse-42!');
    api.nextError = const ApiException(
      statusCode: 400,
      code: 'password_change_otp_invalid',
      message: 'unsafe backend text',
    );

    await _verifyCode(tester);

    expect(find.text('Code is invalid, expired, or locked.'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Resend code'));
    await tester.pumpAndSettle();
    expect(api.requestCalls, 2);
  });

  testWidgets('expired capability and network errors remain retryable', (
    tester,
  ) async {
    final api = _FakePasswordChangeApi();
    await _pump(tester, api);
    await _enterCurrentPassword(tester, 'Correct-Horse-42!');
    await _verifyCode(tester);
    api.nextError = const ApiException(
      statusCode: 400,
      code: 'password_change_capability_invalid',
      message: 'unsafe backend text',
    );

    await _setNewPassword(tester);

    expect(
      find.text('Change session expired. Request a new code.'),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(TextButton, 'Start over'));
    await tester.pumpAndSettle();
    api.nextError = const ApiException.network();
    await _enterCurrentPassword(tester, 'Correct-Horse-42!');

    expect(
      find.text(
        'Could not change your password. Check your connection and try again.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('rejects mismatched passwords before calling the API', (
    tester,
  ) async {
    final api = _FakePasswordChangeApi();
    await _pump(tester, api);
    await _enterCurrentPassword(tester, 'Correct-Horse-42!');
    await _verifyCode(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Fresh-Correct-Horse-84!');
    await tester.enterText(fields.at(1), 'Different-Pass-99!');
    await tester.tap(find.widgetWithText(FilledButton, 'Change password'));
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match.'), findsOneWidget);
    expect(api.confirmCalls, 0);
  });

  testWidgets('Arabic UI flows end to end (RTL localizations)', (tester) async {
    final api = _FakePasswordChangeApi();
    await _pump(tester, api, locale: const Locale('ar'));

    expect(find.text('تغيير كلمة المرور'), findsWidgets);
    await tester.enterText(find.byType(TextFormField), 'Correct-Horse-42!');
    await tester.tap(find.widgetWithText(FilledButton, 'إرسال الرمز'));
    await tester.pumpAndSettle();
    expect(find.text('تحقق من بريدك الإلكتروني'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '123456');
    await tester.tap(find.widgetWithText(FilledButton, 'تحقق من الرمز'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Fresh-Correct-Horse-84!');
    await tester.enterText(fields.at(1), 'Fresh-Correct-Horse-84!');
    await tester.tap(find.widgetWithText(FilledButton, 'تغيير كلمة المرور'));
    await tester.pumpAndSettle();

    expect(find.text('تم تغيير كلمة المرور'), findsOneWidget);
    expect(find.text('تم'), findsOneWidget);
  });
}
