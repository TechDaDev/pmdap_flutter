import 'package:dio/dio.dart';

import '../models/token_pair.dart';
import 'token_store.dart';

/// Coordinates refresh-token rotation with single-flight semantics:
/// only ONE refresh request may run at a time; concurrent callers wait on the
/// same future. On failure the tokens are cleared.
///
/// Uses its own [Dio] (no auth/refresh interceptors) to avoid recursion when
/// the refresh request itself is intercepted.
class TokenRefresher {
  TokenRefresher({required this.dio, required this.store});

  final Dio dio;
  final TokenStore store;

  Future<TokenPair?>? _inFlight;

  /// Whether a refresh is currently running.
  bool get isRefreshing => _inFlight != null;

  Future<TokenPair?> refresh() {
    final current = _inFlight;
    if (current != null) return current;
    final future = _doRefresh();
    _inFlight = future;
    return future.whenComplete(() => _inFlight = null);
  }

  Future<TokenPair?> _doRefresh() async {
    final refresh = await store.readRefresh();
    if (refresh == null || refresh.isEmpty) {
      await store.clearAll();
      return null;
    }
    try {
      final response = await dio.post<dynamic>(
        '/auth/refresh/',
        data: {'refresh': refresh},
        options: Options(extra: {'pmdap_no_auth': true}),
      );
      final data = response.data;
      if (data is Map<String, dynamic> &&
          data['data'] is Map<String, dynamic>) {
        final pair = TokenPair.fromJson(data['data'] as Map<String, dynamic>);
        store.setAccess(pair.access);
        await store.writeRefresh(pair.refresh);
        return pair;
      }
      await store.clearAll();
      return null;
    } on DioException catch (e) {
      // Refresh/auth endpoints returning 401/400 mean the refresh token is
      // dead — never retry refresh in response to a failed refresh.
      final status = e.response?.statusCode;
      if (status == 401 || status == 400) {
        await store.clearAll();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
