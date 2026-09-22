import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteAccountUsecase {
  final AuthRepository _authRepository;

  DeleteAccountUsecase(this._authRepository);

  Future<Either<Failure, void>> call() async {
    return await _authRepository.deleteAccount();
  }
}
