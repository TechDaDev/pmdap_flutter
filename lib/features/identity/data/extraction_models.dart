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
  frontPrinted,
  backPrinted,
  roi,
  unknown;

  static IdentityExtractionSource fromApi(String? value) {
    return switch (value) {
      'MRZ' => IdentityExtractionSource.mrz,
      'OCR' => IdentityExtractionSource.ocr,
      'DOCUMENT_TYPE' => IdentityExtractionSource.documentType,
      'DERIVED' => IdentityExtractionSource.derived,
      'FRONT_PRINTED' => IdentityExtractionSource.frontPrinted,
      'BACK_PRINTED' => IdentityExtractionSource.backPrinted,
      'ROI' => IdentityExtractionSource.roi,
      _ => IdentityExtractionSource.unknown,
    };
  }
}

class ExtractedIdentityField {
  const ExtractedIdentityField({
    this.value,
    this.confidence = 0,
    this.source = IdentityExtractionSource.unknown,
    this.crossCheck,
  });

  final String? value;
  final double confidence;
  final IdentityExtractionSource source;

  /// Backend cross-check verdict: `MRZ_AGREE`, `MRZ_MISMATCH`, or null.
  final String? crossCheck;

  /// MRZ cross-check passed — strengthens the confidence presentation.
  bool get mrzAgree => crossCheck == 'MRZ_AGREE';

  factory ExtractedIdentityField.fromJson(Map<String, dynamic> json) {
    return ExtractedIdentityField(
      value: json['value'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      source: IdentityExtractionSource.fromApi(json['source'] as String?),
      crossCheck: json['cross_check'] as String?,
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

  /// Typed accessors for the Iraqi National Card V2 structured contract.
  /// Unknown/future fields never crash parsing — they simply return null.
  ExtractedIdentityField? get name => fields['name'];
  ExtractedIdentityField? get fatherName => fields['father_name'];
  ExtractedIdentityField? get grandfatherName => fields['grandfather_name'];
  ExtractedIdentityField? get motherName => fields['mother_name'];
  ExtractedIdentityField? get sex => fields['sex'];
  ExtractedIdentityField? get bloodGroup => fields['blood_group'];
  ExtractedIdentityField? get nationalCardNumber =>
      fields['national_card_number'];
  ExtractedIdentityField? get dateOfBirth => fields['date_of_birth'];
  ExtractedIdentityField? get familyNumber => fields['family_number'];
  ExtractedIdentityField? get uniqueCardBodyNumber =>
      fields['unique_card_body_number'];
  ExtractedIdentityField? get documentNumber => fields['document_number'];
  ExtractedIdentityField? get issuingCountry => fields['issuing_country'];

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

/// Status of an async extraction job.
enum ExtractionJobStatus {
  pending,
  processing,
  success,
  failed,
  unknown;

  static ExtractionJobStatus fromApi(String? value) {
    return switch (value) {
      'PENDING' => ExtractionJobStatus.pending,
      'PROCESSING' => ExtractionJobStatus.processing,
      'SUCCESS' => ExtractionJobStatus.success,
      'FAILED' => ExtractionJobStatus.failed,
      _ => ExtractionJobStatus.unknown,
    };
  }
}

/// POST /extract/ 202 response.
class ExtractionJobDto {
  const ExtractionJobDto({required this.jobId, required this.status});

  final String jobId;
  final ExtractionJobStatus status;

  factory ExtractionJobDto.fromJson(Map<String, dynamic> json) {
    return ExtractionJobDto(
      jobId: (json['job_id'] as String?) ?? '',
      status: ExtractionJobStatus.fromApi(json['status'] as String?),
    );
  }
}

/// Poll response for the extraction status endpoint.
class ExtractionStatus {
  const ExtractionStatus({
    required this.jobId,
    required this.status,
    this.errorCode = '',
    this.result,
  });

  final String jobId;
  final ExtractionJobStatus status;
  final String errorCode;
  final IdentityExtractionResult? result;

  bool get isTerminal =>
      status == ExtractionJobStatus.success ||
      status == ExtractionJobStatus.failed;

  factory ExtractionStatus.fromJson(Map<String, dynamic> json) {
    final status = ExtractionJobStatus.fromApi(json['status'] as String?);
    return ExtractionStatus(
      jobId: (json['job_id'] as String?) ?? '',
      status: status,
      errorCode: (json['error_code'] as String?) ?? '',
      result: status == ExtractionJobStatus.success
          ? IdentityExtractionResult.fromJson(json)
          : null,
    );
  }
}
