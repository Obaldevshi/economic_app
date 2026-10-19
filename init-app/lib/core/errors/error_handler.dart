import 'package:dio/dio.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/core/errors/failure_codes.dart';

/// Utility class to handle and convert exceptions to Failure objects.
class ErrorHandler {
  ErrorHandler._();

  static Failure handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutFailure();

      case DioExceptionType.connectionError:
        return const NoInternetFailure();

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return const UnknownFailure(errorCode: FailureCodes.requestCancelled);

      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        return UnknownFailure(
          message: error.message ?? '',
          errorCode: FailureCodes.unknown,
        );
    }
  }

  static Failure _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final serverMessage = _extractErrorMessage(error.response?.data);

    switch (statusCode) {
      case 400:
        return ValidationFailure(
          message: serverMessage ?? '',
          statusCode: statusCode,
          errorCode: serverMessage == null
              ? FailureCodes.validationFailed
              : null,
        );

      case 401:
        return AuthFailure(
          message: serverMessage ?? '',
          statusCode: statusCode,
          errorCode: serverMessage == null
              ? FailureCodes.invalidCredentials
              : null,
        );

      case 403:
        return AuthFailure(
          message: serverMessage ?? '',
          statusCode: statusCode,
          errorCode: serverMessage == null
              ? FailureCodes.accessForbidden
              : null,
        );

      case 404:
        return ServerFailure(
          message: serverMessage ?? '',
          statusCode: statusCode,
          errorCode: serverMessage == null
              ? FailureCodes.resourceNotFound
              : null,
        );

      case 409:
        return ValidationFailure(
          message: serverMessage ?? '',
          statusCode: statusCode,
          errorCode: serverMessage == null ? FailureCodes.resourceExists : null,
        );

      case 422:
        return ValidationFailure(
          message: serverMessage ?? '',
          statusCode: statusCode,
          errorCode: serverMessage == null
              ? FailureCodes.validationFailed
              : null,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerFailure(
          message: serverMessage ?? '',
          statusCode: statusCode,
          errorCode: serverMessage == null ? FailureCodes.serverError : null,
        );

      default:
        return ServerFailure(
          message: serverMessage ?? error.message ?? '',
          statusCode: statusCode,
          errorCode: serverMessage == null ? FailureCodes.serverError : null,
        );
    }
  }

  static String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      for (final key in ['message', 'error', 'detail', 'errors']) {
        final value = data[key];
        if (value is String && value.isNotEmpty) return value;
        // FastAPI's standard 422 detail is a list, not a string. Extract only
        // messages, never echoed input values (which may contain a password).
        if (value is List) {
          final messages = value
              .whereType<Map>()
              .map((entry) => entry['msg'])
              .whereType<String>()
              .where((message) => message.isNotEmpty)
              .take(5)
              .toList();
          if (messages.isNotEmpty) return messages.join('\n');
        }
      }
      return null;
    }

    if (data is String && data.isNotEmpty) {
      return data;
    }

    return null;
  }

  static Failure handleError(Object error) {
    if (error is Failure) return error;
    if (error is DioException) {
      return handleDioError(error);
    }

    return UnknownFailure(
      message: error.toString(),
      errorCode: FailureCodes.unknown,
    );
  }
}
