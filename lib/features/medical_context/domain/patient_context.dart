enum PatientContextKind { self, minor }

/// In-memory medical-record scope. The guardian JWT remains unchanged.
final class PatientContext {
  const PatientContext.self()
    : kind = PatientContextKind.self,
      relationshipUuid = null,
      minorUuid = null,
      safeDisplayName = null;

  const PatientContext.minor({
    required this.relationshipUuid,
    required this.minorUuid,
    required this.safeDisplayName,
  }) : kind = PatientContextKind.minor;

  final PatientContextKind kind;
  final String? relationshipUuid;
  final String? minorUuid;
  final String? safeDisplayName;

  bool get isMinor => kind == PatientContextKind.minor;
  String get cacheKey => isMinor ? 'minor:$minorUuid' : 'self';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientContext &&
          kind == other.kind &&
          minorUuid == other.minorUuid;

  @override
  int get hashCode => Object.hash(kind, minorUuid);
}
