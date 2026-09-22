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
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
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
      return data['message'] as String? ??
          data['error'] as String? ??
          data['detail'] as String? ??
          data['errors']?.toString();
    }

    if (data is String && data.isNotEmpty) {
      return data;
    }

    return null;
  }

  static Failure handleError(Object error) {
    if (error is DioException) {
      return handleDioError(error);
    }

    return UnknownFailure(
      message: error.toString(),
      errorCode: FailureCodes.unknown,
    );
  }
}
