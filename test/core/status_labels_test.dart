import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/utils/status_labels.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  test('processing label returns non-empty string', () {
    final labels = StatusLabels(l10n);
    expect(
      labels.processingLabel(ProcessingStatus.awaitingConfirmation),
      contains('confirmation'),
    );
    expect(labels.processingLabel(ProcessingStatus.failed), contains('Fail'));
  });

  test('identity label returns non-empty string', () {
    final labels = StatusLabels(l10n);
    expect(labels.identityLabel(IdentityStatus.verified), contains('Verif'));
  });

  test('processing returns StatusBadge', () {
    final labels = StatusLabels(l10n);
    final badge = labels.processing(ProcessingStatus.dateConfirmed);
    expect(badge, isNotNull);
  });

  test('isActive / needsDateAction unchanged', () {
    expect(ProcessingStatus.uploaded.isActive, isTrue);
    expect(ProcessingStatus.awaitingConfirmation.isActive, isFalse);
    expect(ProcessingStatus.awaitingConfirmation.needsDateAction, isTrue);
  });
}
