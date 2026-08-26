import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/models/archive.dart';
import '../../../core/models/pagination.dart';
import '../../medical_context/domain/patient_context.dart';
import '../data/archive_api.dart';

class ArchiveScope {
  const ArchiveScope.adult() : minorUuid = null;
  const ArchiveScope.minor(this.minorUuid);

  final String? minorUuid;

  PatientContext get patientContext => minorUuid == null
      ? const PatientContext.self()
      : PatientContext.minor(
          relationshipUuid: '',
          minorUuid: minorUuid!,
          safeDisplayName: '',
        );

  @override
  bool operator ==(Object other) =>
      other is ArchiveScope && minorUuid == other.minorUuid;

  @override
  int get hashCode => minorUuid.hashCode;
}

/// Active filters per scope (`minorUuid` or `adult`).
final archiveFilterProvider = StateProvider.family<ArchiveQuery, String>(
  (ref, key) => const ArchiveQuery(),
);

final archiveProvider = FutureProvider.autoDispose
    .family<ArchivePage<ArchiveDocument>, ArchiveScope>((ref, scope) {
      final context = scope.patientContext;
      final key = context.cacheKey;
      final query = ref.watch(archiveFilterProvider(key));
      return ref
          .watch(medicalRecordsRepositoryProvider)
          .archive(context, query);
    });

final archiveSummaryProvider = FutureProvider.autoDispose
    .family<ArchiveSummary, ArchiveScope>(
      (ref, scope) => ref
          .watch(medicalRecordsRepositoryProvider)
          .archiveSummary(scope.patientContext),
    );
