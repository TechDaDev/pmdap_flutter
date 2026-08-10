import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../models/enums.dart';
import '../widgets/status_badge.dart' show StatusBadge;

/// Central mapping from backend enums to localized StatusBadge widgets.
class StatusLabels {
  const StatusLabels(this.l10n);

  final AppLocalizations l10n;

  StatusBadge processing(ProcessingStatus s) {
    final label = processingLabel(s);
    switch (s) {
      case ProcessingStatus.dateConfirmed:
      case ProcessingStatus.indexed:
        return StatusBadge.success(label: label);
      case ProcessingStatus.failed:
        return StatusBadge.error(label: label);
      case ProcessingStatus.awaitingConfirmation:
        return StatusBadge.warning(label: label);
      default:
        return StatusBadge.info(label: label);
    }
  }

  StatusBadge identity(IdentityStatus s) {
    final label = identityLabel(s);
    switch (s) {
      case IdentityStatus.verified:
        return StatusBadge.success(label: label);
      case IdentityStatus.pendingVerification:
        return StatusBadge.warning(label: label);
      case IdentityStatus.rejected:
        return StatusBadge.error(label: label);
      case IdentityStatus.unverified:
      case IdentityStatus.unknown:
        return StatusBadge.neutral(label: label);
    }
  }

  String verificationLabel(VerificationStatus s) {
    switch (s) {
      case VerificationStatus.pending:
        return l10n.statusPending;
      case VerificationStatus.verified:
        return l10n.statusVerified;
      case VerificationStatus.rejected:
        return l10n.statusRejected;
      case VerificationStatus.unknown:
        return l10n.unknownStatus;
    }
  }

  String identityTypeLabel(IdentityDocumentType t) => _docTypeLabel(t);

  String processingLabel(ProcessingStatus s) {
    switch (s) {
      case ProcessingStatus.uploaded:
        return l10n.statusUploaded;
      case ProcessingStatus.queued:
        return l10n.statusQueued;
      case ProcessingStatus.processing:
        return l10n.statusProcessing;
      case ProcessingStatus.textExtracted:
        return l10n.statusTextExtracted;
      case ProcessingStatus.ocrRequired:
        return l10n.statusOcrRequired;
      case ProcessingStatus.ocrProcessing:
        return l10n.statusOcrProcessing;
      case ProcessingStatus.dateProcessing:
        return l10n.statusDateProcessing;
      case ProcessingStatus.dateDetected:
        return l10n.statusDateDetected;
      case ProcessingStatus.dateNotFound:
        return l10n.statusDateNotFound;
      case ProcessingStatus.awaitingConfirmation:
        return l10n.statusAwaitingConfirmation;
      case ProcessingStatus.dateConfirmed:
        return l10n.statusDateConfirmed;
      case ProcessingStatus.indexed:
        return l10n.statusIndexed;
      case ProcessingStatus.failed:
        return l10n.statusFailed;
      case ProcessingStatus.unknown:
        return l10n.unknownStatus;
    }
  }

  String identityLabel(IdentityStatus s) {
    switch (s) {
      case IdentityStatus.verified:
        return l10n.identityVerified;
      case IdentityStatus.unverified:
        return l10n.identityUnverified;
      case IdentityStatus.pendingVerification:
        return l10n.identityPending;
      case IdentityStatus.rejected:
        return l10n.identityRejected;
      case IdentityStatus.unknown:
        return l10n.unknownStatus;
    }
  }

  String relationshipLabel(Relationship r) {
    switch (r) {
      case Relationship.father:
        return l10n.father;
      case Relationship.mother:
        return l10n.mother;
      case Relationship.legalGuardian:
        return l10n.legalGuardian;
      case Relationship.unknown:
        return l10n.unknownStatus;
    }
  }

  String _docTypeLabel(IdentityDocumentType t) {
    switch (t) {
      case IdentityDocumentType.unifiedNationalCard:
        return l10n.docTypeNationalCard;
      case IdentityDocumentType.passport:
        return l10n.docTypePassport;
      case IdentityDocumentType.birthDocument:
        return l10n.docTypeBirth;
      case IdentityDocumentType.otherGovernmentId:
        return l10n.docTypeOtherGov;
      case IdentityDocumentType.unknown:
        return l10n.unknownStatus;
    }
  }
}
