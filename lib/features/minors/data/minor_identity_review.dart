import '../../identity/data/extraction_models.dart';

class MinorIdentityReview {
  const MinorIdentityReview({
    this.firstName = '',
    this.fatherName = '',
    this.grandfatherName = '',
    this.motherName = '',
    this.nationalNumber = '',
    this.cardBodyNumber = '',
    this.familyNumber = '',
  });

  final String firstName;
  final String fatherName;
  final String grandfatherName;
  final String motherName;
  final String nationalNumber;
  final String cardBodyNumber;
  final String familyNumber;

  String get displayName => [
    firstName,
    fatherName,
    grandfatherName,
  ].where((part) => part.trim().isNotEmpty).join(' ');

  factory MinorIdentityReview.fromExtraction(IdentityExtractionResult result) {
    String value(ExtractedIdentityField? field) => field?.value?.trim() ?? '';
    return MinorIdentityReview(
      firstName: value(result.name),
      fatherName: value(result.fatherName),
      grandfatherName: value(result.grandfatherName),
      motherName: value(result.motherName),
      nationalNumber: value(result.nationalCardNumber),
      cardBodyNumber: value(result.uniqueCardBodyNumber),
      familyNumber: value(result.familyNumber),
    );
  }
}
