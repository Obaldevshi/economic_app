import 'package:json_annotation/json_annotation.dart';

part 'savings_request.g.dart';

@JsonSerializable()
class GoalAllocationRequest {
  @JsonKey(name: 'allocated_amount')
  final double allocatedAmount;
  GoalAllocationRequest({required this.allocatedAmount});
  Map<String, dynamic> toJson() => _$GoalAllocationRequestToJson(this);
}

@JsonSerializable()
class SavingEventRequest {
  @JsonKey(name: 'currency_code', includeIfNull: false)
  final String? currencyCode;
  @JsonKey(name: 'impulse_item_id')
  final int? impulseItemId;
  @JsonKey(name: 'impulse_name')
  final String impulseName;
  final double amount;
  @JsonKey(name: 'is_invested')
  final bool isInvested;
  final String? note;

  SavingEventRequest({
    this.currencyCode,
    this.impulseItemId,
    required this.impulseName,
    required this.amount,
    required this.isInvested,
    this.note,
  });

  Map<String, dynamic> toJson() => _$SavingEventRequestToJson(this);
}

@JsonSerializable()
class ImpulseItemRequest {
  @JsonKey(name: 'currency_code', includeIfNull: false)
  final String? currencyCode;
  final String name;
  @JsonKey(name: 'default_amount')
  final double defaultAmount;
  @JsonKey(name: 'icon_key')
  final String iconKey;
  @JsonKey(name: 'weekly_frequency')
  final int weeklyFrequency;
  @JsonKey(name: 'is_active', includeIfNull: false)
  final bool? isActive;

  ImpulseItemRequest({
    this.currencyCode,
    required this.name,
    required this.defaultAmount,
    required this.iconKey,
    required this.weeklyFrequency,
    this.isActive,
  });

  Map<String, dynamic> toJson() => _$ImpulseItemRequestToJson(this);
}

@JsonSerializable()
class SavingsGoalRequest {
  @JsonKey(name: 'currency_code', includeIfNull: false)
  final String? currencyCode;
  final String name;
  @JsonKey(name: 'target_amount')
  final double targetAmount;

  SavingsGoalRequest({
    required this.name,
    required this.targetAmount,
    this.currencyCode,
  });

  Map<String, dynamic> toJson() => _$SavingsGoalRequestToJson(this);
}

@JsonSerializable()
class SavingsSettingsRequest {
  @JsonKey(name: 'currency_code', includeIfNull: false)
  final String? currencyCode;
  @JsonKey(name: 'display_currency', includeIfNull: false)
  final String? displayCurrency;
  @JsonKey(name: 'financial_region', includeIfNull: false)
  final String? financialRegion;
  @JsonKey(name: 'annual_rate')
  final double annualRate;
  @JsonKey(name: 'projection_years')
  final int projectionYears;

  SavingsSettingsRequest({
    this.currencyCode,
    this.displayCurrency,
    this.financialRegion,
    required this.annualRate,
    required this.projectionYears,
  });

  Map<String, dynamic> toJson() => _$SavingsSettingsRequestToJson(this);
}
