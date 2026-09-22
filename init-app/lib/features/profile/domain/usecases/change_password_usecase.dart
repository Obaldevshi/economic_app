import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/data/models/request/change_password_request.dart';
import 'package:mobile_template/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChangePasswordUsecase {
  final AuthRepository _authRepository;

  ChangePasswordUsecase(this._authRepository);

  Future<Either<Failure, String>> call(ChangePasswordRequest request) async {
    return await _authRepository.changePassword(request);
  }
}
