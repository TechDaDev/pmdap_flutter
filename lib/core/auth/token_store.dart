import '../storage/refresh_token_storage.dart';

/// Holds access token in memory only and refresh token in secure storage.
///
/// Access tokens are short-lived (5 min) — memory-only avoids persisting JWTs.
/// The refresh token is the only persisted credential.
class TokenStore {
  TokenStore(this._refreshStorage);

  final RefreshTokenStorage _refreshStorage;

  /// In-memory access token. Never persisted, never logged.
  String? accessToken;

  Future<String?> readRefresh() => _refreshStorage.read();

  Future<void> writeRefresh(String token) => _refreshStorage.write(token);

  /// Atomically update the in-memory access token.
  void setAccess(String token) => accessToken = token;

  /// Clear both access (memory) and refresh (secure storage).
  Future<void> clearAll() async {
    accessToken = null;
    await _refreshStorage.clear();
  }
}
