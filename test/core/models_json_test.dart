import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/archive.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/identity.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/core/models/minor.dart';
import 'package:pmdap_mobile/core/models/patient.dart';
import 'package:pmdap_mobile/core/models/user.dart';

/// Regression tests: every API DTO must decode DRF **snake_case** keys.
/// A camelCase decoder silently produces empty/default fields.
void main() {
  group('PatientProfile (snake_case)', () {
    test('decodes the exact /patients/me/ response shape', () {
      final json = {
        'uuid': '0ed239cd-aaa2-4506-a3b9-20129e96eca0',
        'digital_id': 'PT-MK3T-G5VB-5573',
        'full_name': 'MOBILE APP TEST USER',
        'date_of_birth': '1995-05-05',
        'age': 31,
        'is_minor': false,
        'sex': 'UNSPECIFIED',
        'nationality': 'ZZ',
        'blood_group': 'O+',
        'identity_status': 'UNVERIFIED',
        'created_at': '2026-08-11T12:15:47.311921Z',
        'updated_at': '2026-08-11T12:15:47.311943Z',
      };

      final profile = PatientProfile.fromJson(json);

      expect(profile.uuid, '0ed239cd-aaa2-4506-a3b9-20129e96eca0');
      expect(profile.digitalId, 'PT-MK3T-G5VB-5573');
      expect(profile.fullName, 'MOBILE APP TEST USER');
      expect(profile.dateOfBirth, DateTime(1995, 5, 5));
      expect(profile.age, 31);
      expect(profile.isMinor, false);
      expect(profile.identityStatus, IdentityStatus.unverified);
      expect(profile.bloodGroup, BloodGroup.oPos);
      expect(profile.sex, Sex.unspecified);
      expect(profile.nationality, 'ZZ');
      expect(profile.createdAt, isNotNull);
      expect(profile.updatedAt, isNotNull);
      expect(profile.avatarUrl, isNull);
    });

    test('avatar_url null -> avatarUrl null', () {
      final profile = PatientProfile.fromJson({
        'uuid': 'u1',
        'digital_id': 'PT-AAAA-BBBB-0001',
        'full_name': 'A',
        'avatar_url': null,
      });
      expect(profile.avatarUrl, isNull);
    });

    test('avatar_url present -> avatarUrl contains authenticated path', () {
      final profile = PatientProfile.fromJson({
        'uuid': 'u1',
        'digital_id': 'PT-AAAA-BBBB-0001',
        'full_name': 'A',
        'avatar_url': '/api/v1/patients/me/avatar/',
      });
      expect(profile.avatarUrl, '/api/v1/patients/me/avatar/');
    });
  });

  group('Minor (snake_case)', () {
    test('decodes minor with nested guardian relationship', () {
      final json = {
        'uuid': 'm1',
        'digital_id': 'PT-AAAA-BBBB-0001',
        'full_name': 'Synthetic Child',
        'date_of_birth': '2015-08-20',
        'age': 10,
        'is_minor': true,
        'sex': 'UNSPECIFIED',
        'nationality': 'ZZ',
        'blood_group': 'O-',
        'identity_status': 'UNVERIFIED',
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-01-01T00:00:00Z',
        'relationship': {
          'uuid': 'r1',
          'relationship': 'FATHER',
          'verification_status': 'VERIFIED',
          'active': true,
          'started_at': '2026-01-01T00:00:00Z',
          'verified_at': '2026-01-02T00:00:00Z',
        },
      };

      final minor = Minor.fromJson(json);

      expect(minor.digitalId, 'PT-AAAA-BBBB-0001');
      expect(minor.fullName, 'Synthetic Child');
      expect(minor.dateOfBirth, DateTime(2015, 8, 20));
      expect(minor.isMinor, true);
      expect(minor.identityStatus, IdentityStatus.unverified);
      expect(minor.bloodGroup, BloodGroup.oNeg);

      final rel = minor.relationship;
      expect(rel, isNotNull);
      expect(rel!.relationship, Relationship.father);
      expect(rel.verificationStatus, VerificationStatus.verified);
      expect(rel.active, true);
      expect(rel.startedAt, DateTime.utc(2026, 1, 1));
      expect(rel.verifiedAt, DateTime.utc(2026, 1, 2));
    });

    test('decodes GuardianRelationship standalone snake_case', () {
      final rel = GuardianRelationship.fromJson({
        'uuid': 'r1',
        'relationship': 'MOTHER',
        'verification_status': 'PENDING',
        'active': true,
        'started_at': '2026-01-01T00:00:00Z',
        'verified_at': null,
        'ended_at': null,
        'ended_reason': null,
      });

      expect(rel.relationship, Relationship.mother);
      expect(rel.verificationStatus, VerificationStatus.pending);
      expect(rel.endedReason, isNull);
    });
  });

  group('MedicalDocument (snake_case)', () {
    test('decodes list-item shape', () {
      final doc = MedicalDocument.fromJson({
        'uuid': 'd1',
        'document_type': 'LABORATORY',
        'classification_source': 'SYSTEM_DEFAULT',
        'title': 'Lab Report',
        'description': '',
        'document_date': '2026-03-15',
        'date_source': 'USER_CONFIRMED',
        'date_verified': true,
        'date_verified_at': '2026-03-16T00:00:00Z',
        'facility_name': 'Central Lab',
        'location_text': '',
        'department': 'Hematology',
        'physician_name': 'Dr. X',
        'processing_status': 'DATE_CONFIRMED',
        'archive_status': 'ACTIVE',
        'created_at': '2026-03-15T00:00:00Z',
        'updated_at': '2026-03-16T00:00:00Z',
        'file': {
          'original_filename': 'lab.pdf',
          'mime_type': 'application/pdf',
          'size_bytes': 1024,
          'page_count': 1,
          'integrity_status': 'VALID',
          'malware_scan_status': 'CLEAN',
        },
      });

      expect(doc.uuid, 'd1');
      expect(doc.documentType, MedicalDocumentType.laboratory);
      expect(doc.title, 'Lab Report');
      expect(doc.documentDate, DateTime(2026, 3, 15));
      expect(doc.dateSource, DateSource.userConfirmed);
      expect(doc.dateVerified, true);
      expect(doc.processingStatus, ProcessingStatus.dateConfirmed);
      expect(doc.archiveStatus, ArchiveStatus.active);
      expect(doc.file, isNotNull);
      expect(doc.file!.originalFilename, 'lab.pdf');
      expect(doc.file!.mimeType, 'application/pdf');
      expect(doc.file!.sizeBytes, 1024);
      expect(doc.file!.integrityStatus, IntegrityStatus.valid);
      expect(doc.file!.malwareScanStatus, MalwareScanStatus.clean);
    });
  });

  group('IdentityDocumentDetail (snake_case)', () {
    test('decodes detail shape', () {
      final doc = IdentityDocumentDetail.fromJson({
        'uuid': 'id1',
        'document_type': 'PASSPORT',
        'issuing_country': 'IQ',
        'issue_date': '2020-01-01',
        'expiry_date': '2030-01-01',
        'verification_status': 'VERIFIED',
        'status': 'CURRENT',
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-01-01T00:00:00Z',
        'document_number': 'P123456',
        'national_number': '',
        'family_number': '',
        'verified_at': '2026-01-02T00:00:00Z',
        'rejection_reason': '',
        'available_images': ['front', 'back'],
        'replaces': null,
      });

      expect(doc.documentType, IdentityDocumentType.passport);
      expect(doc.issuingCountry, 'IQ');
      expect(doc.issueDate, DateTime(2020, 1, 1));
      expect(doc.expiryDate, DateTime(2030, 1, 1));
      expect(doc.verificationStatus, VerificationStatus.verified);
      expect(doc.status, IdentityDocumentLifecycleStatus.current);
      expect(doc.documentNumber, 'P123456');
      expect(doc.availableImages, ['front', 'back']);
    });
  });

  group('Archive (snake_case)', () {
    test('decodes archive document shape', () {
      final doc = ArchiveDocument.fromJson({
        'uuid': 'a1',
        'title': 'Consultation Report',
        'document_type': 'CONSULTATION',
        'document_date': '2023-11-02',
        'date_verified': false,
        'date_source': 'OCR',
        'healthcare_facility': {'uuid': 'f1', 'name': 'City Clinic'},
        'facility_name': 'City Clinic',
        'location_text': '',
        'department': 'General',
        'physician_name': 'Dr. Y',
        'processing_status': 'AWAITING_CONFIRMATION',
        'created_at': '2023-11-02T00:00:00Z',
      });

      expect(doc.documentType, MedicalDocumentType.consultation);
      expect(doc.documentDate, DateTime(2023, 11, 2));
      expect(doc.dateSource, DateSource.ocr);
      expect(doc.healthcareFacility?.name, 'City Clinic');
      expect(doc.processingStatus, ProcessingStatus.awaitingConfirmation);
    });

    test('decodes archive summary shape', () {
      final summary = ArchiveSummary.fromJson({
        'years': [
          {
            'year': 2026,
            'count': 2,
            'months': [
              {'month': 3, 'count': 2},
            ],
          },
        ],
        'document_types': [
          {'document_type': 'LABORATORY', 'count': 2},
        ],
        'facilities': [
          {'uuid': 'f1', 'name': 'City Clinic', 'count': 2},
        ],
        'unconfirmed_date_count': 1,
      });

      expect(summary.years, hasLength(1));
      expect(summary.years.first.year, 2026);
      expect(summary.years.first.months.first.month, 3);
      expect(
        summary.documentTypes.first.documentType,
        MedicalDocumentType.laboratory,
      );
      expect(summary.facilities.first.name, 'City Clinic');
      expect(summary.unconfirmedDateCount, 1);
    });
  });

  group('PublicUser (snake_case)', () {
    test('decodes /auth/me/ shape', () {
      final user = PublicUser.fromJson({
        'uuid': 'u1',
        'email': 'test@example.com',
        'phone': '+9647000000000',
        'role': 'PATIENT',
        'email_verified': true,
        'phone_verified': false,
        'created_at': '2026-01-01T00:00:00Z',
      });

      expect(user.email, 'test@example.com');
      expect(user.phone, '+9647000000000');
      expect(user.role, Role.patient);
      expect(user.emailVerified, true);
      expect(user.phoneVerified, false);
    });
  });
}
