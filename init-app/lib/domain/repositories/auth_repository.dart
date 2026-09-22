import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/data/models/request/change_password_request.dart';
import 'package:mobile_template/data/models/request/login_request.dart';
import 'package:mobile_template/data/models/request/register_request.dart';
import 'package:mobile_template/data/models/request/update_profile_request.dart';
import 'package:mobile_template/data/models/response/login_response.dart';
import 'package:mobile_template/features/profile/domain/dto/profile_dto.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, LoginResponse>> login(LoginRequest request);
  Future<Either<Failure, String>> register(RegisterRequest request);

  Future<Either<Failure, ProfileDto>> getProfile();
  Future<Either<Failure, String>> updateProfile(UpdateProfileRequest request);
  Future<Either<Failure, void>> deleteAccount();
  Future<Either<Failure, String>> changePassword(ChangePasswordRequest request);
}
