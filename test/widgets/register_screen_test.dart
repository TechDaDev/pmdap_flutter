import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pmdap_mobile/core/api/api_exception.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/user.dart';
import 'package:pmdap_mobile/core/storage/registration_session_storage.dart';
import 'package:pmdap_mobile/core/widgets/app_text_field.dart';
import 'package:pmdap_mobile/features/auth/application/registration_controller.dart';
import 'package:pmdap_mobile/features/auth/data/registration_api.dart';
import 'package:pmdap_mobile/features/auth/data/registration_models.dart';
import 'package:pmdap_mobile/features/auth/presentation/register_screen.dart';
import 'package:pmdap_mobile/features/identity/data/extraction_models.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

/// In-memory fake of the registration-session secure storage.
class _FakeRegistrationSessionStorage implements RegistrationSessionStorage {
  RegistrationSessionRecord? record;

  @override
  Future<RegistrationSessionRecord?> read() async => record;

  @override
  Future<void> write(RegistrationSessionRecord value) async => record = value;

  @override
  Future<void> clear() async => record = null;
}

/// Fake public scan-first Registration API (SYNTHETIC values only).
class _FakeRegistrationApi extends RegistrationApi {
  _FakeRegistrationApi() : super(Dio());

  int extractCount = 0;
  int pollCount = 0;
  int registerCount = 0;
  int startVerifyCount = 0;
  int verifyCount = 0;
  int resendCount = 0;
  ExtractionJobStatus jobStatus = ExtractionJobStatus.success;
  IdentityExtractionResult? extractionResult;
  RegistrationIdentityInput? lastIdentity;
  String? lastEmail;
  String? lastPassword;
  String? lastGovernorate;
  String? lastSessionToken;
  bool failRegister = false;
  ApiException? submitError;
  ApiException? pollError;

  /// When set, `verifyEmail` throws this error (invalid/expired/…).
  ApiException? verifyError;

  /// When set, `startEmailVerification` throws this error (e.g. delivery).
  ApiException? startVerifyError;

  /// Status returned by `getEmailVerificationStatus` (resume).
  RegistrationEmailStatus resumeStatus = const RegistrationEmailStatus(
    sessionId: 's1',
    maskedEmail: 't***m@example.com',
    status: 'PENDING_EMAIL_VERIFICATION',
    emailVerified: false,
  );

  /// When set, start/resend return this cooldown window (countdown test).
  DateTime? resendAt;

  /// Optional per-poll status sequence. When set, poll N returns
  /// [pollSequence][N-1] (clamped to the last entry).
  List<ExtractionJobStatus>? pollSequence;

  @override
  Future<RegistrationEmailSession> startEmailVerification({
    required String email,
    String? phone,
    String? governorate,
  }) async {
    startVerifyCount++;
    if (startVerifyError != null) throw startVerifyError!;
    return RegistrationEmailSession(
      sessionId: 's1',
      sessionToken: 'session-token-1',
      maskedEmail: 't***m@example.com',
      status: 'PENDING_EMAIL_VERIFICATION',
      emailVerified: false,
      resendAt: resendAt,
    );
  }

  @override
  Future<RegistrationEmailStatus> resendEmailVerification({
    required String sessionToken,
  }) async {
    resendCount++;
    return RegistrationEmailStatus(
      sessionId: 's1',
      maskedEmail: 't***m@example.com',
      status: 'PENDING_EMAIL_VERIFICATION',
      emailVerified: false,
      resendAt: resendAt,
    );
  }

  @override
  Future<RegistrationEmailStatus> verifyEmail({
    required String sessionToken,
    required String code,
  }) async {
    if (verifyError != null) throw verifyError!;
    verifyCount++;
    return const RegistrationEmailStatus(
      sessionId: 's1',
      maskedEmail: 't***m@example.com',
      status: 'EMAIL_VERIFIED',
      emailVerified: true,
    );
  }

  @override
  Future<RegistrationEmailStatus> getEmailVerificationStatus({
    required String sessionToken,
  }) async {
    return resumeStatus;
  }

