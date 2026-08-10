/// JSON converter helpers for enums (used via @JsonKey(fromJson:)).
library;

import 'enums.dart';

Role roleFromJson(Object? v) => Role.fromApi(v as String?);
IdentityStatus identityStatusFromJson(Object? v) =>
    IdentityStatus.fromApi(v as String?);
VerificationStatus verificationStatusFromJson(Object? v) =>
    VerificationStatus.fromApi(v as String?);
IdentityDocumentType identityDocumentTypeFromJson(Object? v) =>
    IdentityDocumentType.fromApi(v as String?);
IdentityDocumentLifecycleStatus identityLifecycleFromJson(Object? v) =>
    IdentityDocumentLifecycleStatus.fromApi(v as String?);
MedicalDocumentType medicalDocumentTypeFromJson(Object? v) =>
    MedicalDocumentType.fromApi(v as String?);
ProcessingStatus processingStatusFromJson(Object? v) =>
    ProcessingStatus.fromApi(v as String?);
DateSource dateSourceFromJson(Object? v) => DateSource.fromApi(v as String?);
ArchiveStatus archiveStatusFromJson(Object? v) =>
    ArchiveStatus.fromApi(v as String?);
ClassificationSource classificationSourceFromJson(Object? v) =>
    ClassificationSource.fromApi(v as String?);
Sex sexFromJson(Object? v) => Sex.fromApi(v as String?);
BloodGroup bloodGroupFromJson(Object? v) => BloodGroup.fromApi(v as String?);
Relationship relationshipFromJson(Object? v) =>
    Relationship.fromApi(v as String?);
FacilityType facilityTypeFromJson(Object? v) =>
    FacilityType.fromApi(v as String?);
IntegrityStatus integrityStatusFromJson(Object? v) =>
    IntegrityStatus.fromApi(v as String?);
MalwareScanStatus malwareScanStatusFromJson(Object? v) =>
    MalwareScanStatus.fromApi(v as String?);
Source sourceFromJson(Object? v) => Source.fromApi(v as String?);
AccountClaimStatus accountClaimStatusFromJson(Object? v) =>
    AccountClaimStatus.fromApi(v as String?);
EvidenceType evidenceTypeFromJson(Object? v) =>
    EvidenceType.fromApi(v as String?);
