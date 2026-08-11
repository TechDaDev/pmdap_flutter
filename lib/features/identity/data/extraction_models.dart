/// Advisory identity extraction DTOs (snake_case backend contract).
///
/// Extraction is advisory only — final identity submission goes through the
/// existing IdentitySubmission API after human review.
library;

import 'package:pmdap_mobile/core/models/enums.dart';

/// Source of an extracted candidate.
enum IdentityExtractionSource {
  mrz,
  ocr,
  documentType,
  derived,
  unknown;

  static IdentityExtractionSource fromApi(String? value) {
    return switch (value) {
      'MRZ' => IdentityExtractionSource.mrz,
      'OCR' => IdentityExtractionSource.ocr,
      'DOCUMENT_TYPE' => IdentityExtractionSource.documentType,
      'DERIVED' => IdentityExtractionSource.derived,
      _ => IdentityExtractionSource.unknown,
    };
  }
}

class ExtractedIdentityField {
  const ExtractedIdentityField({
    this.value,
    this.confidence = 0,
    this.source = IdentityExtractionSource.unknown,
  });

  final String? value;
  final double confidence;
  final IdentityExtractionSource source;

  factory ExtractedIdentityField.fromJson(Map<String, dynamic> json) {
    return ExtractedIdentityField(
      value: json['value'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      source: IdentityExtractionSource.fromApi(json['source'] as String?),
    );
  }
}

class MrzValidationResult {
  const MrzValidationResult({
    this.detected = false,
    this.valid = false,
    this.checksPassed = false,
  });

  final bool detected;
  final bool valid;
  final bool checksPassed;

  factory MrzValidationResult.fromJson(Map<String, dynamic> json) {
    return MrzValidationResult(
      detected: json['detected'] as bool? ?? false,
      valid: json['valid'] as bool? ?? false,
      checksPassed: json['checks_passed'] as bool? ?? false,
    );
  }
}

class IdentityExtractionResult {
  const IdentityExtractionResult({
    required this.documentType,
    required this.extractorVersion,
    this.fields = const {},
    this.warnings = const [],
    required this.mrz,
  });

  final IdentityDocumentType documentType;
  final String extractorVersion;
  final Map<String, ExtractedIdentityField> fields;
  final List<String> warnings;
  final MrzValidationResult mrz;

  bool get mrzVerified => mrz.detected && mrz.valid && mrz.checksPassed;

  factory IdentityExtractionResult.fromJson(Map<String, dynamic> json) {
    final rawType = (json['document_type'] as String?) ?? '';
    final fieldsJson = (json['fields'] as Map<String, dynamic>? ?? {});
    return IdentityExtractionResult(
      documentType: IdentityDocumentType.fromApi(rawType),
      extractorVersion: (json['extractor_version'] as String?) ?? '',
      fields: fieldsJson.map(
        (k, v) => MapEntry(
          k,
          ExtractedIdentityField.fromJson(v as Map<String, dynamic>),
        ),
      ),
      warnings: (json['warnings'] as List? ?? const [])
          .whereType<String>()
          .toList(),
      mrz: MrzValidationResult.fromJson(
        (json['mrz'] as Map<String, dynamic>? ?? {}),
      ),
    );
  }
}
