import 'package:fpdart/fpdart.dart';
import 'package:mobile_template/core/errors/error_handler.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/data/datasources/remote/api_service.dart';
import 'package:mobile_template/data/models/request/savings_request.dart';
import 'package:mobile_template/data/models/response/base_pagination_response.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';

class SavingsRepository {
  SavingsRepository(this._apiService);

  final ApiService _apiService;

  Future<Either<Failure, SavingsDashboardResponse>> getDashboard() async {
    try {
      final response = await _apiService.getSavingsDashboard();
      return Right(response.data!);
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }

  Future<Either<Failure, List<ImpulseItemResponse>>> getImpulses({
    bool includeInactive = true,
  }) async {
    try {
      final response = await _apiService.getImpulseItems(includeInactive);
      return Right(response.data ?? []);
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }

  Future<Either<Failure, BasePaginationResponse<SavingEventResponse>>>
  getEvents({int page = 1}) async {
    try {
      return Right(await _apiService.getSavingEvents(page, 50));
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }

  Future<Either<Failure, String>> createEvent(
    SavingEventRequest request,
  ) async => _message(() => _apiService.createSavingEvent(request));

  Future<Either<Failure, String>> deleteEvent(int id) async {
    try {
      await _apiService.deleteSavingEvent(id);
      return const Right('Deleted');
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }

  Future<Either<Failure, String>> createImpulse(
    ImpulseItemRequest request,
  ) async => _message(() => _apiService.createImpulseItem(request));

  Future<Either<Failure, String>> updateImpulse(
    int id,
    ImpulseItemRequest request,
  ) async => _message(() => _apiService.updateImpulseItem(id, request));

  Future<Either<Failure, String>> deleteImpulse(int id) async {
    try {
      await _apiService.deleteImpulseItem(id);
      return const Right('Deleted');
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }

  Future<Either<Failure, String>> createGoal(
    SavingsGoalRequest request,
  ) async => _message(() => _apiService.createSavingsGoal(request));

  Future<Either<Failure, String>> updateSettings(
    SavingsSettingsRequest request,
  ) async => _message(() => _apiService.updateSavingsSettings(request));

  Future<Either<Failure, String>> _message(
    Future<dynamic> Function() request,
  ) async {
    try {
      final response = await request();
      return Right(response.message as String);
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }
}
