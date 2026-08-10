import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstraction over where the refresh token lives so tests can use a fake.
abstract class RefreshTokenStorage {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> clear();
}

/// Secure storage-backed implementation.
///
/// The refresh token is a long-lived secret: it MUST live in platform secure
/// storage (Keychain/Keystore), never in SharedPreferences or plain files.
class SecureRefreshTokenStorage implements RefreshTokenStorage {
  SecureRefreshTokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _refreshKey = 'pmdap_refresh_token';

  @override
  Future<String?> read() => _storage.read(key: _refreshKey);

  @override
  Future<void> write(String token) =>
      _storage.write(key: _refreshKey, value: token);

  @override
  Future<void> clear() => _storage.delete(key: _refreshKey);
}
