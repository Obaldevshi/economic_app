// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImpulseItemResponse _$ImpulseItemResponseFromJson(Map<String, dynamic> json) =>
    ImpulseItemResponse(
      currencyCode: json['currency_code'] as String? ?? 'RUB',
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      defaultAmount: _moneyFromJson(json['default_amount']),
      iconKey: json['icon_key'] as String,
      weeklyFrequency: (json['weekly_frequency'] as num).toInt(),
      isActive: json['is_active'] as bool,
    );

SavingEventResponse _$SavingEventResponseFromJson(Map<String, dynamic> json) =>
    SavingEventResponse(
      currencyCode: json['currency_code'] as String? ?? 'RUB',
      id: (json['id'] as num).toInt(),
      impulseItemId: (json['impulse_item_id'] as num?)?.toInt(),
      impulseName: json['impulse_name'] as String,
      amount: _moneyFromJson(json['amount']),
      occurredAt: DateTime.parse(json['occurred_at'] as String),
      isInvested: json['is_invested'] as bool,
      note: json['note'] as String?,
    );

SavingsGoalResponse _$SavingsGoalResponseFromJson(Map<String, dynamic> json) =>
    SavingsGoalResponse(
      currencyCode: json['currency_code'] as String? ?? 'RUB',
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      targetAmount: _moneyFromJson(json['target_amount']),
      allocatedAmount: json['allocated_amount'] == null
          ? 0
          : _moneyFromJson(json['allocated_amount']),
    );

WeeklyReceiptResponse _$WeeklyReceiptResponseFromJson(
  Map<String, dynamic> json,
) => WeeklyReceiptResponse(
  currencyCode: json['currency_code'] as String? ?? 'RUB',
  startDate: DateTime.parse(json['start_date'] as String),
  endDate: DateTime.parse(json['end_date'] as String),
  totalSaved: _moneyFromJson(json['total_saved']),
  investedTotal: _moneyFromJson(json['invested_total']),
  decisionCount: (json['decision_count'] as num).toInt(),
);

MonthlySavingPoint _$MonthlySavingPointFromJson(Map<String, dynamic> json) =>
    MonthlySavingPoint(
      month: json['month'] as String,
      amount: _moneyFromJson(json['amount']),
    );

ProjectionPoint _$ProjectionPointFromJson(Map<String, dynamic> json) =>
    ProjectionPoint(
      year: (json['year'] as num).toInt(),
      contributions: _moneyFromJson(json['contributions']),
      interest: _moneyFromJson(json['interest']),
      total: _moneyFromJson(json['total']),
    );

ImpulseTotal _$ImpulseTotalFromJson(Map<String, dynamic> json) => ImpulseTotal(
  name: json['name'] as String,
  amount: _moneyFromJson(json['amount']),
);

SavingsSettingsResponse _$SavingsSettingsResponseFromJson(
  Map<String, dynamic> json,
) => SavingsSettingsResponse(
  displayCurrency: json['display_currency'] as String? ?? 'RUB',
  financialRegion: json['financial_region'] as String? ?? 'RU',
  currencyCode: json['currency_code'] as String? ?? 'RUB',
  annualRate: _moneyFromJson(json['annual_rate']),
  projectionYears: (json['projection_years'] as num).toInt(),
);

SavingsDashboardResponse _$SavingsDashboardResponseFromJson(
  Map<String, dynamic> json,
) => SavingsDashboardResponse(
  displayCurrency: json['display_currency'] as String? ?? 'RUB',
  financialRegion: json['financial_region'] as String? ?? 'RU',
  exchangeRates: json['exchange_rates'] == null
      ? null
      : ExchangeRatesResponse.fromJson(
          json['exchange_rates'] as Map<String, dynamic>,
        ),
  regionalPresets:
      (json['regional_presets'] as List<dynamic>?)
          ?.map(
            (e) => FinancialPresetResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  currencyCode: json['currency_code'] as String? ?? 'RUB',
  todayTotal: _moneyFromJson(json['today_total']),
  monthTotal: _moneyFromJson(json['month_total']),
  totalSaved: _moneyFromJson(json['total_saved']),
  investedTotal: _moneyFromJson(json['invested_total']),
  monthlyPace: _moneyFromJson(json['monthly_pace']),
  annualRate: _moneyFromJson(json['annual_rate']),
  projectionYears: (json['projection_years'] as num).toInt(),
  projectedTotal: _moneyFromJson(json['projected_total']),
  projectedInterest: _moneyFromJson(json['projected_interest']),
  monthlySeries: (json['monthly_series'] as List<dynamic>)
      .map((e) => MonthlySavingPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
  projectionSeries: (json['projection_series'] as List<dynamic>)
      .map((e) => ProjectionPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
  impulseTotals: (json['impulse_totals'] as List<dynamic>)
      .map((e) => ImpulseTotal.fromJson(e as Map<String, dynamic>))
      .toList(),
  recentEvents: (json['recent_events'] as List<dynamic>)
      .map((e) => SavingEventResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  goals: (json['goals'] as List<dynamic>)
      .map((e) => SavingsGoalResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

ExchangeRatesResponse _$ExchangeRatesResponseFromJson(
  Map<String, dynamic> json,
) => ExchangeRatesResponse(
  asOf: json['as_of'] == null ? null : DateTime.parse(json['as_of'] as String),
  isStale: json['is_stale'] as bool? ?? true,
  source: json['source'] as String? ?? '',
  rubPerUnit: json['rub_per_unit'] == null
      ? const {}
      : _ratesFromJson(json['rub_per_unit'] as Map<String, dynamic>?),
);

FinancialPresetResponse _$FinancialPresetResponseFromJson(
  Map<String, dynamic> json,
) => FinancialPresetResponse(
  region: json['region'] as String,
  currencyCode: json['currency_code'] as String,
  annualRate: _moneyFromJson(json['annual_rate']),
  rateReference: json['rate_reference'] as String? ?? '',
  rateSource: json['rate_source'] as String? ?? '',
);
