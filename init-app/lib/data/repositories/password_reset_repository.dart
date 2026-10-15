import 'package:fpdart/fpdart.dart';
import 'package:mobile_template/core/errors/error_handler.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:mobile_template/data/datasources/remote/api_service.dart';
import 'package:mobile_template/data/models/request/password_reset_request.dart';

class PasswordResetRepository {
  PasswordResetRepository(this._api, this._session);
  final ApiService _api;
  final SessionService _session;

  // Recovery is online-only and is never added to the financial outbox.
  Future<Either<Failure, void>> requestCode(
    PasswordResetRequest request,
  ) async {
    try {
      await _api.requestPasswordReset(request);
      return const Right(null);
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }

  Future<Either<Failure, void>> confirm(
    PasswordResetConfirmRequest request,
  ) async {
    try {
      await _api.confirmPasswordReset(request);
      // Keep the local journal/PIN/outbox. Re-authentication is still required
      // before the revoked server session can synchronize anything.
      if (_session.accountEmail?.toLowerCase() == request.email.toLowerCase()) {
        _session.requireOnlineLogin();
      }
      return const Right(null);
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }
}
