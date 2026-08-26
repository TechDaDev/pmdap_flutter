import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/features/identity/data/extraction_models.dart';

/// Regression fixtures for the backend V2 extraction response contract
/// (`IdentityExtractionResponseSerializer`). Values are SYNTHETIC — never
/// real patient data.
void main() {
  group('IdentityExtractionResult.fromJson (V2 National Card)', () {
    test('parses maternal name with all structured card fields', () {
      final json = <String, dynamic>{
        'document_type': 'UNIFIED_NATIONAL_CARD',
        'extractor_version': 'identity-v1',
        'fields': {
          'name': {
            'value': 'SYNTH NAME',
            'confidence': 0.96,
            'source': 'FRONT_PRINTED',
            'cross_check': null,
          },
          'father_name': {
            'value': 'SYNTH FATHER',
            'confidence': 0.94,
            'source': 'FRONT_PRINTED',
          },
          'grandfather_name': {
            'value': 'SYNTH GRANDFATHER',
            'confidence': 0.92,
            'source': 'FRONT_PRINTED',
          },
          'mother_name': {
            'value': 'SYNTH MOTHER',
            'confidence': 0.91,
            'source': 'FRONT_PRINTED',
          },
          'sex': {
            'value': 'MALE',
            'confidence': 0.96,
            'source': 'FRONT_PRINTED',
            'cross_check': 'MRZ_AGREE',
          },
          'blood_group': {'value': 'O+', 'confidence': 0.82, 'source': 'ROI'},
          'date_of_birth': {
            'value': '1990-01-15',
            'confidence': 0.94,
            'source': 'BACK_PRINTED',
            'cross_check': 'MRZ_AGREE',
          },
          'national_card_number': {
            'value': '999999999999',
            'confidence': 0.95,
            'source': 'FRONT_PRINTED',
          },
          'document_number': {
            'value': '999999999999',
            'confidence': 0.95,
            'source': 'FRONT_PRINTED',
          },
          'family_number': {
            'value': 'TESTFAMILY123456',
            'confidence': 0.8,
            'source': 'BACK_PRINTED',
          },
          'unique_card_body_number': {
            'value': 'H12345678',
            'confidence': 0.95,
            'source': 'FRONT_PRINTED',
          },
          'issuing_country': {
            'value': 'IQ',
            'confidence': 1.0,
            'source': 'DOCUMENT_TYPE',
          },
        },
        'warnings': <String>[],
        'mrz': {'detected': true, 'valid': true, 'checks_passed': true},
      };

      final r = IdentityExtractionResult.fromJson(json);

      expect(r.documentType, IdentityDocumentType.unifiedNationalCard);
      expect(r.mrzVerified, isTrue);

      // Typed accessors for the shared National Card fields.
      expect(r.name?.value, 'SYNTH NAME');
      expect(r.name?.source, IdentityExtractionSource.frontPrinted);
      expect(r.fatherName?.value, 'SYNTH FATHER');
      expect(r.grandfatherName?.value, 'SYNTH GRANDFATHER');
      expect(r.motherName?.value, 'SYNTH MOTHER');
      expect(r.sex?.value, 'MALE');
      expect(r.sex?.mrzAgree, isTrue);
      expect(r.bloodGroup?.value, 'O+');
      expect(r.bloodGroup?.source, IdentityExtractionSource.roi);
      expect(r.nationalCardNumber?.value, '999999999999');
      expect(r.dateOfBirth?.value, '1990-01-15');
      expect(r.dateOfBirth?.mrzAgree, isTrue);
      expect(r.familyNumber?.value, 'TESTFAMILY123456');
      expect(r.uniqueCardBodyNumber?.value, 'H12345678');
      expect(r.issuingCountry?.value, 'IQ');

      // Family number and card body number stay DISTINCT in the DTO.
      expect(r.familyNumber?.value, isNot(r.uniqueCardBodyNumber?.value));
      // national_card_number is never aliased into a "national number".
      expect(r.fields.containsKey('national_number'), isFalse);
    });

    test('missing optional fields parse safely to null', () {
      final json = <String, dynamic>{
        'document_type': 'UNIFIED_NATIONAL_CARD',
        'extractor_version': 'identity-v1',
        'fields': <String, dynamic>{},
        'warnings': <String>[],
        'mrz': {'detected': false, 'valid': false, 'checks_passed': false},
      };

      final r = IdentityExtractionResult.fromJson(json);

      expect(r.name, isNull);
      expect(r.fatherName, isNull);
      expect(r.grandfatherName, isNull);
      expect(r.motherName, isNull);
      expect(r.sex, isNull);
      expect(r.bloodGroup, isNull);
      expect(r.nationalCardNumber, isNull);
      expect(r.dateOfBirth, isNull);
      expect(r.familyNumber, isNull);
      expect(r.uniqueCardBodyNumber, isNull);
      expect(r.mrzVerified, isFalse);
    });

    test('unknown future fields never crash parsing', () {
      final json = <String, dynamic>{
        'document_type': 'UNIFIED_NATIONAL_CARD',
        'extractor_version': 'identity-v1',
        'fields': <String, dynamic>{
          'future_field': {'value': 'x', 'confidence': 0.5, 'source': 'ROI'},
        },
        'warnings': <String>['FUTURE_WARNING'],
        'mrz': <String, dynamic>{},
      };

      final r = IdentityExtractionResult.fromJson(json);
      expect(r.fields['future_field']?.value, 'x');
      expect(r.warnings, ['FUTURE_WARNING']);
      expect(r.name, isNull);
    });

    test('MRZ source and OCR source map to typed enum values', () {
      ExtractedIdentityField f(String source) =>
          ExtractedIdentityField.fromJson({
            'value': 'v',
            'confidence': 0.9,
            'source': source,
          });
      expect(f('MRZ').source, IdentityExtractionSource.mrz);
      expect(f('OCR').source, IdentityExtractionSource.ocr);
      expect(f('DOCUMENT_TYPE').source, IdentityExtractionSource.documentType);
      expect(f('DERIVED').source, IdentityExtractionSource.derived);
      expect(f('FRONT_PRINTED').source, IdentityExtractionSource.frontPrinted);
      expect(f('BACK_PRINTED').source, IdentityExtractionSource.backPrinted);
      expect(f('ROI').source, IdentityExtractionSource.roi);
      expect(f('SOMETHING_NEW').source, IdentityExtractionSource.unknown);
    });
  });
}
