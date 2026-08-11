import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/theme/app_theme.dart';
import 'package:pmdap_mobile/features/documents/presentation/document_upload_screen.dart';
import 'package:pmdap_mobile/features/identity/presentation/identity_submit_screen.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

/// P0 regression: upload + identity forms must render their BODY (not just the
/// AppBar) in both light and dark themes.
void main() {
  Widget harness(Widget child, {required Brightness brightness}) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }

  for (final brightness in [Brightness.light, Brightness.dark]) {
    final label = brightness == Brightness.light ? 'light' : 'dark';

    testWidgets('UploadDocumentScreen body visible ($label)', (tester) async {
      await tester.pumpWidget(
        harness(const DocumentUploadScreen(), brightness: brightness),
      );
      await tester.pumpAndSettle();

      expect(find.text('Upload document'), findsOneWidget); // AppBar
      // BODY — not just the AppBar.
      expect(find.text('Document type'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Choose existing file'), findsWidgets);
      expect(find.text('Upload'), findsOneWidget);
    });

    testWidgets('IdentitySubmitScreen body visible ($label)', (tester) async {
      await tester.pumpWidget(
        harness(const IdentitySubmitScreen(), brightness: brightness),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add identity document'), findsOneWidget); // AppBar
      // BODY.
      expect(find.text('Document type'), findsOneWidget);
      expect(find.text('Document number'), findsOneWidget);
      expect(find.text('National number'), findsOneWidget);
      expect(find.text('Front image'), findsOneWidget);
      expect(find.text('Submit document'), findsOneWidget);
    });
  }
}