  @override
  Future<RegistrationExtractionJob> startExtraction({
    required String sessionToken,
    required String frontPath,
    String? backPath,
    void Function(int, int)? onSendProgress,
  }) async {
    // NOTE: the API signature has NO password/account fields — credentials
    // are never sent to the extraction endpoint by design.
    lastSessionToken = sessionToken;
    extractCount++;
    onSendProgress?.call(10, 100);
    return const RegistrationExtractionJob(jobId: 'job-1', jobToken: 'token-1');
  }

  @override
  Future<RegistrationExtractionStatus> pollExtraction({
    required String jobId,
    required String jobToken,
  }) async {
    if (pollError != null) throw pollError!;
    pollCount++;
    final sequence = pollSequence;
    final status = sequence != null && sequence.isNotEmpty
        ? sequence[pollCount - 1 < sequence.length
              ? pollCount - 1
              : sequence.length - 1]
        : jobStatus;
    return RegistrationExtractionStatus(
      jobId: jobId,
      status: status,
      result: status == ExtractionJobStatus.success ? extractionResult : null,
    );
  }

  @override
  Future<PublicUser> registerScanFirst({
    required String email,
    String? phone,
    required String password,
    required String governorate,
    required String sessionToken,
    required RegistrationIdentityInput identity,
  }) async {
    if (submitError != null) throw submitError!;
    if (failRegister) throw Exception('network');
    registerCount++;
    lastEmail = email;
    lastPassword = password;
    lastGovernorate = governorate;
    lastSessionToken = sessionToken;
    lastIdentity = identity;
    return const PublicUser(
      uuid: 'u1',
      email: 'x@example.com',
      role: Role.patient,
    );
  }
}

IdentityExtractionResult _successResult() {
  ExtractedIdentityField f(String v) => ExtractedIdentityField(
    value: v,
    confidence: 0.95,
    source: IdentityExtractionSource.frontPrinted,
  );
  return IdentityExtractionResult(
    documentType: IdentityDocumentType.unifiedNationalCard,
    extractorVersion: 'identity-v1',
    mrz: const MrzValidationResult(
      detected: true,
      valid: true,
      checksPassed: true,
    ),
    fields: {
      'name': f('Ali'),
      'father_name': f('Ahmed'),
      'grandfather_name': f('Hassan'),
      'mother_name': f('Fatima'),
      'sex': f('MALE'),
      'blood_group': f('O+'),
      'date_of_birth': f('1990-01-15'),
      'document_number': f('999999999999'),
      'national_card_number': f('999999999999'),
      'family_number': f('TESTFAMILY123456'),
      'unique_card_body_number': f('H12345678'),
      'issuing_country': f('IQ'),
    },
    warnings: const [],
  );
}

IdentityExtractionResult _resultWith({
  String? name,
  String? fatherName,
  String? grandfatherName,
  String? motherName,
  String? sex,
  String? dateOfBirth,
  String? bloodGroup,
  String? documentNumber,
  String? nationalCardNumber,
  String? familyNumber,
  String? uniqueCardBodyNumber,
  bool removeDocumentNumber = false,
}) {
  ExtractedIdentityField f(String v) => ExtractedIdentityField(
    value: v,
    confidence: 0.95,
    source: IdentityExtractionSource.frontPrinted,
  );
  final base = _successResult();
  final fields = Map<String, ExtractedIdentityField>.of(base.fields);
  void apply(String k, String? v) {
    if (v != null) fields[k] = f(v);
  }

  apply('name', name);
  apply('father_name', fatherName);
  apply('grandfather_name', grandfatherName);
  apply('mother_name', motherName);
  apply('sex', sex);
  apply('date_of_birth', dateOfBirth);
  apply('blood_group', bloodGroup);
  apply('document_number', documentNumber);
  apply('national_card_number', nationalCardNumber);
  apply('family_number', familyNumber);
  apply('unique_card_body_number', uniqueCardBodyNumber);
  if (removeDocumentNumber) fields.remove('document_number');
  return IdentityExtractionResult(
    documentType: base.documentType,
    extractorVersion: base.extractorVersion,
    mrz: base.mrz,
    fields: fields,
    warnings: const [],
  );
}

Future<void> _pump(
  WidgetTester tester, {
  _FakeRegistrationApi? api,
  List<Override> overrides = const [],
  _FakeRegistrationSessionStorage? storage,
  Locale? locale,
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
      overrides: [
        // Always use the fake API (no real network in widget tests); callers
        // can still override the same provider (later entries win).
        registrationApiProvider.overrideWithValue(
          api ?? _FakeRegistrationApi(),
        ),
        registrationSessionStorageProvider.overrideWithValue(
          storage ?? _FakeRegistrationSessionStorage(),
        ),
        ...overrides,
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
        locale: locale,
      ),
    ),
  );
}

