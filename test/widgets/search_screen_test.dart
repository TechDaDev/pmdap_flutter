import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/archive.dart';
import 'package:pmdap_mobile/core/models/pagination.dart';
import 'package:pmdap_mobile/features/search/data/search_api.dart';
import 'package:pmdap_mobile/features/search/presentation/search_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

class _FakeSearchApi extends SearchApi {
  _FakeSearchApi() : super(Dio());

  final queries = <String?>[];
  bool empty = false;

  @override
  Future<Page<ArchiveDocument>> search(
    SearchQuery query, {
    int page = 1,
  }) async {
    queries.add(query.q);
    if (empty) {
      return const Page<ArchiveDocument>(
        count: 0,
        next: null,
        previous: null,
        results: [],
      );
    }
    return Page<ArchiveDocument>(
      count: 1,
      next: null,
      previous: null,
      results: [sampleArchiveDocument()],
    );
  }
}

void main() {
  testWidgets('typing a query shows results after debounce', (tester) async {
    final api = _FakeSearchApi();
    await tester.pumpWidget(
      pumpApp(
        const SearchScreen(),
        overrides: [searchApiProvider.overrideWithValue(api)],
      ),
    );

    await tester.enterText(find.byType(TextField), 'blood test');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(api.queries.last, 'blood test');
    expect(find.text('Archive Report'), findsOneWidget);
  });

  testWidgets('no results state', (tester) async {
    final api = _FakeSearchApi()..empty = true;
    await tester.pumpWidget(
      pumpApp(
        const SearchScreen(),
        overrides: [searchApiProvider.overrideWithValue(api)],
      ),
    );

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('No results found.'), findsOneWidget);
  });

  testWidgets('empty query does not hit the API', (tester) async {
    final api = _FakeSearchApi();
    await tester.pumpWidget(
      pumpApp(
        const SearchScreen(),
        overrides: [searchApiProvider.overrideWithValue(api)],
      ),
    );
    await tester.pumpAndSettle();
    expect(api.queries, isEmpty);
  });
}
