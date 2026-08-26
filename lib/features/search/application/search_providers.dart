import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/models/archive.dart';
import '../../../core/models/pagination.dart';
import '../../medical_context/domain/patient_context.dart';
import '../data/search_api.dart';

/// Current search query (screen updates this; never persisted/logged).
final searchQueryProvider = StateProvider<SearchQuery>(
  (ref) => const SearchQuery(),
);

final contextSearchQueryProvider = StateProvider.family<SearchQuery, String>(
  (ref, contextKey) => const SearchQuery(),
);

final searchResultsProvider = FutureProvider.autoDispose<Page<ArchiveDocument>>(
  (ref) {
    final query = ref.watch(searchQueryProvider);
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
    return ref.watch(searchApiProvider).search(query);
  },
);

final contextSearchResultsProvider = FutureProvider.autoDispose
    .family<Page<ArchiveDocument>, PatientContext>((ref, context) {
      final query = ref.watch(contextSearchQueryProvider(context.cacheKey));
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
      return ref.watch(medicalRecordsRepositoryProvider).search(context, query);
    });
