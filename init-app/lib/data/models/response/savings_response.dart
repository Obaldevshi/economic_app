import 'package:json_annotation/json_annotation.dart';

part 'savings_response.g.dart';

double _moneyFromJson(Object? value) => switch (value) {
  num number => number.toDouble(),
  String text => double.tryParse(text) ?? 0,
  _ => 0,
};

DateTime _eventTimeFromJson(String value) {
  // Older API responses have no suffix but contain UTC container timestamps.
  final zoned = RegExp(r'(Z|[+-]\d{2}:\d{2})$').hasMatch(value)
      ? value
      : '${value}Z';
  return DateTime.parse(zoned).toLocal();
}

String _eventTimeToJson(DateTime value) => value.toUtc().toIso8601String();

@JsonSerializable(explicitToJson: true)
class SavingsSyncResponse {
  @JsonKey(name: 'entity_id')
  final int? entityId;
  SavingsSyncResponse({this.entityId});
  factory SavingsSyncResponse.fromJson(Map<String, dynamic> json) =>
      _$SavingsSyncResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SavingsSyncResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ImpulseItemResponse {
  Map<String, dynamic> toJson() => _$ImpulseItemResponseToJson(this);
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  final int id;
  final String name;
  @JsonKey(name: 'default_amount', fromJson: _moneyFromJson)
  final double defaultAmount;
  @JsonKey(name: 'icon_key')
  final String iconKey;
  @JsonKey(name: 'weekly_frequency')
  final int weeklyFrequency;
  @JsonKey(name: 'is_active')
  final bool isActive;

  ImpulseItemResponse({
    this.currencyCode = 'RUB',
    required this.id,
    required this.name,
    required this.defaultAmount,
    required this.iconKey,
    required this.weeklyFrequency,
    required this.isActive,
  });

  factory ImpulseItemResponse.fromJson(Map<String, dynamic> json) =>
      _$ImpulseItemResponseFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class SavingEventResponse {
  Map<String, dynamic> toJson() => _$SavingEventResponseToJson(this);
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  final int id;
  @JsonKey(name: 'impulse_item_id')
  final int? impulseItemId;
  @JsonKey(name: 'impulse_name')
  final String impulseName;
  @JsonKey(fromJson: _moneyFromJson)
  final double amount;
  @JsonKey(
    name: 'occurred_at',
    fromJson: _eventTimeFromJson,
    toJson: _eventTimeToJson,
  )
  final DateTime occurredAt;
  @JsonKey(name: 'is_invested')
  final bool isInvested;
  final String? note;

  SavingEventResponse({
    this.currencyCode = 'RUB',
    required this.id,
    this.impulseItemId,
    required this.impulseName,
    required this.amount,
    required this.occurredAt,
    required this.isInvested,
    this.note,
  });

  factory SavingEventResponse.fromJson(Map<String, dynamic> json) =>
      _$SavingEventResponseFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class SpentEventResponse {
  final int id;
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @JsonKey(name: 'impulse_item_id')
  final int? impulseItemId;
  @JsonKey(name: 'impulse_name')
  final String impulseName;
  @JsonKey(fromJson: _moneyFromJson)
  final double amount;
  @JsonKey(
    name: 'occurred_at',
    fromJson: _eventTimeFromJson,
    toJson: _eventTimeToJson,
  )
  final DateTime occurredAt;
  final String? note;
  SpentEventResponse({
    required this.id,
    required this.currencyCode,
    this.impulseItemId,
    required this.impulseName,
    required this.amount,
    required this.occurredAt,
    this.note,
  });
  factory SpentEventResponse.fromJson(Map<String, dynamic> json) =>
      _$SpentEventResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SpentEventResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SpentHistoryResponse {
  final List<SpentEventResponse> items;
  final int total;
  @JsonKey(name: 'total_amount', fromJson: _moneyFromJson)
  final double totalAmount;
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  final int page;
  @JsonKey(name: 'per_page')
  final int perPage;
  SpentHistoryResponse({
    required this.items,
    required this.total,
    required this.totalAmount,
    required this.currencyCode,
    required this.page,
    required this.perPage,
  });
  factory SpentHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$SpentHistoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SpentHistoryResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SavingsGoalResponse {
  Map<String, dynamic> toJson() => _$SavingsGoalResponseToJson(this);
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  final int id;
  final String name;
  @JsonKey(name: 'target_amount', fromJson: _moneyFromJson)
  final double targetAmount;
  @JsonKey(name: 'allocated_amount', fromJson: _moneyFromJson)
  final double allocatedAmount;

  SavingsGoalResponse({
    this.currencyCode = 'RUB',
    required this.id,
    required this.name,
    required this.targetAmount,
    this.allocatedAmount = 0,
  });

  factory SavingsGoalResponse.fromJson(Map<String, dynamic> json) =>
      _$SavingsGoalResponseFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class WeeklyReceiptResponse {
  Map<String, dynamic> toJson() => _$WeeklyReceiptResponseToJson(this);
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @JsonKey(name: 'end_date')
  final DateTime endDate;
  @JsonKey(name: 'total_saved', fromJson: _moneyFromJson)
  final double totalSaved;
  @JsonKey(name: 'invested_total', fromJson: _moneyFromJson)
  final double investedTotal;
  @JsonKey(name: 'decision_count')
  final int decisionCount;

  WeeklyReceiptResponse({
    this.currencyCode = 'RUB',
    required this.startDate,
    required this.endDate,
    required this.totalSaved,
    required this.investedTotal,
    required this.decisionCount,
  });
  factory WeeklyReceiptResponse.fromJson(Map<String, dynamic> json) =>
      _$WeeklyReceiptResponseFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class MonthlySavingPoint {
  Map<String, dynamic> toJson() => _$MonthlySavingPointToJson(this);
  final String month;
  @JsonKey(fromJson: _moneyFromJson)
  final double amount;

  MonthlySavingPoint({required this.month, required this.amount});

  factory MonthlySavingPoint.fromJson(Map<String, dynamic> json) =>
      _$MonthlySavingPointFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class ProjectionPoint {
  Map<String, dynamic> toJson() => _$ProjectionPointToJson(this);
  final int year;
  @JsonKey(fromJson: _moneyFromJson)
  final double contributions;
  @JsonKey(fromJson: _moneyFromJson)
  final double interest;
  @JsonKey(fromJson: _moneyFromJson)
  final double total;

  ProjectionPoint({
    required this.year,
    required this.contributions,
    required this.interest,
    required this.total,
  });

  factory ProjectionPoint.fromJson(Map<String, dynamic> json) =>
      _$ProjectionPointFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class ImpulseTotal {
  Map<String, dynamic> toJson() => _$ImpulseTotalToJson(this);
  final String name;
  @JsonKey(fromJson: _moneyFromJson)
  final double amount;

  ImpulseTotal({required this.name, required this.amount});

  factory ImpulseTotal.fromJson(Map<String, dynamic> json) =>
      _$ImpulseTotalFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class SavingsSettingsResponse {
  Map<String, dynamic> toJson() => _$SavingsSettingsResponseToJson(this);
  @JsonKey(name: 'display_currency')
  final String displayCurrency;
  @JsonKey(name: 'financial_region')
  final String financialRegion;
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @JsonKey(name: 'annual_rate', fromJson: _moneyFromJson)
  final double annualRate;
  @JsonKey(name: 'projection_years')
  final int projectionYears;

  SavingsSettingsResponse({
    this.displayCurrency = 'RUB',
    this.financialRegion = 'RU',
    this.currencyCode = 'RUB',
    required this.annualRate,
    required this.projectionYears,
  });

  factory SavingsSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$SavingsSettingsResponseFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class SavingsDashboardResponse {
  Map<String, dynamic> toJson() => _$SavingsDashboardResponseToJson(this);
  @JsonKey(name: 'display_currency')
  final String displayCurrency;
  @JsonKey(name: 'financial_region')
  final String financialRegion;
  @JsonKey(name: 'exchange_rates')
  final ExchangeRatesResponse? exchangeRates;
  @JsonKey(name: 'regional_presets')
  final List<FinancialPresetResponse> regionalPresets;
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @JsonKey(name: 'today_total', fromJson: _moneyFromJson)
  final double todayTotal;
  @JsonKey(name: 'month_total', fromJson: _moneyFromJson)
  final double monthTotal;
  @JsonKey(name: 'total_saved', fromJson: _moneyFromJson)
  final double totalSaved;
  @JsonKey(name: 'invested_total', fromJson: _moneyFromJson)
  final double investedTotal;
  @JsonKey(name: 'monthly_pace', fromJson: _moneyFromJson)
  final double monthlyPace;
  @JsonKey(name: 'annual_rate', fromJson: _moneyFromJson)
  final double annualRate;
  @JsonKey(name: 'projection_years')
  final int projectionYears;
  @JsonKey(name: 'projected_total', fromJson: _moneyFromJson)
  final double projectedTotal;
  @JsonKey(name: 'projected_interest', fromJson: _moneyFromJson)
  final double projectedInterest;
  @JsonKey(name: 'monthly_series')
  final List<MonthlySavingPoint> monthlySeries;
  @JsonKey(name: 'projection_series')
  final List<ProjectionPoint> projectionSeries;
  @JsonKey(name: 'impulse_totals')
  final List<ImpulseTotal> impulseTotals;
  @JsonKey(name: 'recent_events')
  final List<SavingEventResponse> recentEvents;
  final List<SavingsGoalResponse> goals;

  SavingsDashboardResponse({
    this.displayCurrency = 'RUB',
    this.financialRegion = 'RU',
    this.exchangeRates,
    this.regionalPresets = const [],
    this.currencyCode = 'RUB',
    required this.todayTotal,
    required this.monthTotal,
    required this.totalSaved,
    required this.investedTotal,
    required this.monthlyPace,
    required this.annualRate,
    required this.projectionYears,
    required this.projectedTotal,
    required this.projectedInterest,
    required this.monthlySeries,
    required this.projectionSeries,
    required this.impulseTotals,
    required this.recentEvents,
    required this.goals,
  });

  factory SavingsDashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$SavingsDashboardResponseFromJson(json);
}

Map<String, double> _ratesFromJson(Map<String, dynamic>? values) => {
  for (final entry in (values ?? <String, dynamic>{}).entries)
    entry.key: _moneyFromJson(entry.value),
};

@JsonSerializable(explicitToJson: true)
class ExchangeRatesResponse {
  Map<String, dynamic> toJson() => _$ExchangeRatesResponseToJson(this);
  @JsonKey(name: 'as_of')
  final DateTime? asOf;
  @JsonKey(name: 'is_stale')
  final bool isStale;
  final String source;
  @JsonKey(name: 'rub_per_unit', fromJson: _ratesFromJson)
  final Map<String, double> rubPerUnit;
  ExchangeRatesResponse({
    this.asOf,
    this.isStale = true,
    this.source = '',
    this.rubPerUnit = const {},
  });
  factory ExchangeRatesResponse.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRatesResponseFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class FinancialPresetResponse {
  Map<String, dynamic> toJson() => _$FinancialPresetResponseToJson(this);
  final String region;
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @JsonKey(name: 'annual_rate', fromJson: _moneyFromJson)
  final double annualRate;
  @JsonKey(name: 'rate_reference')
  final String rateReference;
  @JsonKey(name: 'rate_source')
  final String rateSource;
  FinancialPresetResponse({
    required this.region,
    required this.currencyCode,
    required this.annualRate,
    this.rateReference = '',
    this.rateSource = '',
  });
  factory FinancialPresetResponse.fromJson(Map<String, dynamic> json) =>
      _$FinancialPresetResponseFromJson(json);
}
