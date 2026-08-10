/// Backend enum values, preserving exact API strings.
///
/// Every enum has [fromApi] which maps a backend string to a value and falls
/// back to an `unknown` sentinel for forward-compatible values we have not
/// seen yet. [api] returns the exact backend string.
library;

enum Role {
  patient('PATIENT'),
  identityVerificationAgent('IDENTITY_VERIFICATION_AGENT'),
  admin('ADMIN'),
  unknown('UNKNOWN');

  final String api;
  const Role(this.api);
  static Role fromApi(String? s) =>
      Role.values.firstWhere((e) => e.api == s, orElse: () => unknown);
  bool get isPatient => this == patient;
}

enum IdentityStatus {
  unverified('UNVERIFIED'),
  pendingVerification('PENDING_VERIFICATION'),
  verified('VERIFIED'),
  rejected('REJECTED'),
  unknown('UNKNOWN');

  final String api;
  const IdentityStatus(this.api);
  static IdentityStatus fromApi(String? s) => IdentityStatus.values.firstWhere(
    (e) => e.api == s,
    orElse: () => unknown,
  );
}

enum VerificationStatus {
  pending('PENDING'),
  verified('VERIFIED'),
  rejected('REJECTED'),
  unknown('UNKNOWN');

  final String api;
  const VerificationStatus(this.api);
  static VerificationStatus fromApi(String? s) => VerificationStatus.values
      .firstWhere((e) => e.api == s, orElse: () => unknown);
}

enum IdentityDocumentType {
  unifiedNationalCard('UNIFIED_NATIONAL_CARD'),
  passport('PASSPORT'),
  birthDocument('BIRTH_DOCUMENT'),
  otherGovernmentId('OTHER_GOVERNMENT_ID'),
  unknown('UNKNOWN');

  final String api;
  const IdentityDocumentType(this.api);
  static IdentityDocumentType fromApi(String? s) => IdentityDocumentType.values
      .firstWhere((e) => e.api == s, orElse: () => unknown);
}

enum IdentityDocumentLifecycleStatus {
  current('CURRENT'),
  expired('EXPIRED'),
  replaced('REPLACED'),
  revoked('REVOKED'),
  unknown('UNKNOWN');

  final String api;
  const IdentityDocumentLifecycleStatus(this.api);
  static IdentityDocumentLifecycleStatus fromApi(String? s) =>
      IdentityDocumentLifecycleStatus.values.firstWhere(
        (e) => e.api == s,
        orElse: () => unknown,
      );
}

enum MedicalDocumentType {
  laboratory('LABORATORY'),
  radiology('RADIOLOGY'),
  prescription('PRESCRIPTION'),
  consultation('CONSULTATION'),
  medicalReport('MEDICAL_REPORT'),
  hospitalAdmission('HOSPITAL_ADMISSION'),
  dischargeSummary('DISCHARGE_SUMMARY'),
  surgeryProcedure('SURGERY_PROCEDURE'),
  pathology('PATHOLOGY'),
  vaccination('VACCINATION'),
  vitalSigns('VITAL_SIGNS'),
  other('OTHER'),
  unknown('UNKNOWN');

  final String api;
  const MedicalDocumentType(this.api);
  static MedicalDocumentType fromApi(String? s) => MedicalDocumentType.values
      .firstWhere((e) => e.api == s, orElse: () => unknown);
}

enum ProcessingStatus {
  uploaded('UPLOADED'),
  queued('QUEUED'),
  processing('PROCESSING'),
  textExtracted('TEXT_EXTRACTED'),
  ocrRequired('OCR_REQUIRED'),
  ocrProcessing('OCR_PROCESSING'),
  dateProcessing('DATE_PROCESSING'),
  dateDetected('DATE_DETECTED'),
  dateNotFound('DATE_NOT_FOUND'),
  awaitingConfirmation('AWAITING_CONFIRMATION'),
  dateConfirmed('DATE_CONFIRMED'),
  indexed('INDEXED'),
  failed('FAILED'),
  unknown('UNKNOWN');

  final String api;
  const ProcessingStatus(this.api);
  static ProcessingStatus fromApi(String? s) => ProcessingStatus.values
      .firstWhere((e) => e.api == s, orElse: () => unknown);

  /// Whether the document detail should still be polled.
  bool get isActive {
    switch (this) {
      case uploaded:
      case queued:
      case processing:
      case textExtracted:
      case ocrRequired:
      case ocrProcessing:
      case dateProcessing:
      case dateDetected:
        return true;
      case dateNotFound:
      case awaitingConfirmation:
      case dateConfirmed:
      case indexed:
      case failed:
      case unknown:
        return false;
    }
  }

  bool get needsDateAction => this == awaitingConfirmation;
}

enum DateSource {
  userEntered('USER_ENTERED'),
  pdfText('PDF_TEXT'),
  ocr('OCR'),
  userConfirmed('USER_CONFIRMED'),
  userCorrected('USER_CORRECTED'),
  unknown('UNKNOWN');

