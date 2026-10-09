import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/core/services/savings_native_service.dart';
import 'package:mobile_template/data/models/request/savings_request.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
import 'package:mobile_template/data/repositories/savings_repository.dart';

part 'savings_event.dart';
part 'savings_state.dart';

class SavingsBloc extends Bloc<SavingsEvent, SavingsState> {
  SavingsBloc(this._repository, this._native) : super(const SavingsState()) {
    on<LoadSavingsDashboard>(_loadDashboard);
    on<LoadImpulseItems>(_loadImpulses);
    on<LoadSavingHistory>(_loadHistory);
    on<CreateSavingEvent>(_createSaving);
    on<UpdateSavingEvent>(_updateSaving);
    on<SaveImpulseItem>(_saveImpulse);
    on<DeleteImpulseItem>(_deleteImpulse);
    on<DeleteSavingEvent>(_deleteSaving);
    on<CreateSavingsGoal>(_createGoal);
    on<UpdateSavingsGoal>(_updateGoal);
    on<AllocateSavingsGoal>(
      (event, emit) => _runAction(
        emit,
        () => _repository.allocateGoal(event.id, event.request),
        refreshDashboard: true,
      ),
    );
    on<LoadWeeklyReceipt>((event, emit) async {
      if (state.isReceiptLoading) return;
      emit(
        state.copyWith(
          isReceiptLoading: true,
          clearReceipt: true,
          clearFailure: true,
        ),
      );
      final result = await _repository.getWeeklyReceipt();
      result.fold(
        (failure) =>
            emit(state.copyWith(isReceiptLoading: false, failure: failure)),
        (receipt) => emit(
          state.copyWith(isReceiptLoading: false, weeklyReceipt: receipt),
        ),
      );
    });
    on<UpdateSavingsSettings>(_updateSettings);
  }

  final SavingsRepository _repository;
  final SavingsNativeService _native;
  int _dashboardRequestId = 0;
  int _impulseRequestId = 0;
  int _historyRequestId = 0;

