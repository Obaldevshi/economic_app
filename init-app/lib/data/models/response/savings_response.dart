import 'package:json_annotation/json_annotation.dart';

part 'savings_response.g.dart';

double _moneyFromJson(Object? value) => switch (value) {
  num number => number.toDouble(),
  String text => double.tryParse(text) ?? 0,
  _ => 0,
};

@JsonSerializable(createToJson: false)
class ImpulseItemResponse {
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

@JsonSerializable(createToJson: false)
class SavingEventResponse {
  final int id;
  @JsonKey(name: 'impulse_item_id')
  final int? impulseItemId;
  @JsonKey(name: 'impulse_name')
  final String impulseName;
  @JsonKey(fromJson: _moneyFromJson)
  final double amount;
  @JsonKey(name: 'occurred_at')
  final DateTime occurredAt;
  @JsonKey(name: 'is_invested')
  final bool isInvested;
  final String? note;

  SavingEventResponse({
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

@JsonSerializable(createToJson: false)
class SavingsGoalResponse {
  final int id;
  final String name;
  @JsonKey(name: 'target_amount', fromJson: _moneyFromJson)
  final double targetAmount;

  SavingsGoalResponse({
    required this.id,
    required this.name,
    required this.targetAmount,
  });

  factory SavingsGoalResponse.fromJson(Map<String, dynamic> json) =>
      _$SavingsGoalResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class MonthlySavingPoint {
  final String month;
  @JsonKey(fromJson: _moneyFromJson)
  final double amount;

  MonthlySavingPoint({required this.month, required this.amount});

  factory MonthlySavingPoint.fromJson(Map<String, dynamic> json) =>
      _$MonthlySavingPointFromJson(json);
}

@JsonSerializable(createToJson: false)
class ProjectionPoint {
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

@JsonSerializable(createToJson: false)
class ImpulseTotal {
  final String name;
  @JsonKey(fromJson: _moneyFromJson)
  final double amount;

  ImpulseTotal({required this.name, required this.amount});

  factory ImpulseTotal.fromJson(Map<String, dynamic> json) =>
      _$ImpulseTotalFromJson(json);
}

@JsonSerializable(createToJson: false)
class SavingsDashboardResponse {
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
