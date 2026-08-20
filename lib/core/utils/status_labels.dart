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
      case ProcessingStatus.duplicateDetected:
        return l10n.statusDuplicateDetected;
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

  /// Localized label for a medical document type (never the raw enum).
  String medicalDocumentTypeLabel(MedicalDocumentType t) {
    switch (t) {
      case MedicalDocumentType.laboratory:
        return l10n.typeLaboratory;
      case MedicalDocumentType.radiology:
        return l10n.typeRadiology;
      case MedicalDocumentType.prescription:
        return l10n.typePrescription;
      case MedicalDocumentType.consultation:
        return l10n.typeConsultation;
      case MedicalDocumentType.medicalReport:
        return l10n.typeMedicalReport;
      case MedicalDocumentType.hospitalAdmission:
        return l10n.typeHospitalAdmission;
      case MedicalDocumentType.dischargeSummary:
        return l10n.typeDischargeSummary;
      case MedicalDocumentType.surgeryProcedure:
        return l10n.typeSurgeryProcedure;
      case MedicalDocumentType.pathology:
        return l10n.typePathology;
      case MedicalDocumentType.vaccination:
        return l10n.typeVaccination;
      case MedicalDocumentType.vitalSigns:
        return l10n.typeVitalSigns;
      case MedicalDocumentType.other:
        return l10n.typeOther;
      case MedicalDocumentType.unknown:
        return l10n.unknownStatus;
    }
  }

  /// Localized label for a facility type (never the raw enum).
  String facilityTypeLabel(FacilityType t) {
    switch (t) {
      case FacilityType.hospital:
        return l10n.facilityHospital;
      case FacilityType.clinic:
        return l10n.facilityClinic;
      case FacilityType.laboratory:
        return l10n.facilityLaboratory;
      case FacilityType.radiologyCenter:
        return l10n.facilityRadiologyCenter;
      case FacilityType.pharmacy:
        return l10n.facilityPharmacy;
      case FacilityType.primaryCareCenter:
        return l10n.facilityPrimaryCareCenter;
      case FacilityType.specializedCenter:
        return l10n.facilitySpecializedCenter;
      case FacilityType.universityHospital:
        return l10n.facilityUniversityHospital;
      case FacilityType.other:
        return l10n.facilityOther;
      case FacilityType.unknown:
        return l10n.unknownStatus;
    }
  }

  /// Semantic badge for an identity-document verification status.
  StatusBadge verification(VerificationStatus s) {
    final label = verificationLabel(s);
    switch (s) {
      case VerificationStatus.verified:
        return StatusBadge.success(label: label);
      case VerificationStatus.pending:
        return StatusBadge.warning(label: label);
      case VerificationStatus.rejected:
        return StatusBadge.error(label: label);
      case VerificationStatus.unknown:
        return StatusBadge.neutral(label: label);
    }
  }

  /// Semantic badge for an identity-document lifecycle status.
  StatusBadge lifecycle(IdentityDocumentLifecycleStatus s) {
    final label = lifecycleLabel(s);
    switch (s) {
      case IdentityDocumentLifecycleStatus.current:
        return StatusBadge.success(label: label);
      case IdentityDocumentLifecycleStatus.expired:
        return StatusBadge.warning(label: label);
      case IdentityDocumentLifecycleStatus.replaced:
        return StatusBadge.neutral(label: label);
      case IdentityDocumentLifecycleStatus.revoked:
        return StatusBadge.error(label: label);
      case IdentityDocumentLifecycleStatus.unknown:
        return StatusBadge.neutral(label: label);
    }
  }

  String lifecycleLabel(IdentityDocumentLifecycleStatus s) {
    switch (s) {
      case IdentityDocumentLifecycleStatus.current:
        return l10n.lifecycleCurrent;
      case IdentityDocumentLifecycleStatus.expired:
        return l10n.lifecycleExpired;
      case IdentityDocumentLifecycleStatus.replaced:
        return l10n.lifecycleReplaced;
      case IdentityDocumentLifecycleStatus.revoked:
        return l10n.lifecycleRevoked;
      case IdentityDocumentLifecycleStatus.unknown:
        return l10n.unknownStatus;
    }
  }

  /// Semantic badge for file integrity state (corrupted/quarantined/missing).
  StatusBadge integrity(IntegrityStatus s) {
    switch (s) {
      case IntegrityStatus.corrupted:
        return StatusBadge.error(label: l10n.integrityCorrupted);
      case IntegrityStatus.quarantined:
        return StatusBadge.error(label: l10n.integrityQuarantined);
      case IntegrityStatus.missing:
        return StatusBadge.error(label: l10n.integrityMissing);
      case IntegrityStatus.pending:
        return StatusBadge.warning(label: l10n.integrityPending);
      case IntegrityStatus.valid:
        return StatusBadge.success(label: l10n.statusVerified);
      case IntegrityStatus.unknown:
        return StatusBadge.neutral(label: l10n.unknownStatus);
    }
  }
}
