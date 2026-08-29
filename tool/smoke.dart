// Real-backend smoke test for the PMDAP mobile client.
//
// Exercises the frozen /api/v1/ contract against the live local backend using
// only SYNTHETIC users and data. Prints a summary — never tokens, passwords,
// or medical/identity content.
//
// Usage:
//   dart run tool/smoke.dart
//   PMDAP_API_BASE_URL=http://192.168.88.20:8000/api/v1 dart run tool/smoke.dart
//
// Exit code 0 on success, 1 on any failed step.
import 'dart:io';

import 'package:dio/dio.dart';

const String _baseUrl = String.fromEnvironment(
  'PMDAP_API_BASE_URL',
  defaultValue: 'http://localhost:8000/api/v1',
);

void main(List<String> args) async {
  final base = Platform.environment['PMDAP_API_BASE_URL'] ?? _baseUrl;
  final dio = Dio(
    BaseOptions(
      baseUrl: base,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  var failures = 0;
  Future<void> step(String name, Future<void> Function() run) async {
    try {
      await run();
      stdout.writeln('  ok   $name');
    } catch (e) {
      failures++;
      stdout.writeln('  FAIL $name: ${_safe(e)}');
    }
  }

  stdout.writeln('PMDAP smoke -> $base');

  // 1. health
  await step('health', () async {
    final r = await dio.get<dynamic>('/health/');
    final ok = r.data is Map && r.data['status'] == 'ok';
    if (!ok) throw StateError('health not ok');
  });

  // Synthetic account credentials MUST come from the environment (never
  // hardcoded). Login-first so repeat runs avoid the register throttle
  // (auth_register = 5/hour per IP on the frozen backend). Create the account
  // once manually (see README), then:
  //   PMDAP_SMOKE_EMAIL=... PMDAP_SMOKE_PASSWORD=... dart run tool/smoke.dart
  final email = Platform.environment['PMDAP_SMOKE_EMAIL'];
  final password = Platform.environment['PMDAP_SMOKE_PASSWORD'];
  if (email == null || email.isEmpty || password == null || password.isEmpty) {
    stdout.writeln(
      'Set PMDAP_SMOKE_EMAIL and PMDAP_SMOKE_PASSWORD to a synthetic dev account.',
    );
    exit(1);
  }

  String? access;

  // 2. ensure synthetic account exists (register only when missing)
  await step('register (create-if-missing)', () async {
    try {
      await dio.post<dynamic>(
        '/auth/login/',
        data: {'email': email, 'password': password},
      );
    } on DioException catch (e) {
      final isInvalid = e.response?.statusCode == 401;
      if (!isInvalid) rethrow; // throttled etc. → account must exist already
      final r = await dio.post<dynamic>(
        '/auth/register/',
        data: {
          'email': email,
          'password': password,
          'patient': {
            'full_name': 'PMDAP Smoke Synthetic',
            'date_of_birth': '1992-04-05',
            'sex': 'MALE',
            'nationality': 'IQ',
            'blood_group': 'O+',
          },
        },
      );
      if (r.statusCode != 201) {
        throw StateError('register status ${r.statusCode}');
      }
    }
  });

  // 3. login
  await step('login', () async {
    final r = await dio.post<dynamic>(
      '/auth/login/',
      data: {'email': email, 'password': password},
    );
    final data = (r.data as Map)['data'] as Map;
    access = data['access'] as String;
    if (access == null || access!.isEmpty) throw StateError('no access token');
    dio.options.headers['Authorization'] = 'Bearer $access';
  });

  // 4. me
  await step('auth/me', () async {
    final r = await dio.get<dynamic>('/auth/me/');
    final data = (r.data as Map)['data'] as Map;
    if (data['email'] != email) throw StateError('me email mismatch');
  });

  // 5. profile
  await step('patients/me', () async {
    final r = await dio.get<dynamic>('/patients/me/');
    final data = (r.data as Map)['data'] as Map;
    if (data['digital_id'] == null) throw StateError('missing digital_id');
  });

  // 6. facilities
  await step('facilities', () async {
    final r = await dio.get<dynamic>('/facilities/');
    final data = (r.data as Map)['data'] as Map;
    if (data['count'] is! num) {
      throw StateError('facilities pagination missing');
    }
  });

  // 7. documents list (new account → empty is fine)
  await step('documents', () async {
    final r = await dio.get<dynamic>('/documents/');
    final data = (r.data as Map)['data'] as Map;
    if (data['results'] is! List) throw StateError('documents list missing');
  });

  // 8. archive + summary
  await step('archive', () async {
    final r = await dio.get<dynamic>('/archive/');
    final data = (r.data as Map)['data'] as Map;
    if (data['results'] is! List) throw StateError('archive list missing');
  });
  await step('archive/summary', () async {
    final r = await dio.get<dynamic>('/archive/summary/');
    final data = (r.data as Map)['data'] as Map;
    if (data['unconfirmed_date_count'] is! num) {
      throw StateError('archive summary missing');
    }
  });

  // 9. search (lexical; no query logging — results may be empty)
  await step('search', () async {
    final r = await dio.get<dynamic>(
      '/search/',
      queryParameters: {'q': 'synthetic'},
    );
    final data = (r.data as Map)['data'] as Map;
    if (data['results'] is! List) throw StateError('search list missing');
  });

  // 10. logout (needs a refresh token from login)
  await step('logout', () async {
    final login = await dio.post<dynamic>(
      '/auth/login/',
      data: {'email': email, 'password': password},
    );
    final data = (login.data as Map)['data'] as Map;
    await dio.post<dynamic>(
      '/auth/logout/',
      data: {'refresh': data['refresh']},
    );
  });

  stdout.writeln(
    failures == 0 ? 'SMOKE PASSED' : 'SMOKE FAILED with $failures failure(s)',
  );
  exit(failures == 0 ? 0 : 1);
}

String _safe(Object e) {
  if (e is DioException) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    if (data is Map && data['error'] is Map) {
      final err = data['error'] as Map;
      return 'HTTP $status ${err['code']}: ${err['message']} ${err['details']}';
    }
    return 'HTTP ${status ?? 'no-response'}';
  }
  return e.toString().split('\n').first;
}
