import 'package:mobile_template/core/errors/error_handler.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:mobile_template/data/datasources/remote/api_service.dart';
import 'package:mobile_template/data/models/request/change_password_request.dart';
import 'package:mobile_template/data/models/request/login_request.dart';
import 'package:mobile_template/data/models/request/register_request.dart';
import 'package:mobile_template/data/models/request/update_profile_request.dart';
import 'package:mobile_template/data/models/response/login_response.dart';
import 'package:mobile_template/features/profile/domain/dto/profile_dto.dart';
import 'package:mobile_template/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final SessionService _sessionService;

  AuthRepositoryImpl(this._apiService, this._sessionService);

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _apiService.login(request);
      final loginData = response.data!;
      await _sessionService.saveToken(
        accessToken: loginData.accessToken,
        tokenType: loginData.tokenType,
        expiresIn: loginData.expiresIn,
      );
      return Right(loginData);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, String>> register(RegisterRequest request) async {
    try {
      final response = await _apiService.register(request);
      return Right(response.message);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, ProfileDto>> getProfile() async {
    try {
      final response = await _apiService.getProfile();
      final profile = ProfileDto.fromResponse(response.data!);
      return Right(profile);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, String>> updateProfile(
    UpdateProfileRequest request,
  ) async {
    try {
      final response = await _apiService.updateProfile(request);
      return Right(response.message);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _apiService.deleteAccount();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, String>> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      final response = await _apiService.changePassword(request);
      return Right(response.message);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }
}
