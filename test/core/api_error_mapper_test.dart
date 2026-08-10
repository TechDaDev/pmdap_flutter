import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/api/api_error_mapper.dart';

void main() {
  group('ApiErrorMapper', () {
    const mapper = ApiErrorMapper();

    DioException dioError(DioExceptionType type, {int? status, Object? data}) {
      return DioException(
        type: type,
        requestOptions: RequestOptions(path: '/x'),
        response: status == null
            ? null
            : Response<Object?>(
                requestOptions: RequestOptions(path: '/x'),
                statusCode: status,
                data: data,
              ),
      );
    }

    test('maps network error without response to safe network message', () {
      final e = mapper.map(dioError(DioExceptionType.connectionError));
      expect(e.code, 'network_error');
      expect(e.isNetwork, isTrue);
    });

    test('maps timeout to safe timeout message', () {
      final e = mapper.map(dioError(DioExceptionType.connectionTimeout));
      expect(e.code, 'connection_timeout');
      expect(e.isTimeout, isTrue);
    });

    test('maps backend error envelope preserving code/message/details', () {
      final e = mapper.map(
        dioError(
          DioExceptionType.badResponse,
          status: 429,
          data: {
            'error': {
              'code': 'throttled',
              'message': 'Too many attempts.',
              'details': {},
            },
          },
        ),
      );
      expect(e.code, 'throttled');
      expect(e.message, 'Too many attempts.');
      expect(e.isThrottled, isTrue);
      expect(e.statusCode, 429);
    });

    test('maps validation error details', () {
      final e = mapper.map(
        dioError(
          DioExceptionType.badResponse,
          status: 400,
          data: {
            'error': {
              'code': 'validation_error',
              'message': 'Validation failed.',
              'details': {
                'email': ['Enter a valid email address.'],
              },
            },
          },
        ),
      );
      expect(e.code, 'validation_error');
      expect(e.firstFieldMessage, contains('email'));
    });

    test('maps invalid credentials', () {
      final e = mapper.map(
        dioError(
          DioExceptionType.badResponse,
          status: 401,
          data: {
            'error': {
              'code': 'invalid_credentials',
              'message': 'Invalid.',
              'details': {},
            },
          },
        ),
      );
      expect(e.isUnauthorized, isTrue);
      expect(e.isThrottled, isFalse);
    });

    test('maps 500 to generic server message', () {
      final e = mapper.map(
        dioError(DioExceptionType.badResponse, status: 500, data: 'boom'),
      );
      expect(e.code, 'http_500');
      expect(e.message, contains('Server'));
    });

    test('maps 404 to not found', () {
      final e = mapper.map(dioError(DioExceptionType.badResponse, status: 404));
      expect(e.isNotFound, isTrue);
    });
  });
}
