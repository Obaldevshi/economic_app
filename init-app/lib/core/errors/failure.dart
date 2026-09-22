import 'package:equatable/equatable.dart';
import 'package:mobile_template/core/errors/failure_codes.dart';

/// Abstract base class for all failures.
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const Failure({this.message = '', this.statusCode, this.errorCode});

  bool get hasLocalizedFallback => message.isEmpty && errorCode != null;

  @override
  List<Object?> get props => [message, statusCode, errorCode];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message, super.statusCode, super.errorCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message, super.statusCode, super.errorCode});
}

class AuthFailure extends Failure {
  const AuthFailure({super.message, super.statusCode, super.errorCode});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message, super.statusCode, super.errorCode});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message, super.statusCode, super.errorCode});
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message,
    super.statusCode,
    super.errorCode = FailureCodes.unknown,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.statusCode,
    super.errorCode = FailureCodes.timeout,
  }) : super(message: '');
}

class NoInternetFailure extends Failure {
  const NoInternetFailure({
    super.statusCode,
    super.errorCode = FailureCodes.noInternet,
  }) : super(message: '');
}
