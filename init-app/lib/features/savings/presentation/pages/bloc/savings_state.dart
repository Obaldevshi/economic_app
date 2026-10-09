part of 'savings_bloc.dart';

class SavingsState extends Equatable {
  const SavingsState({
    this.isDashboardLoading = false,
    this.isImpulseLoading = false,
    this.dashboardLoadFailed = false,
    this.impulseLoadFailed = false,
    this.historyLoadFailed = false,
    this.isSaving = false,
    this.dashboard,
    this.settings,
    this.impulses = const [],
    this.history = const [],
    this.historyTotal = 0,
    this.historyPage = 0,
    this.hasMoreHistory = false,
    this.isHistoryLoading = false,
    this.failure,
    this.actionMessage,
    this.weeklyReceipt,
    this.isReceiptLoading = false,
  });

  final bool isDashboardLoading;
  final bool isImpulseLoading;
  final bool dashboardLoadFailed;
  final bool impulseLoadFailed;
  final bool historyLoadFailed;
  bool get isLoading => isDashboardLoading || isImpulseLoading;
  final bool isSaving;
  final SavingsDashboardResponse? dashboard;
  final SavingsSettingsResponse? settings;
  final List<ImpulseItemResponse> impulses;
  final List<SavingEventResponse> history;
  final int historyTotal;
  final int historyPage;
  final bool hasMoreHistory;
  final bool isHistoryLoading;
  final Failure? failure;
  final String? actionMessage;
  final WeeklyReceiptResponse? weeklyReceipt;
  final bool isReceiptLoading;

  SavingsState copyWith({
    bool? isDashboardLoading,
    bool? isImpulseLoading,
    bool? dashboardLoadFailed,
    bool? impulseLoadFailed,
    bool? historyLoadFailed,
    bool? isSaving,
    SavingsDashboardResponse? dashboard,
    SavingsSettingsResponse? settings,
    List<ImpulseItemResponse>? impulses,
    List<SavingEventResponse>? history,
    int? historyTotal,
    int? historyPage,
    bool? hasMoreHistory,
    bool? isHistoryLoading,
    Failure? failure,
    String? actionMessage,
    bool clearFailure = false,
    bool clearMessage = false,
    WeeklyReceiptResponse? weeklyReceipt,
    bool? isReceiptLoading,
    bool clearReceipt = false,
  }) => SavingsState(
    isDashboardLoading: isDashboardLoading ?? this.isDashboardLoading,
    isImpulseLoading: isImpulseLoading ?? this.isImpulseLoading,
    dashboardLoadFailed: dashboardLoadFailed ?? this.dashboardLoadFailed,
    impulseLoadFailed: impulseLoadFailed ?? this.impulseLoadFailed,
    historyLoadFailed: historyLoadFailed ?? this.historyLoadFailed,
    isSaving: isSaving ?? this.isSaving,
    dashboard: dashboard ?? this.dashboard,
    settings: settings ?? this.settings,
    impulses: impulses ?? this.impulses,
    history: history ?? this.history,
    historyTotal: historyTotal ?? this.historyTotal,
    historyPage: historyPage ?? this.historyPage,
    hasMoreHistory: hasMoreHistory ?? this.hasMoreHistory,
    isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
    failure: clearFailure ? null : failure ?? this.failure,
    actionMessage: clearMessage ? null : actionMessage ?? this.actionMessage,
    weeklyReceipt: clearReceipt ? null : weeklyReceipt ?? this.weeklyReceipt,
    isReceiptLoading: isReceiptLoading ?? this.isReceiptLoading,
  );

  @override
  List<Object?> get props => [
    isDashboardLoading,
    isImpulseLoading,
    dashboardLoadFailed,
    impulseLoadFailed,
    historyLoadFailed,
    isSaving,
    dashboard,
    settings,
    impulses,
    history,
    historyTotal,
    historyPage,
    hasMoreHistory,
    isHistoryLoading,
    failure,
    actionMessage,
    weeklyReceipt,
    isReceiptLoading,
  ];
}
