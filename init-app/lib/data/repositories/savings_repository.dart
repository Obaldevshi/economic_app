import 'package:fpdart/fpdart.dart';
import 'package:mobile_template/core/errors/error_handler.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/core/services/offline_savings_service.dart';
import 'package:mobile_template/data/datasources/remote/api_service.dart';
import 'package:mobile_template/data/models/request/savings_request.dart';
import 'package:mobile_template/data/models/response/base_pagination_response.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';

class SavingsRepository {
  SavingsRepository(this._apiService, this._offline);
  final ApiService _apiService;
  final OfflineSavingsService _offline;

  Future<Either<Failure, T>> _read<T>(
    String resource,
    Future<dynamic> Function() remote,
    T Function(Map<String, dynamic>) decode,
  ) async {
    try {
      return Right(
        decode(
          Map<String, dynamic>.from(await _offline.read(resource, remote)),
        ),
      );
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }

  Future<Either<Failure, WeeklyReceiptResponse>> getWeeklyReceipt() => _read(
    'receipt',
    () async => (await _apiService.getWeeklyReceipt()).data!.toJson(),
    WeeklyReceiptResponse.fromJson,
  );

  Future<Either<Failure, SavingsDashboardResponse>> getDashboard() => _read(
    'dashboard',
    () async => (await _apiService.getSavingsDashboard()).data!.toJson(),
    SavingsDashboardResponse.fromJson,
  );

  Future<Either<Failure, SavingsSettingsResponse>> getSettings() => _read(
    'settings',
    () async => (await _apiService.getSavingsSettings()).data!.toJson(),
    SavingsSettingsResponse.fromJson,
  );

  Future<Either<Failure, List<ImpulseItemResponse>>> getImpulses({
    bool includeInactive = true,
  }) async {
    try {
      final items = await _offline.read(
        'impulses',
        () async => (await _apiService.getImpulseItems(
          true,
        )).data!.map((item) => item.toJson()).toList(),
      );
      return Right(
        (items as List)
            .map(
              (item) =>
                  ImpulseItemResponse.fromJson(Map<String, dynamic>.from(item)),
            )
            .where((item) => includeInactive || item.isActive)
            .toList(),
      );
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }

  Future<Either<Failure, BasePaginationResponse<SavingEventResponse>>>
  getEvents({int page = 1}) => _read(
    'events:$page',
    () async {
      final response = await _apiService.getSavingEvents(page, 50);
      return {
        'message': response.message,
        'total': response.total,
        'page': response.page,
        'per_page': response.perPage,
        'data': response.data.map((e) => e.toJson()).toList(),
      };
    },
    (json) => BasePaginationResponse.fromJson(
      json,
      (item) =>
          SavingEventResponse.fromJson(Map<String, dynamic>.from(item as Map)),
    ),
  );

  Future<Either<Failure, String>> allocateGoal(
    int id,
    GoalAllocationRequest request,
  ) => _message(
    'allocate_goal',
    request.toJson(),
    () => _apiService.allocateSavingsGoal(id, request),
    id,
  );

  Future<Either<Failure, SpentHistoryResponse>> getSpent({int page = 1}) =>
      _read(
        'spent:$page',
        () async =>
            (await _apiService.getSpentHistory(page, 50)).data!.toJson(),
        SpentHistoryResponse.fromJson,
      );

  Future<Either<Failure, String>> saveSpent(
    SpentEventRequest request, {
    int? id,
  }) => _message(
    id == null ? 'create_spent' : 'update_spent',
    request.toJson(),
    () => id == null
        ? _apiService.createSpentEvent(request)
        : _apiService.updateSpentEvent(id, request),
    id,
  );

  Future<Either<Failure, String>> deleteSpent(int id) =>
      _message('delete_spent', {}, () async {
        await _apiService.deleteSpentEvent(id);
        return null;
      }, id);

  Future<Either<Failure, String>> createEvent(SavingEventRequest request) =>
      _message(
        'create_event',
        request.toJson(),
        () => _apiService.createSavingEvent(request),
      );
  Future<Either<Failure, String>> updateEvent(
    int id,
    SavingEventRequest request,
  ) => _message(
    'update_event',
    request.toJson(),
    () => _apiService.updateSavingEvent(id, request),
    id,
  );
  Future<Either<Failure, String>> deleteEvent(int id) =>
      _message('delete_event', {}, () async {
        await _apiService.deleteSavingEvent(id);
        return null;
      }, id);
  Future<Either<Failure, String>> createImpulse(ImpulseItemRequest request) =>
      _message(
        'create_impulse',
        request.toJson(),
        () => _apiService.createImpulseItem(request),
      );
  Future<Either<Failure, String>> updateImpulse(
    int id,
    ImpulseItemRequest request,
  ) => _message(
    'update_impulse',
    request.toJson(),
    () => _apiService.updateImpulseItem(id, request),
    id,
  );
  Future<Either<Failure, String>> deleteImpulse(int id) =>
      _message('delete_impulse', {}, () async {
        await _apiService.deleteImpulseItem(id);
        return null;
      }, id);
  Future<Either<Failure, String>> createGoal(SavingsGoalRequest request) =>
      _message(
        'create_goal',
        request.toJson(),
        () => _apiService.createSavingsGoal(request),
      );
  Future<Either<Failure, String>> updateGoal(
    int id,
    SavingsGoalRequest request,
  ) => _message(
    'update_goal',
    request.toJson(),
    () => _apiService.updateSavingsGoal(id, request),
    id,
  );
  Future<Either<Failure, String>> updateSettings(
    SavingsSettingsRequest request,
  ) async {
    if (_offline.enabled &&
        request.currencyCode != null &&
        request.currencyCode != _offline.settings['currency_code']) {
      try {
        return Right(await _offline.switchLedger(request));
      } catch (error) {
        return Left(ErrorHandler.handleError(error));
      }
    }
    return _message(
      'update_settings',
      request.toJson(),
      () => _apiService.updateSavingsSettings(request),
    );
  }

  Future<Either<Failure, String>> _message(
    String kind,
    Map<String, dynamic> payload,
    Future<dynamic> Function() remote, [
    int? id,
  ]) async {
    try {
      if (_offline.enabled) {
        return Right(await _offline.write(kind, payload, id));
      }
      final response = await remote();
      return Right(response == null ? 'Deleted' : response.message as String);
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }
}
