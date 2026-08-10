import 'package:freezed_annotation/freezed_annotation.dart';

import 'enum_json.dart';
import 'enums.dart';

part 'identity.freezed.dart';
part 'identity.g.dart';

/// Identity document summary (list item).
@freezed
abstract class IdentityDocumentSummary with _$IdentityDocumentSummary {
  const factory IdentityDocumentSummary({
    required String uuid,
    @JsonKey(fromJson: identityDocumentTypeFromJson)
    @Default(IdentityDocumentType.unknown)
    IdentityDocumentType documentType,
    @Default('') String issuingCountry,
    DateTime? issueDate,
    DateTime? expiryDate,
    @JsonKey(fromJson: verificationStatusFromJson)
    @Default(VerificationStatus.unknown)
    VerificationStatus verificationStatus,
    @JsonKey(fromJson: identityLifecycleFromJson)
    @Default(IdentityDocumentLifecycleStatus.unknown)
    IdentityDocumentLifecycleStatus status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _IdentityDocumentSummary;

  factory IdentityDocumentSummary.fromJson(Map<String, dynamic> json) =>
      _$IdentityDocumentSummaryFromJson(json);
}

/// Identity document detail.
@freezed
abstract class IdentityDocumentDetail with _$IdentityDocumentDetail {
  const factory IdentityDocumentDetail({
    required String uuid,
    @JsonKey(fromJson: identityDocumentTypeFromJson)
    @Default(IdentityDocumentType.unknown)
    IdentityDocumentType documentType,
    @Default('') String issuingCountry,
    DateTime? issueDate,
    DateTime? expiryDate,
    @JsonKey(fromJson: verificationStatusFromJson)
    @Default(VerificationStatus.unknown)
    VerificationStatus verificationStatus,
    @JsonKey(fromJson: identityLifecycleFromJson)
    @Default(IdentityDocumentLifecycleStatus.unknown)
    IdentityDocumentLifecycleStatus status,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default('') String documentNumber,
    @Default('') String nationalNumber,
    @Default('') String familyNumber,
    DateTime? verifiedAt,
    @Default('') String rejectionReason,
    @Default(<String>[]) List<String> availableImages,
    String? replaces,
  }) = _IdentityDocumentDetail;

  factory IdentityDocumentDetail.fromJson(Map<String, dynamic> json) =>
      _$IdentityDocumentDetailFromJson(json);
}
