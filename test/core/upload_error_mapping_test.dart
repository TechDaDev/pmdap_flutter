import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/api/api_exception.dart';
import 'package:pmdap_mobile/features/documents/presentation/document_upload_screen.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

void main() {
  AppLocalizations en() => lookupAppLocalizations(const Locale('en'));

  ApiException validation(Map<String, dynamic> details) => ApiException(
    code: 'validation_error',
    message: 'Validation failed.',
    statusCode: 400,
    details: details,
  );

  test('unsupported type message maps to clear text', () {
    final l10n = en();
    final e = validation({
      'file': ['Medical file must be PDF, JPEG, or PNG.'],
    });
    expect(mapUploadError(e, l10n), l10n.uploadFileTypeUnsupported);
  });

  test('size limit message maps to too-large text', () {
    final l10n = en();
    final e = validation({
      'file': ['Medical file exceeds the configured size limit.'],
    });
    expect(mapUploadError(e, l10n), l10n.uploadFileTooLarge);
  });

  test(
    'dimension message maps to image-too-large text (the real 41MP photo)',
    () {
      final l10n = en();
      final e = validation({
        'file': ['Medical image dimensions exceed the limit.'],
      });
      expect(mapUploadError(e, l10n), l10n.uploadImageTooLarge);
    },
  );

  test('malformed image message maps to corrupt-image text', () {
    final l10n = en();
    final e = validation({
      'file': ['Medical image content is malformed.'],
    });
    expect(mapUploadError(e, l10n), l10n.uploadImageCorrupt);
  });

  test('document_type error maps to select-type text', () {
    final l10n = en();
    final e = validation({
      'document_type': ['"X" is not a valid choice.'],
    });
    expect(mapUploadError(e, l10n), l10n.uploadInvalidDocumentType);
  });

  test('unmatched validation falls back to generic upload-failed text', () {
    final l10n = en();
    final e = validation({
      'unknown': ['some other error'],
    });
    expect(mapUploadError(e, l10n), l10n.uploadFailed);
  });

  test('non-validation errors keep the backend message', () {
    final l10n = en();
    const e = ApiException(code: 'network_error', message: 'Network error.');
    expect(mapUploadError(e, l10n), 'Network error.');
  });
}
