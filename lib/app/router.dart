import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/archive/presentation/archive_screen.dart';
import '../features/auth/application/session_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/password_reset_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/claims/presentation/claims_screen.dart';
import '../features/claims/presentation/account_activation_screen.dart';
import '../features/documents/presentation/confirm_dates_screen.dart';
import '../features/documents/presentation/date_confirmation_screen.dart';
import '../features/documents/presentation/document_detail_screen.dart';
import '../features/documents/presentation/document_viewer_screen.dart';
import '../features/documents/presentation/document_page_results_screen.dart';
import '../features/documents/presentation/documents_screen.dart';
import '../features/documents/presentation/document_upload_screen.dart';
import '../features/facilities/presentation/facilities_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/identity/presentation/identity_document_detail_screen.dart';
import '../features/identity/presentation/identity_documents_screen.dart';
import '../features/identity/presentation/identity_submit_screen.dart';
import '../features/minors/presentation/minor_create_screen.dart';
import '../features/minors/presentation/minor_detail_screen.dart';
import '../features/minors/presentation/minors_screen.dart';
import '../features/medical_context/presentation/minor_context_gate.dart';
import '../features/patient/presentation/profile_edit_screen.dart';
import '../features/patient/presentation/profile_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/tools/presentation/dev_health_screen.dart';
import 'main_shell.dart';

class Routes {
  Routes._();

  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const passwordReset = '/password-reset';

  static const home = '/home';
  static const archive = '/archive';
  static const search = '/search';
  static const profile = '/profile';
  static const profileEdit = '/profile/edit';
  static const settings = '/settings';

  static const identity = '/identity';
  static const identityNew = '/identity/new';
  static String identityDetail(String uuid) => '/identity/$uuid';

  static const minors = '/minors';
  static const minorsNew = '/minors/new';
  static String minorDetail(String uuid) => '/minors/$uuid';
  static String guardianRelationshipDetail(String uuid) =>
      '/guardian-relationships/$uuid';
  static String minorDocuments(String uuid) => '/minors/$uuid/documents';
  static String minorArchive(String uuid) => '/minors/$uuid/archive';
  static String minorSearch(String uuid) => '/minors/$uuid/search';
  static String minorUpload(String uuid) => '/minors/$uuid/upload';
  static String minorConfirmDates(String uuid) => '/minors/$uuid/confirm-dates';

  static const documents = '/documents';
  static const documentsNew = '/documents/new';
  static String documentDetail(String uuid) => '/documents/$uuid';
  static String documentDate(String uuid) => '/documents/$uuid/date';
  static String documentViewer(String uuid) => '/documents/$uuid/view';
  static String documentPageResults(String uuid, int pageNumber) =>
      '/documents/$uuid/page/$pageNumber';

  static const confirmDates = '/confirm-dates';
  static const facilities = '/facilities';
  static const claims = '/claims';
  static const accountActivation = '/activate-claimed-account';
  static const devHealth = '/dev-health';
}

/// Pure auth-gating decision for the router redirect. Testable without a tree.
///
/// Public (allow-any) routes that must work while signed OUT:
/// login, register, account claim submission, claimed-account activation.
String? authRedirect(AuthState auth, String location) {
  final publicRoute =
      location == Routes.login ||
      location == Routes.register ||
      location == Routes.passwordReset ||
      location == Routes.claims ||
      location == Routes.accountActivation;
  return switch (auth) {
    // Bootstrap in progress: only splash may show.
    AuthUnknown() => location == Routes.splash ? null : Routes.splash,
    // Signed out: public routes allowed; everything else → login.
    AuthUnauthenticated() => publicRoute ? null : Routes.login,
    // Signed in: never show splash/login/register.
    AuthAuthenticated() =>
      (location == Routes.splash ||
              location == Routes.login ||
              location == Routes.register ||
              location == Routes.passwordReset)
          ? Routes.home
          : null,
  };
}

