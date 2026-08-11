import 'package:pmdap_mobile/l10n/app_localizations.dart';

import 'api_exception.dart';

/// Recursively extracts the first human message from a (possibly nested)
/// DRF validation `details` map. Never stringifies the whole body.
///
/// Handles: `"field": "msg"`, `"field": ["msg"]`,
/// `"field": {"nested": [...]}`, plus arbitrary list/depth nesting.
String? firstNestedMessage(Map<String, dynamic> details) {
  String? walk(dynamic node) {
    if (node is String && node.trim().isNotEmpty) return node;
    if (node is List) {
      for (final item in node) {
        final found = walk(item);
        if (found != null) return found;
      }
      return null;
    }
    if (node is Map) {
      for (final value in node.values) {
        final found = walk(value);
        if (found != null) return found;
      }
      return null;
    }
    return null;
  }

  for (final entry in details.entries) {
    final message = walk(entry.value);
    if (message != null) return '${entry.key}: $message';
  }
  return null;
}

/// Centralized safe presentation of known backend business errors.
///
/// Known codes get a localized patient-facing message (English + Arabic via
/// [AppLocalizations]); unknown codes fall back to the safe backend message
/// or the generic error. Raw `DioException` text is never shown.
class BusinessErrorMessages {
  const BusinessErrorMessages(this.l10n);

  final AppLocalizations l10n;

  /// Maps a typed error to the localization getter name (testable without
  /// an l10n instance), or null when the code is unknown/unhandled.
  static String? copyKeyFor(ApiException e) {
    if (e.isNetwork || e.isTimeout) return 'networkError';
    switch (e.code) {
      case 'guardian_not_verified':
        return 'guardianEligibilityTitle';
      case 'patient_not_minor':
        return 'dobUnder18';
      case 'relationship_evidence_required':
        return 'legalGuardianEvidenceRequired';
      case 'idempotency_key_required':
      case 'invalid_idempotency_key':
      case 'idempotency_conflict':
        return 'errorGeneric';
      case 'invalid_credentials':
        return 'invalidCredentials';
      case 'account_unavailable':
        return 'accountUnavailable';
      case 'not_authenticated':
        return 'sessionExpired';
      case 'throttled':
        return 'throttled';
      case 'not_found':
        return 'notFound';
      default:
        return null;
    }
  }

  String messageFor(ApiException e) {
    if (e.code == 'validation_error') {
      return firstNestedMessage(e.details) ?? l10n.validationFailed;
    }
    switch (copyKeyFor(e)) {
      case 'networkError':
        return l10n.networkError;
      case 'guardianEligibilityTitle':
        return l10n.guardianEligibilityTitle;
      case 'dobUnder18':
        return l10n.dobUnder18;
      case 'legalGuardianEvidenceRequired':
        return l10n.legalGuardianEvidenceRequired;
      case 'invalidCredentials':
        return l10n.invalidCredentials;
      case 'accountUnavailable':
        return l10n.accountUnavailable;
      case 'sessionExpired':
        return l10n.sessionExpired;
      case 'throttled':
        return l10n.throttled;
      case 'notFound':
        return l10n.notFound;
      case 'errorGeneric':
      case null:
        break;
    }
    // Unknown safe code: backend message is trusted, else generic.
    if (e.message.trim().isNotEmpty && !e.message.contains('DioException')) {
      return e.message;
    }
    return l10n.errorGeneric;
  }
}
