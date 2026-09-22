import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/data/models/request/register_request.dart';
import 'package:mobile_template/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class RegisterUsecase {
  final AuthRepository _authRepository;

  RegisterUsecase(this._authRepository);

  Future<Either<Failure, String>> call(RegisterRequest request) async {
    return await _authRepository.register(request);
  }
}
