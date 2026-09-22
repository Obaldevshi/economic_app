part of 'savings_bloc.dart';

class SavingsState extends Equatable {
  const SavingsState({
    this.isLoading = false,
    this.isSaving = false,
    this.dashboard,
    this.impulses = const [],
    this.history = const [],
    this.historyTotal = 0,
    this.failure,
    this.actionMessage,
  });

  final bool isLoading;
  final bool isSaving;
  final SavingsDashboardResponse? dashboard;
  final List<ImpulseItemResponse> impulses;
  final List<SavingEventResponse> history;
  final int historyTotal;
  final Failure? failure;
  final String? actionMessage;

  SavingsState copyWith({
    bool? isLoading,
    bool? isSaving,
    SavingsDashboardResponse? dashboard,
    List<ImpulseItemResponse>? impulses,
    List<SavingEventResponse>? history,
    int? historyTotal,
    Failure? failure,
    String? actionMessage,
    bool clearFailure = false,
    bool clearMessage = false,
  }) => SavingsState(
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    dashboard: dashboard ?? this.dashboard,
    impulses: impulses ?? this.impulses,
    history: history ?? this.history,
    historyTotal: historyTotal ?? this.historyTotal,
    failure: clearFailure ? null : failure ?? this.failure,
    actionMessage: clearMessage ? null : actionMessage ?? this.actionMessage,
  );

  @override
  List<Object?> get props => [
    isLoading,
    isSaving,
    dashboard,
    impulses,
    history,
    historyTotal,
    failure,
    actionMessage,
  ];
}
