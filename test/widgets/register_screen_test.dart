import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/user.dart';
import 'package:pmdap_mobile/features/auth/application/registration_controller.dart';
import 'package:pmdap_mobile/features/auth/data/registration_api.dart';
import 'package:pmdap_mobile/features/auth/data/registration_models.dart';
import 'package:pmdap_mobile/features/auth/presentation/register_screen.dart';
import 'package:pmdap_mobile/features/identity/data/extraction_models.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

/// Fake public scan-first Registration API (SYNTHETIC values only).
class _FakeRegistrationApi extends RegistrationApi {
  _FakeRegistrationApi() : super(Dio());

  int extractCount = 0;
  int pollCount = 0;
  int registerCount = 0;
  ExtractionJobStatus jobStatus = ExtractionJobStatus.success;
  IdentityExtractionResult? extractionResult;
  RegistrationIdentityInput? lastIdentity;
  String? lastEmail;
  String? lastPassword;
  String? lastGovernorate;
  bool failRegister = false;

  @override
  Future<RegistrationExtractionJob> startExtraction({
    required String frontPath,
    String? backPath,
    void Function(int, int)? onSendProgress,
  }) async {
    // NOTE: the API signature has NO password/account fields — credentials
    // are never sent to the extraction endpoint by design.
    extractCount++;
    onSendProgress?.call(10, 100);
    return const RegistrationExtractionJob(jobId: 'job-1', jobToken: 'token-1');
  }

  @override
  Future<RegistrationExtractionStatus> pollExtraction({
    required String jobId,
    required String jobToken,
  }) async {
    pollCount++;
    return RegistrationExtractionStatus(
      jobId: jobId,
      status: jobStatus,
      result: jobStatus == ExtractionJobStatus.success
          ? extractionResult
          : null,
    );
  }

  @override
  Future<PublicUser> registerScanFirst({
    required String email,
    String? phone,
    required String password,
    required String governorate,
    required RegistrationIdentityInput identity,
  }) async {
    if (failRegister) throw Exception('network');
    registerCount++;
    lastEmail = email;
    lastPassword = password;
    lastGovernorate = governorate;
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

Future<void> _fillAccount(
  WidgetTester tester, {
  String email = 'test@example.com',
  String password = 'secret123',
  String confirm = 'secret123',
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
  testWidgets('first screen exposes only account + card capture fields', (
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
    expect(find.textContaining('Scan front'), findsOneWidget);
    expect(find.textContaining('Scan back'), findsOneWidget);
    // NO manual profile inputs on the first screen.
    expect(find.text('Full name'), findsNothing);
    expect(find.text('Date of birth'), findsNothing);
    expect(find.text('Family number'), findsNothing);
    expect(find.text('National/Card number'), findsNothing);
  });

  testWidgets('mismatched passwords stay on the account step', (tester) async {
    await _pump(tester);
    await _fillAccount(tester, password: 'secret123', confirm: 'different1');
    expect(find.text('Passwords do not match.'), findsOneWidget);
    expect(find.text('Create account'), findsWidgets);
  });

  testWidgets('valid account + governorate advances to the scan step', (
    tester,
  ) async {
    await _pump(tester);
    await _fillAccount(tester);
    expect(find.text('Verify your information'), findsOneWidget);
    // No images yet → Read document disabled.
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Read document'),
    );
    expect(button.onPressed, isNull);
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
    await tester.pump();
    expect(api.registerCount, 0);
    expect(find.text('Please check the highlighted fields.'), findsOneWidget);
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
    expect(find.text('Verify your information'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Read document'),
    );
    expect(button.onPressed, isNotNull);
  });
}
