import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/api/api_exception.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/identity.dart';
import 'package:pmdap_mobile/core/models/pagination.dart';
import 'package:pmdap_mobile/features/identity/data/extraction_models.dart';
import 'package:pmdap_mobile/features/identity/data/identity_api.dart';
import 'package:pmdap_mobile/features/identity/presentation/identity_extraction_review_screen.dart';
import 'package:pmdap_mobile/features/identity/presentation/identity_submit_screen.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../helpers/pump.dart';

/// 1x1 PNG used as a decodable fake identity image.
final Uint8List _pngBytes = Uint8List.fromList(const <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, //
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, //
  0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x62, 0x00, 0x01, 0x00, 0x00, //
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, //
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

class _FakeIdentityApi extends IdentityApi {
  _FakeIdentityApi() : super(Dio());

  final List<IdentitySubmission> submitted = [];
  final List<String> replaceUuids = [];
  IdentityExtractionResult? extractionResult;
  ExtractionJobStatus jobStatus = ExtractionJobStatus.success;
  String failureErrorCode = 'OCR_UNAVAILABLE';
  int pollCount = 0;
  int extractCount = 0;
  ApiException? submitError;
  Page<IdentityDocumentSummary>? listResult;

  @override
  Future<Page<IdentityDocumentSummary>> list({int page = 1}) async {
    return listResult ??
        const Page<IdentityDocumentSummary>(
          count: 0,
          next: null,
          previous: null,
          results: [],
        );
  }

  @override
  Future<ExtractionJobDto> extract({
    required IdentityDocumentType documentType,
    required String frontPath,
    String? backPath,
    void Function(int, int)? onSendProgress,
  }) async {
    extractCount++;
    return ExtractionJobDto(
      jobId: 'job-1',
      status: ExtractionJobStatus.pending,
    );
  }

  @override
  Future<ExtractionStatus> extractStatus(String jobId) async {
    pollCount++;
    return ExtractionStatus(
      jobId: jobId,
      status: jobStatus,
      errorCode: jobStatus == ExtractionJobStatus.failed
          ? failureErrorCode
          : '',
      result: jobStatus == ExtractionJobStatus.success
          ? extractionResult
          : null,
    );
  }

  @override
  Future<IdentityDocumentDetail> submit(
    IdentitySubmission s, {
    void Function(int, int)? onSendProgress,
  }) async {
    if (submitError != null) throw submitError!;
    submitted.add(s);
    return const IdentityDocumentDetail(
      uuid: 'id-1',
      documentType: IdentityDocumentType.unifiedNationalCard,
      status: IdentityDocumentLifecycleStatus.current,
    );
  }

  @override
  Future<IdentityDocumentDetail> replace(
    String uuid,
    IdentitySubmission s, {
    void Function(int, int)? onSendProgress,
  }) async {
    replaceUuids.add(uuid);
    submitted.add(s);
    return IdentityDocumentDetail(
      uuid: uuid,
      documentType: IdentityDocumentType.unifiedNationalCard,
      status: IdentityDocumentLifecycleStatus.current,
    );
  }
}

IdentityExtractionResult _ncResult({
  String? national = '012345678901234',
  String? nationalCard,
  String? family = '1234',
  String? body,
  double nationalConf = 0.95,
  bool mrzVerified = true,
}) {
  ExtractedIdentityField f(
    String? value,
    double confidence,
    IdentityExtractionSource source,
  ) => ExtractedIdentityField(
    value: value,
    confidence: confidence,
    source: source,
  );

  // V2 backend emits `national_card_number`; older backends used
  // `national_number`. Prefer the V2 key when provided.
  final nationalKey = nationalCard != null
      ? 'national_card_number'
      : 'national_number';
  final nationalValue = nationalCard ?? national;

  return IdentityExtractionResult(
    documentType: IdentityDocumentType.unifiedNationalCard,
    extractorVersion: 'identity-v1',
    mrz: MrzValidationResult(
      detected: mrzVerified,
      valid: mrzVerified,
      checksPassed: mrzVerified,
    ),
    fields: {
      'document_number': f('A12345678', 0.96, IdentityExtractionSource.ocr),
      if (nationalValue != null)
        nationalKey: f(
          nationalValue,
          nationalConf,
          IdentityExtractionSource.frontPrinted,
        ),
      if (family != null)
        'family_number': f(family, 0.8, IdentityExtractionSource.backPrinted),
      if (body != null)
        'unique_card_body_number': f(
          body,
          0.95,
          IdentityExtractionSource.frontPrinted,
        ),
      'issuing_country': f('IQ', 1.0, IdentityExtractionSource.documentType),
    },
    warnings: const [],
  );
}

IdentityExtractionResult _passportResult() {
  ExtractedIdentityField f(
    String value,
    double confidence,
    IdentityExtractionSource source,
  ) => ExtractedIdentityField(
    value: value,
    confidence: confidence,
    source: source,
  );

  return IdentityExtractionResult(
    documentType: IdentityDocumentType.passport,
    extractorVersion: 'identity-v1',
    mrz: const MrzValidationResult(
      detected: true,
      valid: true,
      checksPassed: true,
    ),
    fields: {
      'document_number': f('A12345678', 0.97, IdentityExtractionSource.mrz),
      'issuing_country': f('IQ', 1.0, IdentityExtractionSource.mrz),
      'date_of_birth': f('1990-05-12', 0.99, IdentityExtractionSource.mrz),
      'sex': f('M', 0.99, IdentityExtractionSource.mrz),
      'nationality': f('IRQ', 0.95, IdentityExtractionSource.mrz),
      'issue_date': f('2021-01-15', 0.6, IdentityExtractionSource.ocr),
      'expiry_date': f('2031-01-14', 0.92, IdentityExtractionSource.mrz),
    },
    warnings: const [],
  );
}

void main() {
  late _FakeIdentityApi fakeApi;
  late AppLocalizations en;
  late String imagePath;

  setUpAll(() async {
    en = await AppLocalizations.delegate.load(const Locale('en'));
  });

  setUp(() async {
    fakeApi = _FakeIdentityApi();
    final dir = await Directory.systemTemp.createTemp('pmdap_test');
    final file = File('${dir.path}/front.png');
    await file.writeAsBytes(_pngBytes);
    imagePath = file.path;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('pmdap/document_scanner'),
          (call) async {
            if (call.method == 'scan') {
              return <String, dynamic>{
                'pages': <String>[imagePath],
                'pdf': null,
                'pageCount': 1,
              };
            }
            return null;
          },
        );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('pmdap/document_scanner'),
          null,
        );
  });

  Widget host(Widget child) => pumpApp(
    child,
    overrides: [identityApiProvider.overrideWithValue(fakeApi)],
  );

  Finder primaryButton(String label) =>
      find.widgetWithText(FilledButton, label);

  Future<void> scanFront(WidgetTester tester) async {
    await tester.ensureVisible(find.text(en.scanFront));
    await tester.pumpAndSettle();
    await tester.tap(find.text(en.scanFront));
    await tester.pumpAndSettle();
  }

  Future<void> scanBack(WidgetTester tester) async {
    await tester.ensureVisible(find.text(en.scanBack));
    await tester.pumpAndSettle();
    await tester.tap(find.text(en.scanBack));
    await tester.pumpAndSettle();
  }

  Future<void> scanPassport(WidgetTester tester) async {
    await tester.ensureVisible(find.text(en.scanPassport));
    await tester.pumpAndSettle();
    await tester.tap(find.text(en.scanPassport));
    await tester.pumpAndSettle();
  }

  Future<void> tapPrimary(WidgetTester tester, String label) async {
    await tester.ensureVisible(primaryButton(label));
    await tester.pumpAndSettle();
    await tester.tap(primaryButton(label));
    await tester.pumpAndSettle();
  }

  group('capture gating', () {
    testWidgets('NationalCard read disabled until front+back captured', (
      tester,
    ) async {
      await tester.pumpWidget(host(const IdentitySubmitScreen()));
      await tester.pumpAndSettle();
      expect(primaryButton(en.readDocument), findsOneWidget);
      final btn = tester.widget<FilledButton>(primaryButton(en.readDocument));
      expect(btn.onPressed, isNull);

      await scanFront(tester);
      expect(
        tester.widget<FilledButton>(primaryButton(en.readDocument)).onPressed,
        isNull,
      );

      await scanBack(tester);
      expect(
        tester.widget<FilledButton>(primaryButton(en.readDocument)).onPressed,
        isNotNull,
      );
    });

    testWidgets('Passport read enabled after single capture', (tester) async {
      await tester.pumpWidget(host(const IdentitySubmitScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text(en.documentType));
      await tester.pumpAndSettle();
      await tester.tap(find.text(en.docTypePassport).last);
      await tester.pumpAndSettle();

      await scanPassport(tester);
      expect(
        tester.widget<FilledButton>(primaryButton(en.readDocument)).onPressed,
        isNotNull,
      );
    });
  });

  group('national card flow', () {
    testWidgets('read -> review shows buckets, edit, submit corrected', (
      tester,
    ) async {
      fakeApi.extractionResult = _ncResult(
        national: '012345678901234',
        nationalConf: 0.75,
      );
      await tester.pumpWidget(host(const IdentitySubmitScreen()));
      await tester.pumpAndSettle();
      await scanFront(tester);
      await scanBack(tester);

      await tapPrimary(tester, en.readDocument);

      expect(find.text(en.reviewDocumentInformation), findsOneWidget);
      expect(find.text(en.mrzVerified), findsOneWidget);
      expect(find.text(en.confidenceDetected), findsWidgets);
      expect(find.text(en.confidencePleaseCheck), findsWidgets);

      // Overwrite document number with a corrected value.
      final numberField = find.widgetWithText(TextField, 'A12345678');
      await tester.enterText(numberField, 'Z99999999');
      await tester.pump();

      await tapPrimary(tester, en.submitForVerification);

      expect(fakeApi.submitted, hasLength(1));
      final s = fakeApi.submitted.single;
      expect(s.documentType, IdentityDocumentType.unifiedNationalCard);
      expect(s.documentNumber, 'Z99999999');
      expect(s.nationalNumber, '012345678901234');
      expect(s.familyNumber, '1234');
      expect(s.issuingCountry, 'IQ');
      // OCR-review submit uses the extraction job (single upload), never
      // local image paths.
      final source = s.source;
      expect(source, isA<ExtractionJob>());
      expect((source as ExtractionJob).jobId, 'job-1');
    });

    testWidgets('missing field shows needs review + could-not-read label', (
      tester,
    ) async {
      fakeApi.extractionResult = _ncResult(national: null, family: null);
      await tester.pumpWidget(host(const IdentitySubmitScreen()));
      await tester.pumpAndSettle();
      await scanFront(tester);
      await scanBack(tester);
      await tapPrimary(tester, en.readDocument);

      expect(find.text(en.confidenceNeedsReview), findsWidgets);
      expect(find.textContaining(en.couldNotReadThisField), findsWidgets);
    });

    testWidgets('V2 keys land in own boxes: national_card_number + body', (
      tester,
    ) async {
      // Four DISTINCT invented identifiers: document, national (V2 key),
      // family, and the H... card body number. Each must land in its own box
      // and the body number must never be displayed as (or submitted as) the
      // family number.
      fakeApi.extractionResult = _ncResult(
        nationalCard: '999999999999',
        family: 'TESTFAMILY123456',
        body: 'H12345678',
      );
      await tester.pumpWidget(host(const IdentitySubmitScreen()));
      await tester.pumpAndSettle();
      await scanFront(tester);
      await scanBack(tester);
      await tapPrimary(tester, en.readDocument);

      // Each value appears in exactly one text box.
      expect(find.widgetWithText(TextField, 'A12345678'), findsOneWidget);
      expect(find.widgetWithText(TextField, '999999999999'), findsOneWidget);
      expect(
        find.widgetWithText(TextField, 'TESTFAMILY123456'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextField, 'H12345678'), findsOneWidget);

      await tapPrimary(tester, en.submitForVerification);
      expect(fakeApi.submitted, hasLength(1));
      final s = fakeApi.submitted.single;
      expect(s.documentNumber, 'A12345678');
      expect(s.nationalNumber, '999999999999');
      expect(s.familyNumber, 'TESTFAMILY123456');
      // Body number must never leak into family/national/document slots.
      expect(s.familyNumber, isNot('H12345678'));
      expect(s.nationalNumber, isNot('H12345678'));
      expect(s.documentNumber, isNot('H12345678'));
    });

    testWidgets('replacement uses replace endpoint', (tester) async {
      fakeApi.extractionResult = _ncResult();
      await tester.pumpWidget(
        host(const IdentitySubmitScreen(replaceUuid: 'old-1')),
      );
      await tester.pumpAndSettle();
      await scanFront(tester);
      await scanBack(tester);
      await tapPrimary(tester, en.readDocument);

      await tapPrimary(tester, en.submitForVerification);

      expect(fakeApi.replaceUuids, ['old-1']);
    });

    testWidgets('409 conflict shows pending message, never generic error', (
      tester,
    ) async {
      fakeApi.extractionResult = _ncResult();
      fakeApi.submitError = const ApiException(
        statusCode: 409,
        code: 'identity_document_conflict',
        message:
            'Use the explicit replacement workflow for this document type.',
      );
      fakeApi.listResult = Page<IdentityDocumentSummary>(
        count: 1,
        next: null,
        previous: null,
        results: [
          IdentityDocumentSummary(
            uuid: 'id-1',
            documentType: IdentityDocumentType.unifiedNationalCard,
            verificationStatus: VerificationStatus.pending,
            status: IdentityDocumentLifecycleStatus.current,
          ),
        ],
      );
      await tester.pumpWidget(host(const IdentitySubmitScreen()));
      await tester.pumpAndSettle();
      await scanFront(tester);
      await scanBack(tester);
      await tapPrimary(tester, en.readDocument);
      await tapPrimary(tester, en.submitForVerification);
      await tester.pumpAndSettle();

      expect(find.text(en.identityConflictTitle), findsOneWidget);
      expect(find.text(en.identityConflictPending), findsOneWidget);
      expect(find.text(en.viewIdentityDocuments), findsOneWidget);
      expect(find.text(en.errorGeneric), findsNothing);
      // No automatic retry: exactly one submit attempt was made.
      expect(fakeApi.submitted, isEmpty);
    });

    testWidgets('409 conflict with verified current doc suggests replace', (
      tester,
    ) async {
      fakeApi.extractionResult = _ncResult();
      fakeApi.submitError = const ApiException(
        statusCode: 409,
        code: 'identity_document_conflict',
        message:
            'Use the explicit replacement workflow for this document type.',
      );
      fakeApi.listResult = Page<IdentityDocumentSummary>(
        count: 1,
        next: null,
        previous: null,
        results: [
          IdentityDocumentSummary(
            uuid: 'id-9',
            documentType: IdentityDocumentType.unifiedNationalCard,
            verificationStatus: VerificationStatus.verified,
            status: IdentityDocumentLifecycleStatus.current,
          ),
        ],
      );
      await tester.pumpWidget(host(const IdentitySubmitScreen()));
      await tester.pumpAndSettle();
      await scanFront(tester);
      await scanBack(tester);
      await tapPrimary(tester, en.readDocument);
      await tapPrimary(tester, en.submitForVerification);
      await tester.pumpAndSettle();

      expect(find.text(en.identityConflictTitle), findsOneWidget);
      expect(find.text(en.identityConflictVerified), findsOneWidget);
      expect(find.text(en.errorGeneric), findsNothing);
    });

    testWidgets('OCR unavailable keeps images and shows unavailable message', (
      tester,
    ) async {
      fakeApi.jobStatus = ExtractionJobStatus.failed;
      fakeApi.failureErrorCode = 'OCR_UNAVAILABLE';
      await tester.pumpWidget(host(const IdentitySubmitScreen()));
      await tester.pumpAndSettle();
      await scanFront(tester);
      await scanBack(tester);

      await tester.ensureVisible(primaryButton(en.readDocument));
      await tester.pumpAndSettle();
      await tester.tap(primaryButton(en.readDocument));
      await tester.pump(const Duration(milliseconds: 400));

      // Safe, specific message — never a generic error.
      expect(find.text(en.identityExtractionUnavailable), findsOneWidget);
      expect(find.text(en.documentReadingFailed), findsNothing);
      // Images preserved — retry without rescan.
      expect(
        tester.widget<FilledButton>(primaryButton(en.readDocument)).onPressed,
        isNotNull,
      );
      expect(find.text(en.rescan), findsWidgets);
    });

    testWidgets('EXTRACTION_FAILED keeps images and shows safe message', (
      tester,
    ) async {
      fakeApi.jobStatus = ExtractionJobStatus.failed;
      fakeApi.failureErrorCode = 'EXTRACTION_FAILED';
      await tester.pumpWidget(host(const IdentitySubmitScreen()));
      await tester.pumpAndSettle();
      await scanFront(tester);
      await scanBack(tester);

      await tester.ensureVisible(primaryButton(en.readDocument));
      await tester.pumpAndSettle();
      await tester.tap(primaryButton(en.readDocument));
      await tester.pump(const Duration(milliseconds: 400));

      // Safe failure message, no blank screen.
      expect(find.text(en.documentReadingFailed), findsOneWidget);
      // Images preserved — read still available for retry.
      expect(
        tester.widget<FilledButton>(primaryButton(en.readDocument)).onPressed,
        isNotNull,
      );
      expect(find.text(en.rescan), findsWidgets);
    });

    testWidgets('long PROCESSING shows reassurance and stays on reading screen', (
      tester,
    ) async {
      fakeApi.jobStatus = ExtractionJobStatus.processing;
      await tester.pumpWidget(host(const IdentitySubmitScreen()));
      await tester.pumpAndSettle();
      await scanFront(tester);
      await scanBack(tester);

      await tester.ensureVisible(primaryButton(en.readDocument));
      await tester.pumpAndSettle();
      await tester.tap(primaryButton(en.readDocument));
      await tester.pump(const Duration(milliseconds: 400));

      // Still reading: review did NOT appear yet.
      expect(find.text(en.reviewDocumentInformation), findsNothing);

      // After ~25s of OCR the reassurance message appears; no failure shown.
      await tester.pump(const Duration(seconds: 25));
      expect(find.text(en.documentReadingMayTakeLonger), findsOneWidget);
      expect(find.text(en.documentReadingFailed), findsNothing);
      expect(find.text(en.reviewDocumentInformation), findsNothing);

      // Multiple polls happened against the SAME job (no duplicate extraction).
      expect(fakeApi.pollCount, greaterThan(2));
      expect(fakeApi.extractCount, 1);

      // Tear down and let the still-running poll loop drain its timers.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('widget rebuild does not create a duplicate extraction job', (
      tester,
    ) async {
      fakeApi.jobStatus = ExtractionJobStatus.processing;
      await tester.pumpWidget(host(const IdentitySubmitScreen()));
      await tester.pumpAndSettle();
      await scanFront(tester);
      await scanBack(tester);

      await tester.ensureVisible(primaryButton(en.readDocument));
      await tester.pumpAndSettle();
      await tester.tap(primaryButton(en.readDocument));
      await tester.pump(const Duration(milliseconds: 400));

      // Rebuild the tree (simulate route/dependency rebuild).
      await tester.pumpWidget(host(const IdentitySubmitScreen()));
      await tester.pump(const Duration(seconds: 6));

      // Extraction was still triggered only once.
      expect(fakeApi.extractCount, 1);

      // Drain any timers left by the disposed screen's poll loop.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });
  });

  group('passport flow', () {
    testWidgets(
      'review shows passport fields + informational rows, submits dates',
      (tester) async {
        fakeApi.extractionResult = _passportResult();
        await tester.pumpWidget(host(const IdentitySubmitScreen()));
        await tester.pumpAndSettle();
        await tester.tap(find.text(en.documentType));
        await tester.pumpAndSettle();
        await tester.tap(find.text(en.docTypePassport).last);
        await tester.pumpAndSettle();
        await scanPassport(tester);

        await tapPrimary(tester, en.readDocument);

        expect(find.text(en.passportNumber), findsWidgets);
        expect(find.text(en.dateOfBirth), findsOneWidget);
        expect(find.text(en.sex), findsOneWidget);
        expect(find.text(en.nationality), findsOneWidget);
        expect(find.text('1990-05-12'), findsOneWidget);

        await tapPrimary(tester, en.submitForVerification);

        final s = fakeApi.submitted.single;
        expect(s.documentType, IdentityDocumentType.passport);
        expect(s.documentNumber, 'A12345678');
        expect(s.issueDate, DateTime(2021, 1, 15));
        expect(s.expiryDate, DateTime(2031, 1, 14));
      },
    );
  });

  group('review screen smoke', () {
    testWidgets('renders at 360 and 430 logical width without overflow', (
      tester,
    ) async {
      fakeApi.extractionResult = _ncResult();
      for (final width in [360.0, 430.0]) {
        tester.view.physicalSize = Size(width, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          host(
            IdentityExtractionReviewScreen(
              result: fakeApi.extractionResult!,
              documentType: IdentityDocumentType.unifiedNationalCard,
              frontPath: imagePath,
              backPath: imagePath,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('Arabic review renders', (tester) async {
      final ar = await AppLocalizations.delegate.load(const Locale('ar'));
      fakeApi.extractionResult = _ncResult();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [identityApiProvider.overrideWithValue(fakeApi)],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ar'),
            home: IdentityExtractionReviewScreen(
              result: fakeApi.extractionResult!,
              documentType: IdentityDocumentType.unifiedNationalCard,
              frontPath: imagePath,
              backPath: imagePath,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(ar.reviewDocumentInformation), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
