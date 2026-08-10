import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pmdap_mobile/core/auth/token_refresher.dart';
import 'package:pmdap_mobile/core/auth/token_store.dart';
import 'package:pmdap_mobile/core/storage/refresh_token_storage.dart';

class _FakeStorage implements RefreshTokenStorage {
  String? value;
  int writes = 0;
  int clears = 0;

  @override
  Future<String?> read() async => value;

  @override
  Future<void> write(String token) async {
    value = token;
    writes++;
  }

  @override
  Future<void> clear() async {
    value = null;
    clears++;
  }
}

class _MockDio extends Mock implements Dio {}

void main() {
  group('TokenRefresher', () {
    late _FakeStorage storage;
    late TokenStore store;
    late _MockDio dio;
    late TokenRefresher refresher;

    setUp(() {
      storage = _FakeStorage();
      store = TokenStore(storage);
      dio = _MockDio();
      refresher = TokenRefresher(dio: dio, store: store);
    });

    Response<dynamic> okPair(String access, String refresh) =>
        Response<dynamic>(
          requestOptions: RequestOptions(path: '/auth/refresh/'),
          statusCode: 200,
          data: {
            'data': {'access': access, 'refresh': refresh},
          },
        );

    test('rotates tokens and updates store', () async {
      storage.value = 'old-refresh';
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => okPair('new-access', 'new-refresh'));

      final pair = await refresher.refresh();

      expect(pair, isNotNull);
      expect(pair!.access, 'new-access');
      expect(store.accessToken, 'new-access');
      expect(storage.value, 'new-refresh');
      expect(storage.writes, 1);
    });

    test(
      'returns null and clears store when no refresh token present',
      () async {
        storage.value = null;
        final pair = await refresher.refresh();
        expect(pair, isNull);
      },
    );

    test('clears store when refresh returns 401 and returns null', () async {
      storage.value = 'dead-refresh';
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/refresh/'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/auth/refresh/'),
            statusCode: 401,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final pair = await refresher.refresh();
      expect(pair, isNull);
      expect(storage.value, isNull);
      expect(storage.clears, 1);
    });

    test(
      'single-flight: concurrent callers share one refresh request',
      () async {
        storage.value = 'old-refresh';
        var calls = 0;
        when(
          () => dio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async {
          calls++;
          await Future<void>.delayed(const Duration(milliseconds: 20));
          return okPair('a$calls', 'r$calls');
        });

        final futures = [
          refresher.refresh(),
          refresher.refresh(),
          refresher.refresh(),
        ];
        final results = await Future.wait(futures);

        expect(calls, 1, reason: 'exactly one refresh request must run');
        expect(results.every((p) => p?.access == 'a1'), isTrue);
        expect(storage.writes, 1);
      },
    );
  });
}