  final String api;
  const DateSource(this.api);
  static DateSource fromApi(String? s) =>
      DateSource.values.firstWhere((e) => e.api == s, orElse: () => unknown);
}

enum ArchiveStatus {
  active('ACTIVE'),
  deleted('DELETED'),
  unknown('UNKNOWN');

  final String api;
  const ArchiveStatus(this.api);
  static ArchiveStatus fromApi(String? s) =>
      ArchiveStatus.values.firstWhere((e) => e.api == s, orElse: () => unknown);
}

enum ClassificationSource {
  userSelected('USER_SELECTED'),
  guardianSelected('GUARDIAN_SELECTED'),
  systemDefault('SYSTEM_DEFAULT'),
  unknown('UNKNOWN');

  final String api;
  const ClassificationSource(this.api);
  static ClassificationSource fromApi(String? s) => ClassificationSource.values
      .firstWhere((e) => e.api == s, orElse: () => unknown);
}

enum Sex {
  female('FEMALE'),
  male('MALE'),
  unspecified('UNSPECIFIED'),
  unknown('UNKNOWN');

  final String api;
  const Sex(this.api);
  static Sex fromApi(String? s) =>
      Sex.values.firstWhere((e) => e.api == s, orElse: () => unknown);
}

enum BloodGroup {
  aPos('A+'),
  aNeg('A-'),
  bPos('B+'),
  bNeg('B-'),
  abPos('AB+'),
  abNeg('AB-'),
  oPos('O+'),
  oNeg('O-'),
  unknown('UNKNOWN');

  final String api;
  const BloodGroup(this.api);
  static BloodGroup fromApi(String? s) =>
      BloodGroup.values.firstWhere((e) => e.api == s, orElse: () => unknown);
}

enum Relationship {
  father('FATHER'),
  mother('MOTHER'),
  legalGuardian('LEGAL_GUARDIAN'),
  unknown('UNKNOWN');

  final String api;
  const Relationship(this.api);
  static Relationship fromApi(String? s) =>
      Relationship.values.firstWhere((e) => e.api == s, orElse: () => unknown);
}

enum FacilityType {
  hospital('HOSPITAL'),
  clinic('CLINIC'),
  laboratory('LABORATORY'),
  radiologyCenter('RADIOLOGY_CENTER'),
  pharmacy('PHARMACY'),
  primaryCareCenter('PRIMARY_CARE_CENTER'),
  specializedCenter('SPECIALIZED_CENTER'),
  universityHospital('UNIVERSITY_HOSPITAL'),
  other('OTHER'),
  unknown('UNKNOWN');

  final String api;
  const FacilityType(this.api);
  static FacilityType fromApi(String? s) =>
      FacilityType.values.firstWhere((e) => e.api == s, orElse: () => unknown);
}

enum IntegrityStatus {
  pending('PENDING'),
  valid('VALID'),
  corrupted('CORRUPTED'),
  quarantined('QUARANTINED'),
  missing('MISSING'),
  unknown('UNKNOWN');

  final String api;
  const IntegrityStatus(this.api);
  static IntegrityStatus fromApi(String? s) => IntegrityStatus.values
      .firstWhere((e) => e.api == s, orElse: () => unknown);
}

enum MalwareScanStatus {
  notConfigured('NOT_CONFIGURED'),
  clean('CLEAN'),
  infected('INFECTED'),
  error('ERROR'),
  unknown('UNKNOWN');

  final String api;
  const MalwareScanStatus(this.api);
  static MalwareScanStatus fromApi(String? s) => MalwareScanStatus.values
      .firstWhere((e) => e.api == s, orElse: () => unknown);
}

enum Source {
  pdfText('PDF_TEXT'),
  ocr('OCR'),
  unknown('UNKNOWN');

  final String api;
  const Source(this.api);
  static Source fromApi(String? s) =>
      Source.values.firstWhere((e) => e.api == s, orElse: () => unknown);
}

enum AccountClaimStatus {
  pending('PENDING'),
  underReview('UNDER_REVIEW'),
  moreInformationRequired('MORE_INFORMATION_REQUIRED'),
  approved('APPROVED'),
  rejected('REJECTED'),
  cancelled('CANCELLED'),
  unknown('UNKNOWN');

  final String api;
  const AccountClaimStatus(this.api);
  static AccountClaimStatus fromApi(String? s) => AccountClaimStatus.values
      .firstWhere((e) => e.api == s, orElse: () => unknown);
}

enum EvidenceType {
  legalGuardianshipDocument('LEGAL_GUARDIANSHIP_DOCUMENT'),
  courtDocument('COURT_DOCUMENT'),
  otherOfficialEvidence('OTHER_OFFICIAL_EVIDENCE'),
  unknown('UNKNOWN');

  final String api;
  const EvidenceType(this.api);
  static EvidenceType fromApi(String? s) =>
      EvidenceType.values.firstWhere((e) => e.api == s, orElse: () => unknown);
}
