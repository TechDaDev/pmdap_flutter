import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/pagination.dart';

/// Generic page-1 + load-more pagination for API page responses.
///
/// - `refresh()` resets to page 1.
/// - `loadMore()` fetches the next page once (no duplicate in-flight calls).
/// - `hasNext` is derived from the backend `next` link.
/// - A next-page failure keeps prior results and exposes `nextPageError` for a
///   retry; it never clears already-loaded items.
///
/// Subclasses provide [fetchPage]. No PII is logged.
abstract class PagedNotifier<T> extends AsyncNotifier<Page<T>> {
  bool _hasNext = false;
  bool _loadingMore = false;
  int _page = 1;
  ApiExceptionPlaceholder? _nextError;

  bool get hasNext => _hasNext;
  bool get loadingMore => _loadingMore;
  Object? get nextPageError => _nextError;

  /// Fetches one page. Implementations must not throw raw transport errors;
  /// they should surface the typed API error so [build] can show it safely.
  Future<Page<T>> fetchPage(int page);

  @override
  Future<Page<T>> build() async {
    _page = 1;
    _hasNext = false;
    _loadingMore = false;
    _nextError = null;
    final page = await fetchPage(1);
    _hasNext = page.next != null && page.next!.isNotEmpty;
    return page;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  /// Loads the next page, appending results. Ignores duplicate calls while a
  /// next-page request is already running or when there is no next page.
  Future<void> loadMore() async {
    if (_loadingMore || !_hasNext) return;
    _loadingMore = true;
    _nextError = null;
    try {
      final next = await fetchPage(_page + 1);
      _page += 1;
      _hasNext = next.next != null && next.next!.isNotEmpty;
      final current = state.valueOrNull;
      if (current != null) {
        state = AsyncData(
          Page<T>(
            count: next.count,
            next: next.next,
            previous: next.previous,
            results: [...current.results, ...next.results],
          ),
        );
      } else {
        state = AsyncData(next);
      }
    } catch (e) {
      _nextError = ApiExceptionPlaceholder(e);
    } finally {
      _loadingMore = false;
    }
  }
}

/// Placeholder so screens can show a typed/safe next-page error without
/// leaking raw exception text. Kept intentionally opaque.
class ApiExceptionPlaceholder {
  const ApiExceptionPlaceholder(this.cause);
  final Object cause;
}
