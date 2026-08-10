import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/auth/token_store.dart';
import 'package:pmdap_mobile/core/storage/refresh_token_storage.dart';

/// In-memory fake of the secure refresh-token storage.
class FakeRefreshStorage implements RefreshTokenStorage {
  String? value;

  @override
  Future<String?> read() async => value;

  @override
  Future<void> write(String token) async => value = token;

  @override
  Future<void> clear() async => value = null;
}

void main() {
  group('TokenStore', () {
    late FakeRefreshStorage storage;
    late TokenStore store;

    setUp(() {
      storage = FakeRefreshStorage();
      store = TokenStore(storage);
    });

    test('access token lives only in memory', () {
      expect(store.accessToken, isNull);
      store.setAccess('abc');
      expect(store.accessToken, 'abc');
      expect(storage.value, isNull); // not persisted
    });

    test('refresh token is written to secure storage', () async {
      await store.writeRefresh('refresh-1');
      expect(await store.readRefresh(), 'refresh-1');
    });

    test('clearAll clears both access and refresh', () async {
      store.setAccess('abc');
      await store.writeRefresh('refresh-1');
      await store.clearAll();
      expect(store.accessToken, isNull);
      expect(await store.readRefresh(), isNull);
    });
  });
}
