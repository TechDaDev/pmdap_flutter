import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/auth/token_refresher.dart';
import '../../../core/auth/token_store.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/token_pair.dart';
import '../../../core/models/user.dart';
import '../data/auth_api.dart';

/// Authentication/session state.
sealed class AuthState {
  const AuthState();
}

/// Bootstrap in progress — show splash, never flash protected content.
class AuthUnknown extends AuthState {
  const AuthUnknown();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final PublicUser user;
}

/// Owns session lifecycle: restore, login, register, logout, force-logout.
///
/// Server truth comes from `/auth/me/`. The access token lives in memory via
/// [TokenStore]; the refresh token lives in secure storage.
class SessionController extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Register the session-expiry handler for the refresh interceptor.
    // Deferred with a microtask: Riverpod forbids mutating another provider
    // while this provider is still building.
    Future.microtask(() {
      ref.read(sessionExpiryHandlerProvider.notifier).state = forceLogout;
    });
    return const AuthUnknown();
  }

  TokenStore get _store => ref.read(tokenStoreProvider);
  TokenRefresher get _refresher => ref.read(tokenRefresherProvider);
  AuthApi get _authApi => ref.read(authApiProvider);

  /// On app launch: read secure refresh → refresh → /auth/me/.
  ///
  /// Defensively guarded: if secure storage is unavailable (fresh install,
  /// Keystore locked, platform error) or a call stalls, we degrade to the
  /// signed-out state instead of leaving the user stuck on the splash screen.
  Future<void> restoreSession() async {
    try {
      final refresh = await _store.readRefresh().timeout(
        const Duration(seconds: 5),
      );
      if (refresh == null || refresh.isEmpty) {
        state = const AuthUnauthenticated();
        return;
      }
      final pair = await _refresher.refresh();
      if (pair == null) {
        state = const AuthUnauthenticated();
        return;
      }
      final user = await _authApi.me();
      state = AuthAuthenticated(user);
    } on ApiException {
      await _store.clearAll();
      state = const AuthUnauthenticated();
    } catch (_) {
      // Storage/platform failure or timeout: treat as signed out.
      state = const AuthUnauthenticated();
    }
  }

  /// Valid login: stores tokens, loads current user.
  Future<void> login({required String email, required String password}) async {
    final pair = await _authApi.login(email: email, password: password);
    _store.setAccess(pair.access);
    await _store.writeRefresh(pair.refresh);
    final user = await _authApi.me();
    state = AuthAuthenticated(user);
  }

  /// Registration does NOT return tokens; the user signs in afterwards.
  Future<PublicUser> register({
    required String email,
    String? phone,
    required String password,
    required PatientRegistrationInput patient,
  }) {
    return _authApi.register(
      email: email,
      phone: phone,
      password: password,
      patient: patient,
    );
  }

  Future<void> logout() async {
    final refresh = await _store.readRefresh();
    if (refresh != null && refresh.isNotEmpty) {
      try {
        await _authApi.logout(refresh);
      } catch (_) {
        // Best-effort: local session is cleared regardless.
      }
    }
    await _store.clearAll();
    state = const AuthUnauthenticated();
  }

  /// Called by the refresh interceptor when a refresh attempt fails.
  Future<void> forceLogout() async {
    await _store.clearAll();
    state = const AuthUnauthenticated();
  }

  /// Swaps in a fresh token pair issued by the server (e.g. after a password
  /// change) while keeping the current authenticated user signed in.
  Future<void> applyFreshSession(TokenPair pair) async {
    _store.setAccess(pair.access);
    await _store.writeRefresh(pair.refresh);
  }
}

final sessionControllerProvider =
    NotifierProvider<SessionController, AuthState>(SessionController.new);

final authStateProvider = Provider<AuthState>((ref) {
  return ref.watch(sessionControllerProvider);
});

final currentUserProvider = Provider<PublicUser?>((ref) {
  final state = ref.watch(sessionControllerProvider);
  if (state is AuthAuthenticated) return state.user;
  return null;
});
