import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/features/identity/data/extraction_models.dart';
import 'package:pmdap_mobile/features/minors/data/minor_identity_review.dart';

ExtractedIdentityField field(String value) =>
    ExtractedIdentityField(value: value);

void main() {
  test('maps Iraqi card identity fields independently', () {
    final result = IdentityExtractionResult(
      documentType: IdentityDocumentType.unifiedNationalCard,
      extractorVersion: 'synthetic-m28.1',
      fields: {
        'name': field('SyntheticGiven'),
        'father_name': field('SyntheticFather'),
        'grandfather_name': field('SyntheticGrandfather'),
        'mother_name': field('SyntheticMother'),
        'national_card_number': field('100000000001'),
        'unique_card_body_number': field('A10000001'),
        'family_number': field('SYNTH-FAMILY-100'),
      },
      mrz: const MrzValidationResult(),
    );

    final review = MinorIdentityReview.fromExtraction(result);

    expect(review.firstName, 'SyntheticGiven');
    expect(review.fatherName, 'SyntheticFather');
    expect(review.grandfatherName, 'SyntheticGrandfather');
    expect(review.motherName, 'SyntheticMother');
    expect(
      review.displayName,
      'SyntheticGiven SyntheticFather SyntheticGrandfather',
    );
    expect(review.nationalNumber, '100000000001');
    expect(review.cardBodyNumber, 'A10000001');
    expect(review.familyNumber, 'SYNTH-FAMILY-100');
  });
}
