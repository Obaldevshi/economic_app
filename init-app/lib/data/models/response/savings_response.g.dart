// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImpulseItemResponse _$ImpulseItemResponseFromJson(Map<String, dynamic> json) =>
    ImpulseItemResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      defaultAmount: _moneyFromJson(json['default_amount']),
      iconKey: json['icon_key'] as String,
      weeklyFrequency: (json['weekly_frequency'] as num).toInt(),
      isActive: json['is_active'] as bool,
    );

SavingEventResponse _$SavingEventResponseFromJson(Map<String, dynamic> json) =>
    SavingEventResponse(
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
  annualRate: _moneyFromJson(json['annual_rate']),
  projectionYears: (json['projection_years'] as num).toInt(),
);

SavingsDashboardResponse _$SavingsDashboardResponseFromJson(
  Map<String, dynamic> json,
) => SavingsDashboardResponse(
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
