import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/utils/status_labels.dart';
import 'package:pmdap_mobile/core/widgets/status_badge.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  testWidgets('processing status maps to localized labels', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox()));
    final labels = StatusLabels(l10n);
    expect(
      labels.processing(ProcessingStatus.awaitingConfirmation),
      l10n.statusAwaitingConfirmation,
    );
    expect(
      labels.processing(ProcessingStatus.dateConfirmed),
      l10n.statusDateConfirmed,
    );
    expect(labels.processing(ProcessingStatus.failed), l10n.statusFailed);
    expect(labels.processing(ProcessingStatus.unknown), l10n.unknownStatus);
  });

  test('processing isActive is true only for active states', () {
    expect(ProcessingStatus.uploaded.isActive, isTrue);
    expect(ProcessingStatus.ocrProcessing.isActive, isTrue);
    expect(ProcessingStatus.awaitingConfirmation.isActive, isFalse);
    expect(ProcessingStatus.dateConfirmed.isActive, isFalse);
    expect(ProcessingStatus.failed.isActive, isFalse);
  });

  test('needsDateAction only when awaiting confirmation', () {
    expect(ProcessingStatus.awaitingConfirmation.needsDateAction, isTrue);
    expect(ProcessingStatus.dateConfirmed.needsDateAction, isFalse);
    expect(ProcessingStatus.uploaded.needsDateAction, isFalse);
  });

  test('processing tones never rely on color alone', () {
    final labels = StatusLabels(l10n);
    expect(
      labels.processingTone(ProcessingStatus.dateConfirmed),
      StatusTone.success,
    );
    expect(labels.processingTone(ProcessingStatus.failed), StatusTone.error);
    expect(
      labels.processingTone(ProcessingStatus.awaitingConfirmation),
      StatusTone.warning,
    );
  });

  test('identity state labels', () {
    final labels = StatusLabels(l10n);
    expect(
      labels.identityState(IdentityStatus.verified),
      l10n.identityVerified,
    );
    expect(
      labels.identityState(IdentityStatus.pendingVerification),
      l10n.identityPending,
    );
  });
}
