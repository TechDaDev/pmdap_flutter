import 'enums.dart';

enum GuardianRelationshipStatus {
  pending('PENDING'),
  verified('VERIFIED'),
  rejected('REJECTED'),
  revoked('REVOKED'),
  unknown('UNKNOWN');

  const GuardianRelationshipStatus(this.api);
  final String api;

  static GuardianRelationshipStatus fromApi(String? value) =>
      GuardianRelationshipStatus.values.firstWhere(
        (item) => item.api == value,
        orElse: () => GuardianRelationshipStatus.unknown,
      );
}

class GuardianChildSummary {
  const GuardianChildSummary({
    required this.uuid,
    required this.digitalId,
    required this.fullName,
  });

  final String uuid;
  final String digitalId;
  final String fullName;

  factory GuardianChildSummary.fromJson(Map<String, dynamic> json) =>
      GuardianChildSummary(
        uuid: json['uuid'] as String? ?? '',
        digitalId: json['digital_id'] as String? ?? '',
        fullName: json['full_name'] as String? ?? '',
      );
}

class GuardianRelationshipSummary {
  const GuardianRelationshipSummary({
    required this.uuid,
    required this.child,
    required this.relationship,
    required this.status,
    required this.canRevoke,
    this.startedAt,
    this.verifiedAt,
    this.endedAt,
    this.createdAt,
    this.updatedAt,
  });

  final String uuid;
  final GuardianChildSummary child;
  final Relationship relationship;
  final GuardianRelationshipStatus status;
  final bool canRevoke;
  final DateTime? startedAt;
  final DateTime? verifiedAt;
  final DateTime? endedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isVerified => status == GuardianRelationshipStatus.verified;

  factory GuardianRelationshipSummary.fromJson(Map<String, dynamic> json) =>
      GuardianRelationshipSummary(
        uuid: json['uuid'] as String? ?? '',
        child: GuardianChildSummary.fromJson(
          json['minor_patient'] as Map<String, dynamic>? ?? const {},
        ),
        relationship: Relationship.fromApi(json['relationship'] as String?),
        status: GuardianRelationshipStatus.fromApi(json['status'] as String?),
        canRevoke: json['can_revoke'] as bool? ?? false,
        startedAt: DateTime.tryParse(json['started_at'] as String? ?? ''),
        verifiedAt: DateTime.tryParse(json['verified_at'] as String? ?? ''),
        endedAt: DateTime.tryParse(json['ended_at'] as String? ?? ''),
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
        updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? ''),
      );
}
