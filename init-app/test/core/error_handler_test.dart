import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_template/core/errors/error_handler.dart';
import 'package:mobile_template/core/errors/failure.dart';

void main() {
  Failure responseFailure(int code, Object body) {
    final request = RequestOptions(path: '/auth/password-reset/confirm');
    return ErrorHandler.handleError(
      DioException(
        requestOptions: request,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: request,
          statusCode: code,
          data: body,
        ),
      ),
    );
  }

  test(
    'FastAPI validation details never throw or expose echoed credentials',
    () {
      final failure = responseFailure(422, {
        'detail': [
          {
            'msg': 'Invalid value',
            'input': 'sensitive-test-input',
            'loc': ['body', 'new_password'],
          },
        ],
      });
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, 'Invalid value');
      expect(failure.message, isNot(contains('sensitive-test-input')));
    },
  );

  test('malformed error shapes fall back safely', () {
    for (final body in [
      {
        'detail': {'unexpected': true},
      },
      {'message': 5, 'detail': []},
      {
        'errors': [
          {'input': 'sensitive-test-input'},
        ],
      },
    ]) {
      expect(responseFailure(422, body), isA<ValidationFailure>());
    }
  });

  test('normal API error messages stay compatible', () {
    expect(
      responseFailure(400, {'message': 'Invalid code'}).message,
      'Invalid code',
    );
    expect(
      responseFailure(401, {'detail': 'Unauthorized'}),
      isA<AuthFailure>(),
    );
    expect(
      responseFailure(503, 'Temporarily unavailable'),
      isA<ServerFailure>(),
    );
  });

  test('connection failures and timeouts remain distinguishable', () {
    final request = RequestOptions(path: '/auth/login');
    expect(
      ErrorHandler.handleError(
        DioException(
          requestOptions: request,
          type: DioExceptionType.connectionError,
        ),
      ),
      isA<NoInternetFailure>(),
    );
    expect(
      ErrorHandler.handleError(
        DioException(
          requestOptions: request,
          type: DioExceptionType.connectionTimeout,
        ),
      ),
      isA<TimeoutFailure>(),
    );
  });
}
