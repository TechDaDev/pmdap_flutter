import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/features/documents/presentation/document_upload_screen.dart';
import 'package:pmdap_mobile/features/documents/scanner/document_scanner.dart';
import 'package:pmdap_mobile/features/identity/presentation/identity_submit_screen.dart';

import '../helpers/pump.dart';

/// Document scanner + simplified upload milestone tests.
void main() {
  const channel = MethodChannel('pmdap/document_scanner');

  void mockScanner(Future<Object?> Function(MethodCall) handler) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, handler);
  }

  group('scanner wrapper', () {
    testWidgets('unavailable platform error -> ScannerUnavailableException', (
      tester,
    ) async {
      mockScanner((call) async => throw PlatformException(code: 'unavailable'));
      await expectLater(
        scanDocument(),
        throwsA(isA<ScannerUnavailableException>()),
      );
    });

    testWidgets('scan success returns pages + pdf', (tester) async {
      mockScanner(
        (call) async => {
          'pages': ['/tmp/page_0.jpg', '/tmp/page_1.jpg'],
          'pdf': '/tmp/scan.pdf',
          'pageCount': 2,
        },
      );
      final result = await scanDocument();
      expect(result.cancelled, isFalse);
      expect(result.pagePaths.length, 2);
      expect(result.pdfPath, '/tmp/scan.pdf');
      expect(result.pageCount, 2);
    });

    testWidgets('user cancellation -> empty result, not an error', (
      tester,
    ) async {
      mockScanner((call) async => {'cancelled': true});
      final result = await scanDocument();
      expect(result.cancelled, isTrue);
    });
  });

  group('upload screen', () {
    Future<void> pumpUpload(WidgetTester tester, {double width = 390}) async {
      tester.view.physicalSize = Size(width * 3, 800 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(pumpApp(const DocumentUploadScreen()));
      await tester.pumpAndSettle();
    }

    FilledButton uploadButton(WidgetTester tester) =>
        tester.widget<FilledButton>(
          find
              .ancestor(
                of: find.text('Upload'),
                matching: find.byType(FilledButton),
              )
              .first,
        );

    testWidgets('upload disabled until source + type chosen', (tester) async {
      await pumpUpload(tester);
      expect(uploadButton(tester).onPressed, isNull);

      // Selecting a type alone still leaves upload disabled (no source).
      await tester.tap(
        find.byType(DropdownButtonFormField<MedicalDocumentType>),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Laboratory').last);
      await tester.pumpAndSettle();
      expect(uploadButton(tester).onPressed, isNull);
    });

    testWidgets('scanner unsupported shows fallback message, no crash', (
      tester,
    ) async {
      mockScanner((call) async => throw PlatformException(code: 'unavailable'));
      await pumpUpload(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Scan document'));
      await tester.pumpAndSettle();
      expect(
        find.text('Document scanning is not available on this device.'),
        findsOneWidget,
      );
      // App still usable — choose-file action remains.
      expect(find.text('Choose existing file'), findsOneWidget);
    });

    testWidgets('scan result populates source summary', (tester) async {
      mockScanner(
        (call) async => {
          'pages': ['/tmp/page_0.jpg', '/tmp/page_1.jpg'],
          'pdf': '/tmp/scan.pdf',
          'pageCount': 2,
        },
      );
      await pumpUpload(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Scan document'));
      await tester.pumpAndSettle();

      expect(find.text('Scanned document'), findsOneWidget);
      expect(find.text('2 pages'), findsOneWidget);
      expect(find.text('Rescan'), findsOneWidget);
    });

    for (final width in [360.0, 390.0, 430.0]) {
      testWidgets('no overflow at ${width.toInt()}dp', (tester) async {
        await pumpUpload(tester, width: width);
        expect(find.text('Scan document'), findsWidgets);
        expect(find.text('Advanced details'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('identity submit word wrapping', () {
    for (final width in [360.0, 430.0]) {
      testWidgets('no overflow at ${width.toInt()}dp', (tester) async {
        tester.view.physicalSize = Size(width * 3, 800 * 3);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(pumpApp(const IdentitySubmitScreen()));
        await tester.pumpAndSettle();
        expect(find.text('Front image'), findsOneWidget);
        expect(find.text('Back image'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