/// Builds the GoRouter. [refreshListenable] triggers redirect re-evaluation
/// whenever the auth state changes.
GoRouter createAppRouter(Ref ref, Listenable refreshListenable) {
  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: refreshListenable,
    redirect: (context, state) => authRedirect(
      ref.read(sessionControllerProvider),
      state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.passwordReset,
        builder: (context, state) => const PasswordResetScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.archive,
                builder: (context, state) => const ArchiveScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.profileEdit,
        builder: (context, state) => const ProfileEditScreen(),
      ),
      GoRoute(
        path: Routes.identity,
        builder: (context, state) => const IdentityDocumentsScreen(),
      ),
      GoRoute(
        path: Routes.identityNew,
        builder: (context, state) => const IdentitySubmitScreen(),
      ),
      GoRoute(
        path: '/identity/:uuid',
        builder: (context, state) =>
            IdentityDocumentDetailScreen(uuid: state.pathParameters['uuid']!),
      ),
      GoRoute(
        path: '/identity/:uuid/replace',
        builder: (context, state) =>
            IdentitySubmitScreen(replaceUuid: state.pathParameters['uuid']!),
      ),
      GoRoute(
        path: Routes.minors,
        builder: (context, state) => const MinorsScreen(),
      ),
      GoRoute(
        path: Routes.minorsNew,
        builder: (context, state) => const MinorCreateScreen(),
      ),
      GoRoute(
        path: '/minors/:uuid',
        builder: (context, state) => MinorContextGate(
          minorUuid: state.pathParameters['uuid']!,
          destination: Routes.home,
        ),
      ),
      GoRoute(
        path: '/guardian-relationships/:uuid',
        builder: (context, state) =>
            MinorDetailScreen(uuid: state.pathParameters['uuid']!),
      ),
      GoRoute(
        path: '/minors/:uuid/documents',
        builder: (context, state) => MinorContextGate(
          minorUuid: state.pathParameters['uuid']!,
          destination: Routes.home,
        ),
      ),
      GoRoute(
        path: '/minors/:uuid/archive',
        builder: (context, state) => MinorContextGate(
          minorUuid: state.pathParameters['uuid']!,
          destination: Routes.archive,
        ),
      ),
      GoRoute(
        path: '/minors/:uuid/search',
        builder: (context, state) => MinorContextGate(
          minorUuid: state.pathParameters['uuid']!,
          destination: Routes.search,
        ),
      ),
      GoRoute(
        path: Routes.documents,
        builder: (context, state) => const DocumentsScreen(),
      ),
      GoRoute(
        path: Routes.documentsNew,
        builder: (context, state) => const DocumentUploadScreen(),
      ),
      GoRoute(
        path: '/documents/:uuid',
        builder: (context, state) =>
            DocumentDetailScreen(uuid: state.pathParameters['uuid']!),
      ),
      GoRoute(
        path: '/documents/:uuid/view',
        builder: (context, state) =>
            DocumentViewerScreen(uuid: state.pathParameters['uuid']!),
      ),
      GoRoute(
        path: '/documents/:uuid/page/:pageNumber',
        builder: (context, state) => DocumentPageResultsScreen(
          uuid: state.pathParameters['uuid']!,
          pageNumber: int.parse(state.pathParameters['pageNumber']!),
        ),
      ),
      GoRoute(
        path: Routes.confirmDates,
        builder: (context, state) => const ConfirmDatesScreen(),
      ),
      GoRoute(
        path: '/minors/:uuid/confirm-dates',
        builder: (context, state) =>
            ConfirmDatesScreen(minorUuid: state.pathParameters['uuid']),
      ),
      GoRoute(
        path: '/minors/:uuid/upload',
        builder: (context, state) =>
            DocumentUploadScreen(minorUuid: state.pathParameters['uuid']),
      ),
      GoRoute(
        path: '/documents/:uuid/date',
        builder: (context, state) => DateConfirmationScreen(
          documentUuid: state.pathParameters['uuid']!,
          pageNumber: int.tryParse(state.uri.queryParameters['page'] ?? ''),
        ),
      ),
      GoRoute(
        path: Routes.facilities,
        builder: (context, state) => const FacilitiesScreen(),
      ),
      GoRoute(
        path: Routes.claims,
        builder: (context, state) => const ClaimsScreen(),
      ),
      GoRoute(
        path: Routes.accountActivation,
        builder: (context, state) => const AccountActivationScreen(),
      ),
      GoRoute(
        path: Routes.devHealth,
        builder: (context, state) => const DevHealthScreen(),
      ),
    ],
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ValueNotifier<int>(0);
  ref.listen(sessionControllerProvider, (_, _) => notifier.value++);
  ref.onDispose(notifier.dispose);
  return createAppRouter(ref, notifier);
});
