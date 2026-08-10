import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/models/archive.dart';
import '../../../core/models/pagination.dart';
import '../data/archive_api.dart';

/// Which archive to show: the adult's own, or a minor's (guardian).
class ArchiveScope {
  const ArchiveScope.adult() : minorUuid = null;
  const ArchiveScope.minor(this.minorUuid);

  final String? minorUuid;
}

/// Active filters per scope (`minorUuid` or `adult`).
final archiveFilterProvider = StateProvider.family<ArchiveQuery, String>(
  (ref, key) => const ArchiveQuery(),
);

final archiveProvider = FutureProvider.autoDispose
    .family<ArchivePage<ArchiveDocument>, ArchiveScope>((ref, scope) {
      final key = scope.minorUuid ?? 'adult';
      final query = ref.watch(archiveFilterProvider(key));
      final minorUuid = scope.minorUuid;
      if (minorUuid != null) {
        return ref.watch(minorArchiveApiProvider).list(minorUuid, query);
      }
      return ref.watch(archiveApiProvider).list(query);
    });

final archiveSummaryProvider = FutureProvider.autoDispose
    .family<ArchiveSummary, ArchiveScope>((ref, scope) {
      final minorUuid = scope.minorUuid;
      if (minorUuid != null) {
        return ref.watch(minorArchiveApiProvider).summary(minorUuid);
      }
      return ref.watch(archiveApiProvider).summary();
    });
