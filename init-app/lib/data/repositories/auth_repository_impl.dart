import 'dart:async';
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
import 'package:dio/dio.dart';
import 'package:mobile_template/core/services/offline_savings_service.dart';
import 'package:mobile_template/core/services/app_lock_service.dart';
import 'package:mobile_template/data/models/response/base_response.dart';
import 'package:mobile_template/data/models/response/profile_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final SessionService _sessionService;

  final OfflineSavingsService _offline;
  final AppLockService _lock;
  AuthRepositoryImpl(
    this._apiService,
    this._sessionService,
    this._offline,
    this._lock,
  );

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _loginWithRetry(request);
      final loginData = response.data!;
      await _sessionService.saveToken(
        accessToken: loginData.accessToken,
        tokenType: loginData.tokenType,
        expiresIn: loginData.expiresIn,
      );
      unawaited(getProfile().then((_) {}));
      return Right(loginData);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  Future<BaseResponse<LoginResponse>> _loginWithRetry(
    LoginRequest request,
  ) async {
    try {
      return await _apiService.login(request);
    } on DioException catch (error) {
      if (error.type != DioExceptionType.connectionError &&
          error.type != DioExceptionType.connectionTimeout &&
          error.type != DioExceptionType.receiveTimeout) {
        rethrow;
      }
      // A first DNS/TLS connection may fail while the phone reconnects.
      // Login has no financial side effects; never retry registration/writes.
      await Future<void>.delayed(const Duration(milliseconds: 600));
      return _apiService.login(request);
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
      final json = await _offline.read('profile', () async {
        final p = (await _apiService.getProfile()).data!;
        return {
          'id': p.id,
          'email': p.email,
          'first_name': p.firstName,
          'last_name': p.lastName,
          'created_at': p.createdAt,
          'updated_at': p.updatedAt,
        };
      });
      final profile = ProfileDto.fromResponse(
        ProfileResponse.fromJson(Map<String, dynamic>.from(json)),
      );
      return Right(profile);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, String>> updateProfile(
    UpdateProfileRequest request,
  ) async {
    final account = _sessionService.accountId;
    try {
      final response = await _apiService.updateProfile(request);
      if (_sessionService.accountId == account) {
        await _offline.updateCachedProfile(request.toJson());
      }
      return Right(response.message);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    final account = _sessionService.accountId;
    try {
      await _apiService.deleteAccount();
      await _offline.purgeAccount(account);
      await _lock.purge(account);
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
