import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/api/api_exception.dart';
import 'package:pmdap_mobile/core/auth/token_refresher.dart';
import 'package:pmdap_mobile/core/auth/token_store.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/token_pair.dart';
import 'package:pmdap_mobile/core/models/user.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/storage/refresh_token_storage.dart';
import 'package:pmdap_mobile/features/auth/application/session_controller.dart';
import 'package:pmdap_mobile/features/auth/data/auth_api.dart';

class _FakeStorage implements RefreshTokenStorage {
  String? value;
  int clears = 0;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String token) async => value = token;
  @override
  Future<void> clear() async {
    value = null;
    clears++;
  }
}

class _FakeAuthApi extends AuthApi {
  _FakeAuthApi() : super(Dio());

  int loginCalls = 0;
  bool failLogin = false;
  bool failMe = false;

  @override
  Future<TokenPair> login({
    required String email,
    required String password,
  }) async {
    loginCalls++;
    if (failLogin) {
      throw const ApiException(
        code: 'invalid_credentials',
        message: 'Invalid.',
      );
    }
    return const TokenPair(access: 'access-1', refresh: 'refresh-1');
  }

  @override
  Future<PublicUser> me() async {
    if (failMe)
      throw const ApiException(code: 'not_authenticated', message: 'Nope.');
    return const PublicUser(
      uuid: 'u1',
      email: 'p@example.com',
      role: Role.patient,
    );
  }

  @override
  Future<void> logout(String refresh) async {}
}

class _FakeRefresher extends TokenRefresher {
  _FakeRefresher(TokenStore store) : super(dio: Dio(), store: store);

  bool fail = false;

  @override
  Future<TokenPair?> refresh() async {
    if (fail) {
      await store.clearAll();
      return null;
    }
    store.setAccess('new-access');
    await store.writeRefresh('new-refresh');
    return const TokenPair(access: 'new-access', refresh: 'new-refresh');
  }
}

void main() {
  late _FakeStorage storage;
  late _FakeAuthApi authApi;
  late ProviderContainer container;

  setUp(() {
    storage = _FakeStorage();
    authApi = _FakeAuthApi();
  });

  ProviderContainer buildContainer() {
    return ProviderContainer(
      overrides: [
        refreshTokenStorageProvider.overrideWithValue(storage),
        authApiProvider.overrideWithValue(authApi),
        tokenRefresherProvider.overrideWith((ref) {
          final store = ref.watch(tokenStoreProvider);
          return _FakeRefresher(store);
        }),
      ],
    );
  }

  tearDown(() => container.dispose());

  test('build starts in unknown state', () {
    container = buildContainer();
    expect(container.read(sessionControllerProvider), isA<AuthUnknown>());
  });

  test('restoreSession with no refresh token → unauthenticated', () async {
    container = buildContainer();
    storage.value = null;
    await container.read(sessionControllerProvider.notifier).restoreSession();
    expect(
      container.read(sessionControllerProvider),
      isA<AuthUnauthenticated>(),
    );
  });

  test('restoreSession refreshes + loads me → authenticated', () async {
    container = buildContainer();
    storage.value = 'stored-refresh';
    await container.read(sessionControllerProvider.notifier).restoreSession();
    final state = container.read(sessionControllerProvider);
    expect(state, isA<AuthAuthenticated>());
    expect((state as AuthAuthenticated).user.email, 'p@example.com');
    expect(storage.value, 'new-refresh');
  });

  test(
    'restoreSession when refresh fails → unauthenticated and cleared',
    () async {
      container = buildContainer();
      storage.value = 'stored-refresh';
      (container.read(tokenRefresherProvider) as _FakeRefresher).fail = true;
      await container.read(sessionControllerProvider.notifier).restoreSession();
      expect(
        container.read(sessionControllerProvider),
        isA<AuthUnauthenticated>(),
      );
      expect(storage.value, isNull);
    },
  );

  test('login stores tokens and becomes authenticated', () async {
    container = buildContainer();
    await container
        .read(sessionControllerProvider.notifier)
        .login(email: 'p@example.com', password: 'secret');
    final state = container.read(sessionControllerProvider);
    expect(state, isA<AuthAuthenticated>());
    expect(container.read(tokenStoreProvider).accessToken, 'access-1');
    expect(storage.value, 'refresh-1');
    expect(authApi.loginCalls, 1);
  });

  test('login with invalid credentials propagates ApiException', () async {
    container = buildContainer();
    authApi.failLogin = true;
    expect(
      () => container
          .read(sessionControllerProvider.notifier)
          .login(email: 'x@y.z', password: 'bad'),
      throwsA(isA<ApiException>()),
    );
    expect(container.read(sessionControllerProvider), isA<AuthUnknown>());
  });

  test('forceLogout clears session and tokens', () async {
    container = buildContainer();
    storage.value = 'refresh-1';
    await container.read(sessionControllerProvider.notifier).forceLogout();
    expect(
      container.read(sessionControllerProvider),
      isA<AuthUnauthenticated>(),
    );
    expect(storage.value, isNull);
    expect(container.read(tokenStoreProvider).accessToken, isNull);
  });
}
