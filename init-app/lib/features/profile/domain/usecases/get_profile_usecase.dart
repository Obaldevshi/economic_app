import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/features/profile/domain/dto/profile_dto.dart';
import 'package:mobile_template/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProfileUsecase {
  final AuthRepository _authRepository;

  GetProfileUsecase(this._authRepository);

  Future<Either<Failure, ProfileDto>> call() async {
    return await _authRepository.getProfile();
  }
}
