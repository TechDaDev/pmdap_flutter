import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/models/archive.dart';
import '../../../core/models/pagination.dart';
import '../data/search_api.dart';

/// Scope for search: adult (`minorUuid == null`) or a minor (guardian).
class SearchScope {
  const SearchScope.adult() : minorUuid = null;
  const SearchScope.minor(this.minorUuid);

  final String? minorUuid;
}

/// Current search query (screen updates this; never persisted/logged).
final searchQueryProvider = StateProvider<SearchQuery>(
  (ref) => const SearchQuery(),
);

final searchScopeProvider = StateProvider<SearchScope>(
  (ref) => const SearchScope.adult(),
);

final searchResultsProvider = FutureProvider.autoDispose<Page<ArchiveDocument>>(
  (ref) {
    final query = ref.watch(searchQueryProvider);
    final scope = ref.watch(searchScopeProvider);
    final q = query.q?.trim() ?? '';
    if (q.isEmpty) {
      return Future.value(
        const Page<ArchiveDocument>(
          count: 0,
          next: null,
          previous: null,
          results: [],
        ),
      );
    }
    final minorUuid = scope.minorUuid;
    if (minorUuid != null) {
      return ref.watch(minorSearchApiProvider).search(minorUuid, query);
    }
    return ref.watch(searchApiProvider).search(query);
  },
);
