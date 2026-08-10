/// Backend pagination envelope: `{count, next, previous, results}`.
class Page<T> {
  const Page({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  bool get hasNext => next != null && next!.isNotEmpty;

  factory Page.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromItem,
  ) {
    return Page<T>(
      count: (json['count'] as num?)?.toInt() ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: _list(json['results']).map(fromItem).toList(),
    );
  }

  static List<Map<String, dynamic>> _list(Object? value) {
    if (value is List) {
      return value.whereType<Map<String, dynamic>>().toList();
    }
    return const [];
  }
}

/// Archive list page — adds `unconfirmed_date_count`.
class ArchivePage<T> {
  const ArchivePage({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
    required this.unconfirmedDateCount,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<T> results;
  final int unconfirmedDateCount;

  factory ArchivePage.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromItem,
  ) {
    return ArchivePage<T>(
      count: (json['count'] as num?)?.toInt() ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results:
          (json['results'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(fromItem)
              .toList() ??
          const [],
      unconfirmedDateCount:
          (json['unconfirmed_date_count'] as num?)?.toInt() ?? 0,
    );
  }
}