  Future<void> _loadDashboard(
    LoadSavingsDashboard event,
    Emitter<SavingsState> emit,
  ) async {
    final requestId = ++_dashboardRequestId;
    emit(
      state.copyWith(
        isDashboardLoading: true,
        dashboardLoadFailed: false,
        clearFailure: true,
      ),
    );
    final result = await _repository.getDashboard();
    if (requestId != _dashboardRequestId) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          isDashboardLoading: false,
          dashboardLoadFailed: true,
          failure: failure,
        ),
      ),
      (dashboard) => emit(
        state.copyWith(
          isDashboardLoading: false,
          dashboard: dashboard,
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> _loadImpulses(
    LoadImpulseItems event,
    Emitter<SavingsState> emit,
  ) async {
    final requestId = ++_impulseRequestId;
    final sessionRevision = _native.sessionRevision;
    emit(
      state.copyWith(
        isImpulseLoading: true,
        impulseLoadFailed: false,
        clearFailure: true,
      ),
    );
    final settingsFuture = event.withSettings
        ? _repository.getSettings()
        : null;
    final result = await _repository.getImpulses();
    if (requestId != _impulseRequestId) return;
    if (settingsFuture == null) {
      result.fold(
        (failure) => emit(
          state.copyWith(
            isImpulseLoading: false,
            impulseLoadFailed: true,
            failure: failure,
          ),
        ),
        (items) => emit(
          state.copyWith(
            isImpulseLoading: false,
            impulses: items,
            clearFailure: true,
          ),
        ),
      );
      result.fold((_) {}, (items) {
        _native.syncItems(items, sessionRevision);
      });
      return;
    }

    final settingsResult = await settingsFuture;
    if (requestId != _impulseRequestId) return;
    settingsResult.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (settings) => emit(state.copyWith(settings: settings)),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          isImpulseLoading: false,
          impulseLoadFailed: true,
          failure: failure,
        ),
      ),
      (items) => emit(state.copyWith(isImpulseLoading: false, impulses: items)),
    );
    result.fold((_) {}, (items) {
      _native.syncItems(items, sessionRevision);
    });
  }

  Future<void> _loadHistory(
    LoadSavingHistory event,
    Emitter<SavingsState> emit,
  ) async {
    if (event.append &&
        (state.isHistoryLoading ||
            !state.hasMoreHistory ||
            event.page != state.historyPage + 1))
      return;
    final requestId = ++_historyRequestId;
    emit(
      state.copyWith(
        isHistoryLoading: true,
        historyLoadFailed: false,
        clearFailure: true,
      ),
    );
    final result = await _repository.getEvents(page: event.page);
    // A refresh or mutation supersedes an in-flight next-page request.
    if (requestId != _historyRequestId) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          isHistoryLoading: false,
          historyLoadFailed: true,
          failure: failure,
        ),
      ),
      (page) => emit(
        state.copyWith(
          isHistoryLoading: false,
          history: event.append
              ? {
                  for (final item in [...state.history, ...page.data])
                    item.id: item,
                }.values.toList()
              : page.data,
          historyTotal: page.total,
          historyPage: page.page,
          hasMoreHistory:
              page.data.isNotEmpty && page.page * page.perPage < page.total,
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> _createSaving(
    CreateSavingEvent event,
    Emitter<SavingsState> emit,
  ) async => _runAction(
    emit,
    () => _repository.createEvent(event.request),
    refreshDashboard: true,
    refreshHistory: true,
  );

  Future<void> _saveImpulse(
    SaveImpulseItem event,
    Emitter<SavingsState> emit,
  ) async => _runAction(
    emit,
    () => event.id == null
        ? _repository.createImpulse(event.request)
        : _repository.updateImpulse(event.id!, event.request),
    refreshImpulses: true,
  );

  Future<void> _updateSaving(
    UpdateSavingEvent event,
    Emitter<SavingsState> emit,
  ) async => _runAction(
    emit,
    () => _repository.updateEvent(event.id, event.request),
    refreshDashboard: true,
    refreshHistory: true,
  );

  Future<void> _deleteImpulse(
    DeleteImpulseItem event,
    Emitter<SavingsState> emit,
  ) async => _runAction(
    emit,
    () => _repository.deleteImpulse(event.id),
    refreshImpulses: true,
  );

  Future<void> _deleteSaving(
    DeleteSavingEvent event,
    Emitter<SavingsState> emit,
  ) async => _runAction(
    emit,
    () => _repository.deleteEvent(event.id),
    refreshDashboard: true,
    refreshHistory: true,
  );

  Future<void> _createGoal(
    CreateSavingsGoal event,
    Emitter<SavingsState> emit,
  ) async => _runAction(
    emit,
    () => _repository.createGoal(event.request),
    refreshDashboard: true,
  );

  Future<void> _updateSettings(
    UpdateSavingsSettings event,
    Emitter<SavingsState> emit,
  ) async => _runAction(
    emit,
    () => _repository.updateSettings(event.request),
    refreshDashboard: true,
  );

  Future<void> _updateGoal(
    UpdateSavingsGoal event,
    Emitter<SavingsState> emit,
  ) async => _runAction(
    emit,
    () => _repository.updateGoal(event.id, event.request),
    refreshDashboard: true,
  );

  Future<void> _runAction(
    Emitter<SavingsState> emit,
    Future<dynamic> Function() action, {
    bool refreshDashboard = false,
    bool refreshImpulses = false,
    bool refreshHistory = false,
  }) async {
    if (state.isSaving) return;
    emit(
      state.copyWith(isSaving: true, clearFailure: true, clearMessage: true),
    );
    final result = await action();
    result.fold(
      (Failure failure) =>
          emit(state.copyWith(isSaving: false, failure: failure)),
      (dynamic message) {
        emit(
          state.copyWith(
            isSaving: false,
            actionMessage: message as String,
            clearFailure: true,
          ),
        );
        if (refreshDashboard) add(const LoadSavingsDashboard());
        if (refreshImpulses) {
          add(const LoadImpulseItems(withSettings: true));
        }
        if (refreshHistory) add(const LoadSavingHistory());
      },
    );
  }
}
