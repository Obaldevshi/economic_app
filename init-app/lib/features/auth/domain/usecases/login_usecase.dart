import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/data/models/request/login_request.dart';
import 'package:mobile_template/features/auth/domain/dto/login_dto.dart';
import 'package:mobile_template/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LoginUsecase {
  final AuthRepository _authRepository;

  LoginUsecase(this._authRepository);

  Future<Either<Failure, LoginDto>> call(LoginRequest request) async {
    return await _authRepository.login(request).then((value) {
      return value.map((response) => LoginDto.fromLoginResponse(response));
    });
  }
}
