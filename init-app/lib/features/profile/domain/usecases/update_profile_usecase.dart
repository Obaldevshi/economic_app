import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/data/models/request/update_profile_request.dart';
import 'package:mobile_template/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateProfileUsecase {
  final AuthRepository _authRepository;

  UpdateProfileUsecase(this._authRepository);

  Future<Either<Failure, String>> call(UpdateProfileRequest request) async {
    return await _authRepository.updateProfile(request);
  }
}
