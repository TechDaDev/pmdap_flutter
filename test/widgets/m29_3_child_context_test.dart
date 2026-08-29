import 'package:flutter/material.dart' hide Page;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/core/models/pagination.dart';
import 'package:pmdap_mobile/core/models/pending_date_confirmation.dart';
import 'package:pmdap_mobile/features/documents/application/documents_providers.dart';
import 'package:pmdap_mobile/features/home/presentation/home_screen.dart';
import 'package:pmdap_mobile/features/medical_context/application/patient_context_controller.dart';
import 'package:pmdap_mobile/features/medical_context/domain/patient_context.dart';
import 'package:pmdap_mobile/features/patient/application/patient_providers.dart';
import 'package:pmdap_mobile/features/patient/presentation/profile_screen.dart';
import 'package:pmdap_mobile/features/auth/application/session_controller.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/user.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

const _childContext = PatientContext.minor(
  relationshipUuid: 'relationship-1',
  minorUuid: 'minor-1',
  safeDisplayName: 'Synthetic Child',
);

class _SeededChildContextController extends PatientContextController {
  @override
  PatientContextState build() =>
      const PatientContextState(context: _childContext);
}

class _SelfContextController extends PatientContextController {
  @override
  PatientContextState build() => const PatientContextState();
}

class _FakeSession extends SessionController {
  @override
  AuthState build() => const AuthAuthenticated(
    PublicUser(uuid: 'u1', email: 'x@example.com', role: Role.patient),
  );
}

List<Override> _overrides({
  bool minor = true,
  List<PendingDateConfirmation> pending = const [],
}) {
  final docs = Page<MedicalDocument>(
    count: 1,
    next: null,
    previous: null,
    results: [sampleDocument(uuid: 'child-doc-1')],
  );
  return [
    patientContextControllerProvider.overrideWith(
      minor ? _SeededChildContextController.new : _SelfContextController.new,
    ),
    patientProfileProvider.overrideWith((ref) async => sampleProfile()),
    contextPendingDateConfirmationDocumentsProvider(
      _childContext,
    ).overrideWith((ref) async => pending),
    contextDocumentsProvider(_childContext).overrideWith((ref) async => docs),
  ];
}

void main() {
  testWidgets('child Home hides guardian identity card and self actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      pumpApp(const HomeScreen(), overrides: _overrides()),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Child-scoped content is shown.
    expect(find.text('Child records'), findsOneWidget);
    expect(find.textContaining('Synthetic Child'), findsWidgets);
    // Guardian identity card is hidden.
    expect(find.text('Your identity has been verified.'), findsNothing);
    expect(find.text('Manage identity'), findsNothing);
    expect(find.textContaining('12345678901234567'), findsNothing);
    // Self-oriented actions are hidden.
    expect(find.text('My children'), findsNothing);
    expect(find.text('Identity'), findsNothing);
    // Child actions remain.
    expect(find.text('Upload document'), findsOneWidget);
    expect(find.text('Confirm dates'), findsOneWidget);
    // Recent documents are child-scoped.
    expect(find.text('Lab Report'), findsOneWidget);
  });

  testWidgets('Profile in child context explains settings belong to account', (
    tester,
  ) async {
    await tester.pumpWidget(
      pumpApp(
        const ProfileScreen(),
        overrides: [
          ..._overrides(),
          sessionControllerProvider.overrideWith(_FakeSession.new),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(
      find.text(
        'You are viewing medical records for Synthetic Child. '
        'Profile settings belong to your account.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('self Home keeps guardian identity card and self actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      pumpApp(const HomeScreen(), overrides: _overrides(minor: false)),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Hello, Synthetic'), findsOneWidget);
    expect(find.text('Your identity has been verified.'), findsOneWidget);
    expect(find.text('My children'), findsOneWidget);
    expect(find.text('Identity'), findsOneWidget);
  });

  testWidgets('child Home upload routes to the minor upload endpoint', (
    tester,
  ) async {
    final visited = <String>[];
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
        GoRoute(
          path: '/minors/:uuid/upload',
          builder: (_, state) {
            visited.add('/minors/${state.pathParameters['uuid']}/upload');
            return const Scaffold(body: Text('UPLOAD_MARKER'));
          },
        ),
        GoRoute(
          path: '/minors/:uuid/confirm-dates',
          builder: (_, state) {
            visited.add(
              '/minors/${state.pathParameters['uuid']}/confirm-dates',
            );
            return const Scaffold(body: Text('CONFIRM_MARKER'));
          },
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: _overrides(),
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
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Upload document'));
    await tester.pumpAndSettle();
    expect(visited, ['/minors/minor-1/upload']);
    expect(find.text('UPLOAD_MARKER'), findsOneWidget);
  });

  testWidgets('child Home confirm dates routes to the minor scoped queue', (
    tester,
  ) async {
    final visited = <String>[];
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
        GoRoute(
          path: '/minors/:uuid/upload',
          builder: (_, state) {
            visited.add('/minors/${state.pathParameters['uuid']}/upload');
            return const Scaffold(body: Text('UPLOAD_MARKER'));
          },
        ),
        GoRoute(
          path: '/minors/:uuid/confirm-dates',
          builder: (_, state) {
            visited.add(
              '/minors/${state.pathParameters['uuid']}/confirm-dates',
            );
            return const Scaffold(body: Text('CONFIRM_MARKER'));
          },
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: _overrides(),
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
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Confirm dates'));
    await tester.pumpAndSettle();
    expect(visited, ['/minors/minor-1/confirm-dates']);
    expect(find.text('CONFIRM_MARKER'), findsOneWidget);
  });
}