Future<void> _fillAccount(
  WidgetTester tester, {
  String email = 'test@example.com',
  String password = 'secret123',
  String confirm = 'secret123',
  String otp = '123456',
  bool completeVerification = true,
}) async {
  await tester.enterText(find.widgetWithText(TextFormField, 'Email'), email);
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Phone'),
    '07701234567',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Password'),
    password,
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Confirm password'),
    confirm,
  );
  // Select governorate (Baghdad).
  await tester.ensureVisible(find.text('Governorate'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Governorate'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Baghdad').last);
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.widgetWithText(FilledButton, 'Continue'));
  await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  if (!completeVerification) return;
  // M31B email-verification step: enter the code and verify.
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Verification code'),
    otp,
  );
  await tester.pump();
  await tester.tap(find.widgetWithText(FilledButton, 'Verify email'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> _setPathsAndRead(WidgetTester tester) async {
  final ctx = tester.element(find.byType(RegisterScreen));
  final container = ProviderScope.containerOf(ctx);
  container
      .read(registrationControllerProvider.notifier)
      .setScannedPaths(front: '/tmp/front.jpg', back: '/tmp/back.jpg');
  await tester.pump();
  await tester.tap(find.widgetWithText(FilledButton, 'Read document'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 1700));
  await tester.pump();
}

void main() {
  testWidgets('step 1 shows account fields only, no card upload', (
    tester,
  ) async {
    await _pump(tester);
    expect(find.text('Create account'), findsWidgets);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Phone'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(
      find.widgetWithText(TextFormField, 'Confirm password'),
      findsOneWidget,
    );
    expect(find.text('Governorate'), findsOneWidget);
    // NO National Card upload controls on Step 1.
    expect(find.textContaining('Scan front'), findsNothing);
    expect(find.textContaining('Scan back'), findsNothing);
    expect(find.text('National Card'), findsNothing);
    // NO manual profile inputs on Step 1.
    expect(find.text('Full name'), findsNothing);
    expect(find.text('Date of birth'), findsNothing);
    expect(find.text('Family number'), findsNothing);
    expect(find.text('National/Card number'), findsNothing);
  });

  testWidgets('step 1 appbar back goes to login', (tester) async {
    await _pump(tester);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('login-screen'), findsOneWidget);
  });

  testWidgets('system back on step 1 goes to login', (tester) async {
    await _pump(tester);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('login-screen'), findsOneWidget);
  });

  testWidgets('step 1 login link goes to login', (tester) async {
    await _pump(tester);
    await tester.ensureVisible(find.textContaining('Already have an account'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Already have an account'));
    await tester.pumpAndSettle();
    expect(find.text('login-screen'), findsOneWidget);
  });

  testWidgets('step 2 appbar back returns to step 1', (tester) async {
    await _pump(tester);
    await _fillAccount(tester);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
  });

  testWidgets('step 3 appbar back returns to step 2', (tester) async {
    final api = _FakeRegistrationApi()..extractionResult = _successResult();
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester);
    await _setPathsAndRead(tester);
    expect(find.text('Review your information'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Verify your identity'), findsOneWidget);
  });

  testWidgets('mismatched passwords stay on the account step', (tester) async {
    await _pump(tester);
    await _fillAccount(
      tester,
      password: 'secret123',
      confirm: 'different1',
      completeVerification: false,
    );
    expect(find.text('Passwords do not match.'), findsOneWidget);
    expect(find.text('Create account'), findsWidgets);
  });

  testWidgets('valid account + governorate advances to step 2 with uploads', (
    tester,
  ) async {
    await _pump(tester);
    await _fillAccount(tester);
    // Step 2 — Verify your identity.
    expect(find.text('Verify your identity'), findsOneWidget);
    expect(find.textContaining('Scan front'), findsOneWidget);
    expect(find.textContaining('Scan back'), findsOneWidget);
    // No images yet → Read document disabled.
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Read document'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('backend password error returns to step 1, focuses password, '
      'shows inline error, no second extraction', (tester) async {
    final api = _FakeRegistrationApi()
      ..extractionResult = _successResult()
      ..submitError = const ApiException(
        code: 'validation_error',
        message: 'Validation failed.',
        details: {
          'password': ['This password is too common.'],
        },
      );
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester);
    await _setPathsAndRead(tester);

    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Create account'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();

    // Back on Step 1 with the password error inline + password focused.
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.text('This password is too common.'), findsOneWidget);
    final passwordField = tester.widget<AppTextField>(
      find.ancestor(
        of: find.widgetWithText(TextFormField, 'Password'),
        matching: find.byType(AppTextField),
      ),
    );
    expect(passwordField.errorText, 'This password is too common.');
    expect(passwordField.focusNode, isNotNull);
    expect(passwordField.focusNode!.hasFocus, isTrue);
    // No re-upload / new extraction job happened.
    expect(api.extractCount, 1);

    // Fix the password (backend would now accept) and Continue.
    api.submitError = null;
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'NotCommon123!',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Confirm password'),
      'NotCommon123!',
    );
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Continue'));
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Straight to review (no Step 2 upload), still one extraction total.
    expect(find.text('Review your information'), findsOneWidget);
    expect(api.extractCount, 1);
    // Confirmation was retained from the first (failed) attempt — do NOT
    // toggle it again.
    expect(
      tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
      isTrue,
    );
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Create account'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(api.registerCount, 1);
    expect(api.lastPassword, 'NotCommon123!');
  });

  testWidgets('step 3 back returns to step 2 already-read, no re-upload', (
    tester,
  ) async {
    final api = _FakeRegistrationApi()..extractionResult = _successResult();
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester);
    await _setPathsAndRead(tester);

    expect(find.text('Review your information'), findsOneWidget);
    await tester.ensureVisible(find.text('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // Step 2 shows already-read state (no upload controls).
    expect(find.text('Verify your identity'), findsOneWidget);
    expect(find.text('National Card already read'), findsOneWidget);
    expect(find.textContaining('Scan front'), findsNothing);
    expect(api.extractCount, 1);

    await tester.tap(find.widgetWithText(FilledButton, 'Continue to review'));
    await tester.pumpAndSettle();
    expect(find.text('Review your information'), findsOneWidget);
    expect(api.extractCount, 1);
  });

  testWidgets('edit account details from step 3 returns to step 1 with '
      'values preserved', (tester) async {
    final api = _FakeRegistrationApi()..extractionResult = _successResult();
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester, email: 'edit@example.com');
    await _setPathsAndRead(tester);

    expect(find.text('Review your information'), findsOneWidget);
    await tester.ensureVisible(
      find.widgetWithText(OutlinedButton, 'Edit account details'),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(OutlinedButton, 'Edit account details'),
    );
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.widgetWithText(TextFormField, 'Email'))
          .controller!
          .text,
      'edit@example.com',
    );
    // Identity state retained: Continue jumps straight back to review.
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Continue'));
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Review your information'), findsOneWidget);
    expect(api.extractCount, 1);
  });

  testWidgets('extraction happy path reaches review with all fields', (
    tester,
  ) async {
    final api = _FakeRegistrationApi()..extractionResult = _successResult();
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester);
    await _setPathsAndRead(tester);

    expect(find.text('Review your information'), findsOneWidget);
    expect(find.text('Personal information'), findsOneWidget);
    expect(find.text('Account information'), findsOneWidget);
    expect(find.text('Card information'), findsOneWidget);
    expect(api.extractCount, 1);
    expect(api.pollCount, 1);

    expect(
      tester
          .widget<TextFormField>(find.widgetWithText(TextFormField, 'Name'))
          .controller!
          .text,
      'Ali',
    );
    expect(
      tester
          .widget<TextFormField>(
            find.widgetWithText(TextFormField, "Father's name"),
          )
          .controller!
          .text,
      'Ahmed',
    );
    expect(
      tester
          .widget<TextFormField>(
            find.widgetWithText(TextFormField, "Grandfather's name"),
          )
          .controller!
          .text,
      'Hassan',
    );
    // Account info shows entered values.
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('Baghdad'), findsWidgets);
    // Distinct identifiers.
    expect(
      tester
          .widget<TextFormField>(
            find.widgetWithText(TextFormField, 'National/Card number'),
          )
          .controller!
          .text,
      '999999999999',
    );
    expect(
      tester
          .widget<TextFormField>(
            find.widgetWithText(TextFormField, 'Family number'),
          )
          .controller!
          .text,
      'TESTFAMILY123456',
    );
    expect(
      tester
          .widget<TextFormField>(
            find.widgetWithText(TextFormField, 'Unique card body number'),
          )
          .controller!
          .text,
      'H12345678',
    );
  });

  testWidgets('confirmation is required before account creation', (
    tester,
  ) async {
    final api = _FakeRegistrationApi()..extractionResult = _successResult();
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester);
    await _setPathsAndRead(tester);

    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Create account'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();
    expect(api.registerCount, 0);
    // Inline confirmation error + highlighted field, NOT a generic snackbar.
    expect(
      find.text(
        'Please confirm that the information above matches your National Card.',
      ),
      findsOneWidget,
    );
    expect(find.text('Please check the highlighted fields.'), findsNothing);
  });

  testWidgets('empty required field is highlighted inline and blocks submit', (
    tester,
  ) async {
    final api = _FakeRegistrationApi()..extractionResult = _successResult();
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester);
    await _setPathsAndRead(tester);

    await tester.ensureVisible(
      find.widgetWithText(TextFormField, 'Family number'),
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Family number'),
      '',
    );
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Create account'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();

    expect(api.registerCount, 0);
    // The family field is visually highlighted via errorText.
    final familyAppField = tester.widget<AppTextField>(
      find.ancestor(
        of: find.widgetWithText(TextFormField, 'Family number'),
        matching: find.byType(AppTextField),
      ),
    );
    expect(familyAppField.errorText, 'This field is required.');
    expect(find.text('This field is required.'), findsOneWidget);
    expect(find.text('Please check the highlighted fields.'), findsNothing);
  });

  testWidgets('real-shaped synthetic card (Arabic names, alphanumeric family, '
      'G-prefix body) submits exactly once', (tester) async {
    final api = _FakeRegistrationApi()
      ..extractionResult = _resultWith(
        name: 'علي',
        fatherName: 'محمد',
        grandfatherName: 'حسين',
        motherName: 'فاطمة',
        sex: 'MALE',
        dateOfBirth: '1990-01-15',
        bloodGroup: 'O+',
        nationalCardNumber: '123456789012',
        familyNumber: '9021A1B90870045612',
        uniqueCardBodyNumber: 'G12345678',
      );
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester, email: 'real@example.com');
    await _setPathsAndRead(tester);

    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Create account'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(api.registerCount, 1);
    final id = api.lastIdentity!;
    expect(id.name, 'علي');
    expect(id.fatherName, 'محمد');
    expect(id.grandfatherName, 'حسين');
    expect(id.motherName, 'فاطمة');
    expect(id.nationalCardNumber, '123456789012');
    expect(id.familyNumber, '9021A1B90870045612');
    expect(id.uniqueCardBodyNumber, 'G12345678');
    expect(id.sex, Sex.male);
    expect(id.bloodGroup, BloodGroup.oPos);
    // Low-confidence / legacy fields never add required errors.
    expect(find.text('This field is required.'), findsNothing);
    expect(find.text('Please check the highlighted fields.'), findsNothing);
  });

  testWidgets('hidden legacy fields (document number) are not required', (
    tester,
  ) async {
    final api = _FakeRegistrationApi()
      ..extractionResult = _resultWith(
        name: 'Ali',
        fatherName: 'Ahmed',
        grandfatherName: 'Hassan',
        sex: 'MALE',
        dateOfBirth: '1990-01-15',
        bloodGroup: 'O+',
        nationalCardNumber: '123456789012',
        familyNumber: 'TESTFAMILY123456',
        uniqueCardBodyNumber: 'H12345678',
        removeDocumentNumber: true,
      );
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester, email: 'legacy@example.com');
    await _setPathsAndRead(tester);

    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Create account'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(api.registerCount, 1);
    expect(api.lastIdentity!.nationalCardNumber, '123456789012');
    expect(find.text('This field is required.'), findsNothing);
  });

  testWidgets('submit sends confirmed values and goes to login', (
    tester,
  ) async {
    final api = _FakeRegistrationApi()..extractionResult = _successResult();
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester, email: 'scan@example.com');
    await _setPathsAndRead(tester);

    // Correct a value + tick the confirmation box.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Family number'),
      'FAM-EDITED',
    );
    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();

    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Create account'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(api.registerCount, 1);
    expect(api.lastEmail, 'scan@example.com');
    expect(api.lastPassword, 'secret123');
    expect(api.lastGovernorate, 'BAGHDAD');
    final id = api.lastIdentity!;
    expect(id.jobId, 'job-1');
    expect(id.jobToken, 'token-1');
    expect(id.documentType, IdentityDocumentType.unifiedNationalCard);
    expect(id.name, 'Ali');
    expect(id.fatherName, 'Ahmed');
    expect(id.grandfatherName, 'Hassan');
    expect(id.motherName, 'Fatima');
    expect(id.confirmation, isTrue);
    expect(id.nationalCardNumber, '999999999999');
    expect(id.familyNumber, 'FAM-EDITED');
    expect(id.uniqueCardBodyNumber, 'H12345678');
    expect(id.sex, Sex.male);
    expect(id.bloodGroup, BloodGroup.oPos);
    expect(id.nationality, 'IQ');

    // Success → login.
    await tester.pumpAndSettle();
    expect(find.text('login-screen'), findsOneWidget);
    expect(find.text('Account created. Please sign in.'), findsOneWidget);
  });

  testWidgets('failed extraction shows error and retry preserves images', (
    tester,
  ) async {
    final api = _FakeRegistrationApi()..jobStatus = ExtractionJobStatus.failed;
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester);
    await _setPathsAndRead(tester);

    expect(
      find.text('Document reading failed. Please try again.'),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Verify your identity'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Read document'),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('poll 404 stops loop with session-invalid message', (
    tester,
  ) async {
    final api = _FakeRegistrationApi()
      ..extractionResult = _successResult()
      ..pollError = const ApiException(
        code: 'registration_job_not_found',
        message: 'Registration session is no longer valid.',
        statusCode: 404,
      );
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester);
    await _setPathsAndRead(tester);
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    // Loop stops: no stuck "Reading document...", a recoverable error shows.
    expect(find.textContaining('Reading document'), findsNothing);
    expect(
      find.text(
        'Your registration session is no longer valid. Please scan your card again.',
      ),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('poll 500 stops loop with server-error message', (tester) async {
    final api = _FakeRegistrationApi()
      ..extractionResult = _successResult()
      ..pollError = const ApiException(
        code: 'server_error',
        message: 'Server error.',
        statusCode: 500,
      );
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester);
    await _setPathsAndRead(tester);
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.textContaining('Reading document'), findsNothing);
    expect(find.text('Server error. Please try again later.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets(
    'pending -> processing -> success reaches review, single upload',
    (tester) async {
      final api = _FakeRegistrationApi()
        ..extractionResult = _successResult()
        ..pollSequence = [
          ExtractionJobStatus.pending,
          ExtractionJobStatus.processing,
          ExtractionJobStatus.success,
        ];
      await _pump(
        tester,
        overrides: [registrationApiProvider.overrideWithValue(api)],
      );
      await _fillAccount(tester);
      await _setPathsAndRead(tester);
      expect(api.extractCount, 1);

      // poll 1 (pending, fired inside _setPathsAndRead) then poll 2
      // (processing) — still reading, no second upload.
      await tester.pump(const Duration(milliseconds: 1600));
      expect(find.textContaining('Reading document'), findsOneWidget);
      expect(api.extractCount, 1);

      // poll 3 (success) -> review.
      await tester.pump(const Duration(milliseconds: 1600));
      await tester.pump();
      expect(find.text('Review your information'), findsOneWidget);
      expect(api.extractCount, 1);
    },
  );

  testWidgets('widget rebuilds during reading do not re-upload', (
    tester,
  ) async {
    final api = _FakeRegistrationApi()
      ..extractionResult = _successResult()
      ..pollSequence = [
        ExtractionJobStatus.processing,
        ExtractionJobStatus.processing,
        ExtractionJobStatus.success,
      ];
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester);
    await _setPathsAndRead(tester);
    expect(api.extractCount, 1);

    // Many frames + a few poll ticks — rebuilds must not start a second POST.
    await tester.pump(const Duration(milliseconds: 1600));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pump(const Duration(milliseconds: 1600));
    expect(api.extractCount, 1);

    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump();
    expect(find.text('Review your information'), findsOneWidget);
    expect(api.extractCount, 1);
  });

  testWidgets('email-exists error surfaces specific message', (tester) async {
    final api = _FakeRegistrationApi()
      ..extractionResult = _successResult()
      ..submitError = const ApiException(
        code: 'validation_error',
        message: 'Validation failed.',
        details: {
          'email': ['An account with this email already exists.'],
        },
      );
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester);
    await _setPathsAndRead(tester);
    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Create account'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.text('This email is already registered. Please sign in instead.'),
      findsOneWidget,
    );
  });

  testWidgets('expired job error surfaces scan-again message', (tester) async {
    final api = _FakeRegistrationApi()
      ..extractionResult = _successResult()
      ..submitError = const ApiException(
        code: 'registration_job_expired',
        message: 'Registration identity session has expired.',
      );
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester);
    await _setPathsAndRead(tester);
    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Create account'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.text(
        'Your registration session expired. Please scan your card again.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('server error maps to server message as last resort', (
    tester,
  ) async {
    final api = _FakeRegistrationApi()
      ..extractionResult = _successResult()
      ..submitError = const ApiException(
        statusCode: 500,
        code: 'http_500',
        message: 'Server error.',
      );
    await _pump(
      tester,
      overrides: [registrationApiProvider.overrideWithValue(api)],
    );
    await _fillAccount(tester);
    await _setPathsAndRead(tester);
    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Create account'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Server error. Please try again later.'), findsOneWidget);
  });

  // ---------------------------------------------------------------------
  // M31B — email verification
  // ---------------------------------------------------------------------

  testWidgets('account submit goes to email verification, NOT identity scan', (
    tester,
  ) async {
    final api = _FakeRegistrationApi();
    await _pump(tester, api: api);
    await _fillAccount(tester, completeVerification: false);

    // Verify step: masked email + OTP input, no card controls yet.
    expect(find.text('Verify your email'), findsOneWidget);
    expect(find.textContaining('t***m@example.com'), findsOneWidget);
    expect(
      find.widgetWithText(TextFormField, 'Verification code'),
      findsOneWidget,
    );
    expect(find.textContaining('Scan front'), findsNothing);
    expect(api.extractCount, 0);
    expect(api.startVerifyCount, 1);
  });

  testWidgets('invalid OTP shows error and stays on verify step', (
    tester,
  ) async {
    final api = _FakeRegistrationApi()
      ..verifyError = const ApiException(
        statusCode: 400,
        code: 'validation_error',
        message: 'Validation failed.',
        details: {
          'code': ['The verification code is invalid or has expired.'],
        },
      );
    await _pump(tester, api: api);
    await _fillAccount(tester, completeVerification: false);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Verification code'),
      '000000',
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Verify email'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Verify your email'), findsOneWidget);
    expect(
      find.text('That code is incorrect. Please check and try again.'),
      findsOneWidget,
    );
    // Cannot reach identity scan.
    expect(find.textContaining('Scan front'), findsNothing);
    expect(api.extractCount, 0);
  });

  testWidgets('valid OTP advances to identity scan', (tester) async {
    final api = _FakeRegistrationApi();
    await _pump(tester, api: api);
    await _fillAccount(tester);

    expect(find.text('Verify your identity'), findsOneWidget);
    expect(find.text('Verify your email'), findsNothing);
    expect(api.verifyCount, 1);
  });

  testWidgets('OTP delivery failure shows distinct resend message, not the '
      'generic verify error', (tester) async {
    final api = _FakeRegistrationApi()
      ..startVerifyError = const ApiException(
        statusCode: 503,
        code: 'registration_email_delivery_failed',
        message: 'OTP email delivery failed.',
      );
    await _pump(tester, api: api);
    await _fillAccount(tester, completeVerification: false);

    // The first OTP could not be sent: the user stays on the verify step but
    // sees the distinct "couldn't send" message (not the generic verify
    // error), and cannot advance to the card scan.
    expect(
      find.text(
        "We couldn't send the verification code. "
        'Please try resending in a moment.',
      ),
      findsOneWidget,
    );
    expect(find.text('Verify your email'), findsOneWidget);
    expect(find.textContaining('Scan front'), findsNothing);
    expect(api.startVerifyCount, 1);
    expect(api.extractCount, 0);
  });

  testWidgets('OTP delivery failure shown in Arabic (RTL)', (tester) async {
    final api = _FakeRegistrationApi()
      ..startVerifyError = const ApiException(
        statusCode: 503,
        code: 'registration_email_delivery_failed',
        message: 'OTP email delivery failed.',
      );
    await _pump(tester, api: api, locale: const Locale('ar'));
    // Drive the controller directly (field labels are localized to Arabic).
    final ctx = tester.element(find.byType(RegisterScreen));
    final container = ProviderScope.containerOf(ctx);
    await container
        .read(registrationControllerProvider.notifier)
        .setCredentials(
          email: 'test@example.com',
          phone: '07701234567',
          password: 'secret123',
          governorate: 'BAGHDAD',
        );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.text('تعذّر إرسال رمز التحقق. حاول إعادة الإرسال بعد قليل.'),
      findsOneWidget,
    );
    expect(find.text('تحقق من بريدك الإلكتروني'), findsOneWidget);
  });

  testWidgets('resend countdown disables resend while cooldown active', (
    tester,
  ) async {
    final api = _FakeRegistrationApi()
      ..resendAt = DateTime.now().add(const Duration(seconds: 45));
    await _pump(tester, api: api);
    await _fillAccount(tester, completeVerification: false);

    expect(find.text('Verify your email'), findsOneWidget);
    expect(find.textContaining('Resend in'), findsOneWidget);
    expect(find.text('Resend code'), findsNothing);

    // Leave the verify step so the countdown timer is cancelled (no pending
    // timers at test teardown).
    await tester.ensureVisible(find.widgetWithText(TextButton, 'Start over'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Start over'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
  });

  testWidgets('resend enabled when no cooldown window', (tester) async {
    await _pump(tester);
    await _fillAccount(tester, completeVerification: false);
    expect(find.text('Verify your email'), findsOneWidget);
    expect(find.text('Resend code'), findsOneWidget);
    expect(find.textContaining('Resend in'), findsNothing);
  });

  testWidgets('resume: verified persisted session jumps straight to scan', (
    tester,
  ) async {
    final api = _FakeRegistrationApi()
      ..resumeStatus = const RegistrationEmailStatus(
        sessionId: 's1',
        maskedEmail: 't***m@example.com',
        status: 'EMAIL_VERIFIED',
        emailVerified: true,
      );
    final storage = _FakeRegistrationSessionStorage()
      ..record = const RegistrationSessionRecord(
        sessionToken: 'tok-1',
        email: 'test@example.com',
        phone: '07701234567',
        governorate: 'BAGHDAD',
      );
    await _pump(tester, api: api, storage: storage);
    await tester.pumpAndSettle();

    // Verification survived restart → straight to scan, no re-verify.
    expect(find.text('Verify your identity'), findsOneWidget);
    expect(find.text('Verify your email'), findsNothing);
  });

  testWidgets('resume: pending persisted session returns to verify step', (
    tester,
  ) async {
    final api = _FakeRegistrationApi();
    final storage = _FakeRegistrationSessionStorage()
      ..record = const RegistrationSessionRecord(
        sessionToken: 'tok-1',
        email: 'test@example.com',
        governorate: 'BAGHDAD',
      );
    await _pump(tester, api: api, storage: storage);
    await tester.pumpAndSettle();

    expect(find.text('Verify your email'), findsOneWidget);
    expect(find.textContaining('t***m@example.com'), findsOneWidget);
  });

  testWidgets('start over clears the persisted session and shows account', (
    tester,
  ) async {
    final storage = _FakeRegistrationSessionStorage()
      ..record = const RegistrationSessionRecord(
        sessionToken: 'tok-1',
        email: 'test@example.com',
        governorate: 'BAGHDAD',
      );
    await _pump(tester, storage: storage);
    await tester.pumpAndSettle();
    expect(find.text('Verify your email'), findsOneWidget);

    await tester.ensureVisible(find.widgetWithText(TextButton, 'Start over'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Start over'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(storage.record, isNull);
  });
}
