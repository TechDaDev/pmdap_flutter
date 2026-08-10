import 'package:pmdap_mobile/core/models/archive.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/core/models/minor.dart';
import 'package:pmdap_mobile/core/models/patient.dart';

PatientProfile sampleProfile({
  String uuid = 'p1',
  IdentityStatus status = IdentityStatus.verified,
}) {
  return PatientProfile(
    uuid: uuid,
    digitalId: '12345678901234567',
    fullName: 'Synthetic Patient',
    dateOfBirth: DateTime(1990, 5, 10),
    age: 36,
    isMinor: false,
    sex: Sex.male,
    nationality: 'IQ',
    bloodGroup: BloodGroup.aPos,
    identityStatus: status,
  );
}

MedicalDocument sampleDocument({
  String uuid = 'd1',
  String title = 'Lab Report',
  ProcessingStatus processing = ProcessingStatus.dateConfirmed,
  MedicalDocumentType type = MedicalDocumentType.laboratory,
  DateTime? date,
  bool verified = true,
}) {
  return MedicalDocument(
    uuid: uuid,
    documentType: type,
    classificationSource: ClassificationSource.systemDefault,
    title: title,
    description: 'Synthetic report',
    documentDate: date ?? DateTime(2024, 3, 15),
    dateSource: DateSource.userConfirmed,
    dateVerified: verified,
    facilityName: 'Central Lab',
    locationText: '',
    department: 'Hematology',
    physicianName: 'Dr. X',
    processingStatus: processing,
    archiveStatus: ArchiveStatus.active,
    file: StoredFilePublic(
      originalFilename: 'lab.pdf',
      mimeType: 'application/pdf',
      sizeBytes: 1024,
      integrityStatus: IntegrityStatus.valid,
      malwareScanStatus: MalwareScanStatus.clean,
    ),
  );
}

MedicalDocumentDetail sampleDocumentDetail({
  String uuid = 'd1',
  ProcessingStatus processing = ProcessingStatus.awaitingConfirmation,
}) {
  return MedicalDocumentDetail(
    uuid: uuid,
    documentType: MedicalDocumentType.laboratory,
    classificationSource: ClassificationSource.systemDefault,
    title: 'Lab Report',
    description: 'Synthetic',
    documentDate: DateTime(2024, 3, 15),
    dateSource: DateSource.ocr,
    dateVerified: false,
    facilityName: 'Central Lab',
    locationText: '',
    department: 'Hematology',
    physicianName: 'Dr. X',
    processingStatus: processing,
    archiveStatus: ArchiveStatus.active,
    file: StoredFilePublic(
      originalFilename: 'lab.pdf',
      mimeType: 'application/pdf',
      sizeBytes: 1024,
      integrityStatus: IntegrityStatus.valid,
      malwareScanStatus: MalwareScanStatus.clean,
    ),
    textAvailable: false,
  );
}

ArchiveDocument sampleArchiveDocument({
  String uuid = 'a1',
  bool verified = true,
  ProcessingStatus processing = ProcessingStatus.dateConfirmed,
}) {
  return ArchiveDocument(
    uuid: uuid,
    title: 'Archive Report',
    documentType: MedicalDocumentType.consultation,
    documentDate: DateTime(2023, 11, 2),
    dateVerified: verified,
    dateSource: verified ? DateSource.userConfirmed : DateSource.ocr,
    healthcareFacility: const ArchiveFacilitySummary(
      uuid: 'f1',
      name: 'City Clinic',
    ),
    facilityName: 'City Clinic',
    locationText: '',
    department: 'General',
    physicianName: 'Dr. Y',
    processingStatus: processing,
  );
}

Minor sampleMinor({
  String uuid = 'm1',
  IdentityStatus status = IdentityStatus.pendingVerification,
}) {
  return Minor(
    uuid: uuid,
    digitalId: '98765432101234567',
    fullName: 'Synthetic Child',
    dateOfBirth: DateTime(2015, 8, 20),
    age: 10,
    isMinor: true,
    sex: Sex.female,
    nationality: 'IQ',
    bloodGroup: BloodGroup.oPos,
    identityStatus: status,
    relationship: GuardianRelationship(
      uuid: 'r1',
      relationship: Relationship.father,
      verificationStatus: VerificationStatus.verified,
      active: true,
    ),
  );
}
