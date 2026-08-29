import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pmdap_mobile/core/api/api_exception.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/guardian_relationship_summary.dart';
import 'package:pmdap_mobile/features/minors/application/minors_providers.dart';
import 'package:pmdap_mobile/features/minors/data/minors_api.dart';
import 'package:pmdap_mobile/features/minors/presentation/minor_detail_screen.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

Widget _detailApp({required List<Override> overrides, required String uuid}) {
  final router = GoRouter(
    initialLocation: '/guardian-relationships/$uuid',
    routes: [
      GoRoute(
        path: '/guardian-relationships/:uuid',
        builder: (context, state) =>
            MinorDetailScreen(uuid: state.pathParameters['uuid']!),
      ),
      GoRoute(
        path: '/minors',
        builder: (_, _) => const Scaffold(body: Text('MINORS_MARKER')),
      ),
    ],
  );
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    ),
  );
}

GuardianRelationshipSummary _rejected() => GuardianRelationshipSummary(
  uuid: 'relationship-r1',
  child: const GuardianChildSummary(
    uuid: 'minor-1',
    digitalId: 'PT-SAFE-0001',
    fullName: 'Synthetic Child',
  ),
  relationship: Relationship.mother,
  status: GuardianRelationshipStatus.rejected,
  canRevoke: false,
  canDismiss: true,
  createdAt: DateTime(2026, 8, 25),
);

GuardianRelationshipSummary _verified() => GuardianRelationshipSummary(
  uuid: 'relationship-v1',
  child: const GuardianChildSummary(
    uuid: 'minor-2',
    digitalId: 'PT-SAFE-0002',
    fullName: 'Verified Child',
  ),
  relationship: Relationship.mother,
  status: GuardianRelationshipStatus.verified,
  canRevoke: true,
  canDismiss: false,
  createdAt: DateTime(2026, 8, 25),
  verifiedAt: DateTime(2026, 8, 25),
);

class _DismissApi extends MinorsApi {
  _DismissApi() : super(Dio());
  int dismissCalls = 0;
  int revoked = 0;
  bool failConflict = false;

  @override
  Future<void> dismissRelationship(String uuid) async {
    dismissCalls++;
    if (failConflict) {
      throw const ApiException(
        statusCode: 409,
        code: 'relationship_transition_conflict',
        message: 'conflict',
      );
    }
  }

  @override
  Future<void> revokeRelationship(String uuid) async {
    revoked++;
  }
}

void main() {
  testWidgets('rejected detail shows Remove request with safe helper', (
    tester,
  ) async {
    await tester.pumpWidget(
      _detailApp(
        uuid: 'relationship-r1',
        overrides: [
          guardianRelationshipDetailProvider(
            'relationship-r1',
          ).overrideWith((ref) async => _rejected()),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Remove request'), findsOneWidget);
    expect(
      find.text(
        'This only removes it from your list. The review history is retained.',
      ),
      findsOneWidget,
    );
    expect(find.text('Revoke access'), findsNothing);
  });

  testWidgets('Remove request confirms then calls dismiss exactly once', (
    tester,
  ) async {
    final api = _DismissApi();
    await tester.pumpWidget(
      _detailApp(
        uuid: 'relationship-r1',
        overrides: [
          minorsApiProvider.overrideWithValue(api),
          guardianRelationshipDetailProvider(
            'relationship-r1',
          ).overrideWith((ref) async => _rejected()),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Remove request'));
    await tester.pumpAndSettle();
    expect(
      find.text('Remove this rejected request from My Children?'),
      findsOneWidget,
    );
    // Cancel first: no call.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(api.dismissCalls, 0);

    await tester.tap(find.text('Remove request'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove request').last);
    await tester.pumpAndSettle();
    expect(api.dismissCalls, 1);
  });

  testWidgets('verified detail never shows Remove request', (tester) async {
    await tester.pumpWidget(
      _detailApp(
        uuid: 'relationship-v1',
        overrides: [
          guardianRelationshipDetailProvider(
            'relationship-v1',
          ).overrideWith((ref) async => _verified()),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Remove request'), findsNothing);
  });

  testWidgets('dismiss conflict surfaces safe error and keeps row', (
    tester,
  ) async {
    final api = _DismissApi()..failConflict = true;
    await tester.pumpWidget(
      _detailApp(
        uuid: 'relationship-r1',
        overrides: [
          minorsApiProvider.overrideWithValue(api),
          guardianRelationshipDetailProvider(
            'relationship-r1',
          ).overrideWith((ref) async => _rejected()),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Remove request'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove request').last);
    await tester.pumpAndSettle();

    expect(api.dismissCalls, 1);
    expect(
      find.text('This request changed on the server. Refresh and try again.'),
      findsOneWidget,
    );
  });
}
