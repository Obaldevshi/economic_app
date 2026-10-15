// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavingsSyncResponse _$SavingsSyncResponseFromJson(Map<String, dynamic> json) =>
    SavingsSyncResponse(entityId: (json['entity_id'] as num?)?.toInt());

Map<String, dynamic> _$SavingsSyncResponseToJson(
  SavingsSyncResponse instance,
) => <String, dynamic>{'entity_id': instance.entityId};

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

Map<String, dynamic> _$ImpulseItemResponseToJson(
  ImpulseItemResponse instance,
) => <String, dynamic>{
  'currency_code': instance.currencyCode,
  'id': instance.id,
  'name': instance.name,
  'default_amount': instance.defaultAmount,
  'icon_key': instance.iconKey,
  'weekly_frequency': instance.weeklyFrequency,
  'is_active': instance.isActive,
};

SavingEventResponse _$SavingEventResponseFromJson(Map<String, dynamic> json) =>
    SavingEventResponse(
      currencyCode: json['currency_code'] as String? ?? 'RUB',
      id: (json['id'] as num).toInt(),
      impulseItemId: (json['impulse_item_id'] as num?)?.toInt(),
      impulseName: json['impulse_name'] as String,
      amount: _moneyFromJson(json['amount']),
      occurredAt: _eventTimeFromJson(json['occurred_at'] as String),
      isInvested: json['is_invested'] as bool,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$SavingEventResponseToJson(
  SavingEventResponse instance,
) => <String, dynamic>{
  'currency_code': instance.currencyCode,
  'id': instance.id,
  'impulse_item_id': instance.impulseItemId,
  'impulse_name': instance.impulseName,
  'amount': instance.amount,
  'occurred_at': _eventTimeToJson(instance.occurredAt),
  'is_invested': instance.isInvested,
  'note': instance.note,
};

SpentEventResponse _$SpentEventResponseFromJson(Map<String, dynamic> json) =>
    SpentEventResponse(
      id: (json['id'] as num).toInt(),
      currencyCode: json['currency_code'] as String,
      impulseItemId: (json['impulse_item_id'] as num?)?.toInt(),
      impulseName: json['impulse_name'] as String,
      amount: _moneyFromJson(json['amount']),
      occurredAt: _eventTimeFromJson(json['occurred_at'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$SpentEventResponseToJson(SpentEventResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'currency_code': instance.currencyCode,
      'impulse_item_id': instance.impulseItemId,
      'impulse_name': instance.impulseName,
      'amount': instance.amount,
      'occurred_at': _eventTimeToJson(instance.occurredAt),
      'note': instance.note,
    };

SpentHistoryResponse _$SpentHistoryResponseFromJson(
  Map<String, dynamic> json,
) => SpentHistoryResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => SpentEventResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  totalAmount: _moneyFromJson(json['total_amount']),
  currencyCode: json['currency_code'] as String,
  page: (json['page'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
);

Map<String, dynamic> _$SpentHistoryResponseToJson(
  SpentHistoryResponse instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'total_amount': instance.totalAmount,
  'currency_code': instance.currencyCode,
  'page': instance.page,
  'per_page': instance.perPage,
};

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

Map<String, dynamic> _$SavingsGoalResponseToJson(
  SavingsGoalResponse instance,
) => <String, dynamic>{
  'currency_code': instance.currencyCode,
  'id': instance.id,
  'name': instance.name,
  'target_amount': instance.targetAmount,
  'allocated_amount': instance.allocatedAmount,
};

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

Map<String, dynamic> _$WeeklyReceiptResponseToJson(
  WeeklyReceiptResponse instance,
) => <String, dynamic>{
  'currency_code': instance.currencyCode,
  'start_date': instance.startDate.toIso8601String(),
  'end_date': instance.endDate.toIso8601String(),
  'total_saved': instance.totalSaved,
  'invested_total': instance.investedTotal,
  'decision_count': instance.decisionCount,
};

MonthlySavingPoint _$MonthlySavingPointFromJson(Map<String, dynamic> json) =>
    MonthlySavingPoint(
      month: json['month'] as String,
      amount: _moneyFromJson(json['amount']),
    );

Map<String, dynamic> _$MonthlySavingPointToJson(MonthlySavingPoint instance) =>
    <String, dynamic>{'month': instance.month, 'amount': instance.amount};

ProjectionPoint _$ProjectionPointFromJson(Map<String, dynamic> json) =>
    ProjectionPoint(
      year: (json['year'] as num).toInt(),
      contributions: _moneyFromJson(json['contributions']),
      interest: _moneyFromJson(json['interest']),
      total: _moneyFromJson(json['total']),
    );

Map<String, dynamic> _$ProjectionPointToJson(ProjectionPoint instance) =>
    <String, dynamic>{
      'year': instance.year,
      'contributions': instance.contributions,
      'interest': instance.interest,
      'total': instance.total,
    };

ImpulseTotal _$ImpulseTotalFromJson(Map<String, dynamic> json) => ImpulseTotal(
  name: json['name'] as String,
  amount: _moneyFromJson(json['amount']),
);

Map<String, dynamic> _$ImpulseTotalToJson(ImpulseTotal instance) =>
    <String, dynamic>{'name': instance.name, 'amount': instance.amount};

SavingsSettingsResponse _$SavingsSettingsResponseFromJson(
  Map<String, dynamic> json,
) => SavingsSettingsResponse(
  displayCurrency: json['display_currency'] as String? ?? 'RUB',
  financialRegion: json['financial_region'] as String? ?? 'RU',
  currencyCode: json['currency_code'] as String? ?? 'RUB',
  annualRate: _moneyFromJson(json['annual_rate']),
  projectionYears: (json['projection_years'] as num).toInt(),
);

Map<String, dynamic> _$SavingsSettingsResponseToJson(
  SavingsSettingsResponse instance,
) => <String, dynamic>{
  'display_currency': instance.displayCurrency,
  'financial_region': instance.financialRegion,
  'currency_code': instance.currencyCode,
  'annual_rate': instance.annualRate,
  'projection_years': instance.projectionYears,
};

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

Map<String, dynamic> _$SavingsDashboardResponseToJson(
  SavingsDashboardResponse instance,
) => <String, dynamic>{
  'display_currency': instance.displayCurrency,
  'financial_region': instance.financialRegion,
  'exchange_rates': instance.exchangeRates?.toJson(),
  'regional_presets': instance.regionalPresets.map((e) => e.toJson()).toList(),
  'currency_code': instance.currencyCode,
  'today_total': instance.todayTotal,
  'month_total': instance.monthTotal,
  'total_saved': instance.totalSaved,
  'invested_total': instance.investedTotal,
  'monthly_pace': instance.monthlyPace,
  'annual_rate': instance.annualRate,
  'projection_years': instance.projectionYears,
  'projected_total': instance.projectedTotal,
  'projected_interest': instance.projectedInterest,
  'monthly_series': instance.monthlySeries.map((e) => e.toJson()).toList(),
  'projection_series': instance.projectionSeries
      .map((e) => e.toJson())
      .toList(),
  'impulse_totals': instance.impulseTotals.map((e) => e.toJson()).toList(),
  'recent_events': instance.recentEvents.map((e) => e.toJson()).toList(),
  'goals': instance.goals.map((e) => e.toJson()).toList(),
};

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

Map<String, dynamic> _$ExchangeRatesResponseToJson(
  ExchangeRatesResponse instance,
) => <String, dynamic>{
  'as_of': instance.asOf?.toIso8601String(),
  'is_stale': instance.isStale,
  'source': instance.source,
  'rub_per_unit': instance.rubPerUnit,
};

FinancialPresetResponse _$FinancialPresetResponseFromJson(
  Map<String, dynamic> json,
) => FinancialPresetResponse(
  region: json['region'] as String,
  currencyCode: json['currency_code'] as String,
  annualRate: _moneyFromJson(json['annual_rate']),
  rateReference: json['rate_reference'] as String? ?? '',
  rateSource: json['rate_source'] as String? ?? '',
);

Map<String, dynamic> _$FinancialPresetResponseToJson(
  FinancialPresetResponse instance,
) => <String, dynamic>{
  'region': instance.region,
  'currency_code': instance.currencyCode,
  'annual_rate': instance.annualRate,
  'rate_reference': instance.rateReference,
  'rate_source': instance.rateSource,
};
