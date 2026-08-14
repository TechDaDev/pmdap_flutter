/// DTOs for the scan-first registration identity flow (public endpoints).
///
/// Extraction values are ADVISORY; the final register carries the
/// human-confirmed values in [RegistrationIdentityInput] plus the account
/// fields. The capability token lives only in memory (job id + token) and is
/// sent in a request header — never in the URL.
library;

import '../../../core/models/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../identity/data/extraction_models.dart';

/// 202 response from the public scan-first extraction.
class RegistrationExtractionJob {
  const RegistrationExtractionJob({
    required this.jobId,
    required this.jobToken,
  });

  final String jobId;
  final String jobToken;

  factory RegistrationExtractionJob.fromJson(Map<String, dynamic> json) {
    return RegistrationExtractionJob(
      jobId: (json['job_id'] as String?) ?? '',
      jobToken: (json['job_token'] as String?) ?? '',
    );
  }
}

/// Poll response for the public scan-first extraction.
class RegistrationExtractionStatus {
  const RegistrationExtractionStatus({
    required this.jobId,
    required this.status,
    this.errorCode = '',
    this.result,
  });

  final String jobId;
  final ExtractionJobStatus status;
  final String errorCode;
  final IdentityExtractionResult? result;

  factory RegistrationExtractionStatus.fromJson(Map<String, dynamic> json) {
    final status = ExtractionJobStatus.fromApi(json['status'] as String?);
    return RegistrationExtractionStatus(
      jobId: (json['job_id'] as String?) ?? '',
      status: status,
      errorCode: (json['error_code'] as String?) ?? '',
      result: status == ExtractionJobStatus.success
          ? IdentityExtractionResult.fromJson(json)
          : null,
    );
  }
}

/// Confirmed, human-reviewed identity data for scan-first registration.
///
/// The four identifiers stay distinct and are never mapped into one another.
/// [confirmation] is the explicit user acknowledgement that the values match
/// the National Card; the backend refuses registration without it.
class RegistrationIdentityInput {
  const RegistrationIdentityInput({
    required this.jobId,
    required this.jobToken,
    required this.documentType,
    required this.documentNumber,
    this.nationalCardNumber = '',
    this.familyNumber = '',
    this.uniqueCardBodyNumber = '',
    required this.name,
    required this.fatherName,
    required this.grandfatherName,
    required this.confirmation,
    required this.dateOfBirth,
    required this.sex,
    this.nationality = 'IQ',
    this.bloodGroup = BloodGroup.unknown,
  });

  final String jobId;
  final String jobToken;
  final IdentityDocumentType documentType;
  final String documentNumber;
  final String nationalCardNumber;
  final String familyNumber;
  final String uniqueCardBodyNumber;
  final String name;
  final String fatherName;
  final String grandfatherName;
  final bool confirmation;
  final DateTime? dateOfBirth;
  final Sex sex;
  final String nationality;
  final BloodGroup bloodGroup;

  Map<String, dynamic> toJson() => {
    'job_id': jobId,
    'job_token': jobToken,
    'document_type': documentType.api,
    'document_number': documentNumber,
    'national_card_number': nationalCardNumber,
    'family_number': familyNumber,
    'unique_card_body_number': uniqueCardBodyNumber,
    'name': name,
    'father_name': fatherName,
    'grandfather_name': grandfatherName,
    'confirmation': confirmation,
    'date_of_birth': formatApiDate(dateOfBirth),
    'sex': sex.api,
    'nationality': nationality,
    'blood_group': bloodGroup.api,
  };
}
