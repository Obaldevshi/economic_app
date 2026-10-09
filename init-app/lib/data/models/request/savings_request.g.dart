// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalAllocationRequest _$GoalAllocationRequestFromJson(
  Map<String, dynamic> json,
) => GoalAllocationRequest(
  allocatedAmount: (json['allocated_amount'] as num).toDouble(),
);

Map<String, dynamic> _$GoalAllocationRequestToJson(
  GoalAllocationRequest instance,
) => <String, dynamic>{'allocated_amount': instance.allocatedAmount};

SavingEventRequest _$SavingEventRequestFromJson(Map<String, dynamic> json) =>
    SavingEventRequest(
      impulseItemId: (json['impulse_item_id'] as num?)?.toInt(),
      impulseName: json['impulse_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      isInvested: json['is_invested'] as bool,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$SavingEventRequestToJson(SavingEventRequest instance) =>
    <String, dynamic>{
      'impulse_item_id': instance.impulseItemId,
      'impulse_name': instance.impulseName,
      'amount': instance.amount,
      'is_invested': instance.isInvested,
      'note': instance.note,
    };

ImpulseItemRequest _$ImpulseItemRequestFromJson(Map<String, dynamic> json) =>
    ImpulseItemRequest(
      name: json['name'] as String,
      defaultAmount: (json['default_amount'] as num).toDouble(),
      iconKey: json['icon_key'] as String,
      weeklyFrequency: (json['weekly_frequency'] as num).toInt(),
      isActive: json['is_active'] as bool?,
    );

Map<String, dynamic> _$ImpulseItemRequestToJson(ImpulseItemRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'default_amount': instance.defaultAmount,
      'icon_key': instance.iconKey,
      'weekly_frequency': instance.weeklyFrequency,
      'is_active': ?instance.isActive,
    };

SavingsGoalRequest _$SavingsGoalRequestFromJson(Map<String, dynamic> json) =>
    SavingsGoalRequest(
      name: json['name'] as String,
      targetAmount: (json['target_amount'] as num).toDouble(),
    );

Map<String, dynamic> _$SavingsGoalRequestToJson(SavingsGoalRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'target_amount': instance.targetAmount,
    };

SavingsSettingsRequest _$SavingsSettingsRequestFromJson(
  Map<String, dynamic> json,
) => SavingsSettingsRequest(
  annualRate: (json['annual_rate'] as num).toDouble(),
  projectionYears: (json['projection_years'] as num).toInt(),
);

Map<String, dynamic> _$SavingsSettingsRequestToJson(
  SavingsSettingsRequest instance,
) => <String, dynamic>{
  'annual_rate': instance.annualRate,
  'projection_years': instance.projectionYears,
};
