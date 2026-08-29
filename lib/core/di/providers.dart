import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_interceptors.dart';
import '../api/api_client.dart';
import '../auth/token_refresher.dart';
import '../auth/token_store.dart';
import '../config/app_config.dart';
import '../storage/refresh_token_storage.dart';
import '../../features/archive/data/archive_api.dart';
import '../../features/archive/data/minor_archive_api.dart';
import '../../features/auth/data/auth_api.dart';
import '../../features/auth/data/password_reset_api.dart';
import '../../features/auth/data/registration_api.dart';
import '../../features/claims/data/claims_api.dart';
import '../../features/documents/data/documents_api.dart';
import '../../features/facilities/data/facilities_api.dart';
import '../../features/identity/data/identity_api.dart';
import '../../features/minors/data/minor_documents_api.dart';
import '../../features/minors/data/minors_api.dart';
import '../../features/medical_context/application/patient_context_controller.dart';
import '../../features/medical_context/data/medical_records_repository.dart';
import '../../features/patient/data/patient_api.dart';
import '../../features/search/data/minor_search_api.dart';
import '../../features/search/data/search_api.dart';
import '../storage/registration_session_storage.dart';

/// Holds the current session-expiry callback. The session controller registers
/// itself here so the refresh interceptor can force-logout without a circular
/// dependency.
final sessionExpiryHandlerProvider = StateProvider<void Function()?>(
  (ref) => null,
);

final refreshTokenStorageProvider = Provider<RefreshTokenStorage>(
  (ref) => SecureRefreshTokenStorage(),
);

final registrationSessionStorageProvider = Provider<RegistrationSessionStorage>(
  (ref) => SecureRegistrationSessionStorage(),
);

final tokenStoreProvider = Provider<TokenStore>(
  (ref) => TokenStore(ref.watch(refreshTokenStorageProvider)),
);

/// Dio used ONLY for refresh requests (no auth/refresh interceptors → no recursion).
final refreshDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      headers: const {'Accept': 'application/json'},
      contentType: Headers.jsonContentType,
    ),
  );
});

final tokenRefresherProvider = Provider<TokenRefresher>((ref) {
  return TokenRefresher(
    dio: ref.watch(refreshDioProvider),
    store: ref.watch(tokenStoreProvider),
  );
});

/// Central authenticated Dio client.
final dioProvider = Provider<Dio>((ref) {
  final store = ref.watch(tokenStoreProvider);
  final refresher = ref.watch(tokenRefresherProvider);
  void onExpired() {
    ref.read(sessionExpiryHandlerProvider.notifier).state?.call();
  }

  return buildApiClient(
    authInterceptor: AuthInterceptor(store),
    refreshInterceptor: RefreshInterceptor(
      dio: Dio(
        BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          connectTimeout: AppConfig.connectTimeout,
          receiveTimeout: AppConfig.receiveTimeout,
          sendTimeout: AppConfig.sendTimeout,
          headers: const {'Accept': 'application/json'},
        ),
      ),
      refresher: refresher,
      store: store,
      onSessionExpired: onExpired,
    ),
  );
});

// --- Feature API providers -------------------------------------------------

final authApiProvider = Provider<AuthApi>(
  (ref) => AuthApi(ref.watch(dioProvider)),
);

final passwordResetApiProvider = Provider<PasswordResetApi>(
  (ref) => PasswordResetApi(ref.watch(publicDioProvider)),
);

/// Plain public Dio for anonymous endpoints (registration extraction) — NO
/// auth/refresh/logging interceptors, so no JWT is ever attached.
final publicDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      headers: const {'Accept': 'application/json'},
    ),
  );
});

final registrationApiProvider = Provider<RegistrationApi>(
  (ref) => RegistrationApi(ref.watch(publicDioProvider)),
);

final patientApiProvider = Provider<PatientApi>(
  (ref) => PatientApi(ref.watch(dioProvider)),
);

final identityApiProvider = Provider<IdentityApi>(
  (ref) => IdentityApi(ref.watch(dioProvider)),
);

final minorsApiProvider = Provider<MinorsApi>(
  (ref) => MinorsApi(ref.watch(dioProvider)),
);

final minorDocumentsApiProvider = Provider<MinorDocumentsApi>(
  (ref) => MinorDocumentsApi(ref.watch(dioProvider)),
);

final documentsApiProvider = Provider<DocumentsApi>(
  (ref) => DocumentsApi(ref.watch(dioProvider)),
);

final facilitiesApiProvider = Provider<FacilitiesApi>(
  (ref) => FacilitiesApi(ref.watch(dioProvider)),
);

final archiveApiProvider = Provider<ArchiveApi>(
  (ref) => ArchiveApi(ref.watch(dioProvider)),
);

final searchApiProvider = Provider<SearchApi>(
  (ref) => SearchApi(ref.watch(dioProvider)),
);

final minorSearchApiProvider = Provider<MinorSearchApi>(
  (ref) => MinorSearchApi(ref.watch(dioProvider)),
);

final minorArchiveApiProvider = Provider<MinorArchiveApi>(
  (ref) => MinorArchiveApi(ref.watch(dioProvider)),
);

final medicalRecordsRepositoryProvider = Provider<MedicalRecordsRepository>(
  (ref) => MedicalRecordsRepository(
    documentsApi: ref.watch(documentsApiProvider),
    minorDocumentsApi: ref.watch(minorDocumentsApiProvider),
    archiveApi: ref.watch(archiveApiProvider),
    minorArchiveApi: ref.watch(minorArchiveApiProvider),
    searchApi: ref.watch(searchApiProvider),
    minorSearchApi: ref.watch(minorSearchApiProvider),
    onMinorAccessDenied: ref
        .read(patientContextControllerProvider.notifier)
        .accessDenied,
  ),
);

final claimsApiProvider = Provider<ClaimsApi>(
  (ref) => ClaimsApi(ref.watch(dioProvider)),
);
