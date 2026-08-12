import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/identity.dart';

/// Regression fixture for [IdentityDocumentDetail] parsing.
///
/// Mirrors the EXACT field names/structure of the backend 201 response from
/// `POST /api/v1/identity-documents/` (see backend
/// IdentityDocumentDetailSerializer). Values are SYNTHETIC — never real
/// patient data.
void main() {
  group('IdentityDocumentDetail.fromJson (backend 201 fixture)', () {
    test('parses a full National Card response', () {
      final json = <String, dynamic>{
        'uuid': '8d48f4a1-2c30-4e72-9b31-1f2a3b4c5d6e',
        'document_type': 'UNIFIED_NATIONAL_CARD',
        'issuing_country': 'IQ',
        'issue_date': '2022-01-01',
        'expiry_date': '2032-01-01',
        'verification_status': 'PENDING',
        'status': 'CURRENT',
        'created_at': '2026-08-12T10:00:00Z',
        'updated_at': '2026-08-12T10:00:00Z',
        'document_number': 'CARD-0000-SYNTH',
        'national_number': 'NN-0000-SYNTH',
        'family_number': 'FN-0000-SYNTH',
        'verified_at': null,
        'rejection_reason': '',
        'available_images': <String>['front', 'back'],
        'replaces': null,
      };

      final doc = IdentityDocumentDetail.fromJson(json);

      expect(doc.uuid, '8d48f4a1-2c30-4e72-9b31-1f2a3b4c5d6e');
      expect(doc.documentType, IdentityDocumentType.unifiedNationalCard);
      expect(doc.verificationStatus, VerificationStatus.pending);
      expect(doc.status, IdentityDocumentLifecycleStatus.current);
      expect(doc.issuingCountry, 'IQ');
      expect(doc.documentNumber, 'CARD-0000-SYNTH');
      expect(doc.nationalNumber, 'NN-0000-SYNTH');
      expect(doc.familyNumber, 'FN-0000-SYNTH');
      expect(doc.availableImages, ['front', 'back']);
      expect(doc.verifiedAt, isNull);
      expect(doc.replaces, isNull);
    });

    test('parses a Passport response with replaces uuid', () {
      final json = <String, dynamic>{
        'uuid': '7c39e0b2-1d20-4e61-8a20-2e4f5a6b7c8d',
        'document_type': 'PASSPORT',
        'issuing_country': 'IQ',
        'issue_date': '2024-01-01',
        'expiry_date': '2034-01-01',
        'verification_status': 'VERIFIED',
        'status': 'CURRENT',
        'created_at': '2026-08-12T10:00:00Z',
        'updated_at': '2026-08-12T10:00:00Z',
        'document_number': 'P-0000-SYNTH',
        'national_number': '',
        'family_number': '',
        'verified_at': '2026-08-12T11:00:00Z',
        'rejection_reason': '',
        'available_images': <String>['front'],
        'replaces': '8d48f4a1-2c30-4e72-9b31-1f2a3b4c5d6e',
      };

      final doc = IdentityDocumentDetail.fromJson(json);

      expect(doc.documentType, IdentityDocumentType.passport);
      expect(doc.verificationStatus, VerificationStatus.verified);
      expect(doc.availableImages, ['front']);
      expect(doc.replaces, '8d48f4a1-2c30-4e72-9b31-1f2a3b4c5d6e');
    });

    test('missing optional fields default safely', () {
      final json = <String, dynamic>{
        'uuid': '5b2a1c90-0e1f-4a3b-9c2d-1f0e2d3c4b5a',
        'document_type': 'UNIFIED_NATIONAL_CARD',
        'verification_status': 'PENDING',
        'status': 'CURRENT',
      };

      final doc = IdentityDocumentDetail.fromJson(json);

      expect(doc.uuid, '5b2a1c90-0e1f-4a3b-9c2d-1f0e2d3c4b5a');
      expect(doc.documentNumber, '');
      expect(doc.nationalNumber, '');
      expect(doc.familyNumber, '');
      expect(doc.availableImages, isEmpty);
      expect(doc.issueDate, isNull);
      expect(doc.verifiedAt, isNull);
    });
  });

  group('IdentityDocumentSummary.fromJson (list item)', () {
    test('parses a summary row', () {
      final json = <String, dynamic>{
        'uuid': '5b2a1c90-0e1f-4a3b-9c2d-1f0e2d3c4b5a',
        'document_type': 'UNIFIED_NATIONAL_CARD',
        'issuing_country': 'IQ',
        'issue_date': null,
        'expiry_date': null,
        'verification_status': 'PENDING',
        'status': 'CURRENT',
        'created_at': '2026-08-12T10:00:00Z',
        'updated_at': '2026-08-12T10:00:00Z',
      };

      final doc = IdentityDocumentSummary.fromJson(json);

      expect(doc.documentType, IdentityDocumentType.unifiedNationalCard);
      expect(doc.verificationStatus, VerificationStatus.pending);
      expect(doc.status, IdentityDocumentLifecycleStatus.current);
      expect(doc.issuingCountry, 'IQ');
    });
  });
}
