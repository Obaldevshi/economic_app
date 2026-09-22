import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/data/models/request/savings_request.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
import 'package:mobile_template/data/repositories/savings_repository.dart';

part 'savings_event.dart';
part 'savings_state.dart';

class SavingsBloc extends Bloc<SavingsEvent, SavingsState> {
  SavingsBloc(this._repository) : super(const SavingsState()) {
    on<LoadSavingsDashboard>(_loadDashboard);
    on<LoadImpulseItems>(_loadImpulses);
    on<LoadSavingHistory>(_loadHistory);
    on<CreateSavingEvent>(_createSaving);
    on<SaveImpulseItem>(_saveImpulse);
    on<DeleteImpulseItem>(_deleteImpulse);
    on<DeleteSavingEvent>(_deleteSaving);
    on<CreateSavingsGoal>(_createGoal);
    on<UpdateSavingsSettings>(_updateSettings);
  }

  final SavingsRepository _repository;

  Future<void> _loadDashboard(
    LoadSavingsDashboard event,
    Emitter<SavingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _repository.getDashboard();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (dashboard) => emit(
        state.copyWith(
          isLoading: false,
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
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _repository.getImpulses();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (items) => emit(
        state.copyWith(isLoading: false, impulses: items, clearFailure: true),
      ),
    );
  }

  Future<void> _loadHistory(
    LoadSavingHistory event,
    Emitter<SavingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _repository.getEvents(page: event.page);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (page) => emit(
        state.copyWith(
          isLoading: false,
          history: page.data,
          historyTotal: page.total,
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

  Future<void> _runAction(
    Emitter<SavingsState> emit,
    Future<dynamic> Function() action, {
    bool refreshDashboard = false,
    bool refreshImpulses = false,
    bool refreshHistory = false,
  }) async {
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
        if (refreshImpulses) add(const LoadImpulseItems());
        if (refreshHistory) add(const LoadSavingHistory());
      },
    );
  }
}
