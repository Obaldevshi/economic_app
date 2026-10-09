import 'dart:math' as math;
import 'package:mobile_template/features/savings/presentation/widgets/financial_display_scope.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/errors/failure.dart';

Failure localizeSavingsFailure(BuildContext context, Failure failure) {
  final message = switch (failure.message) {
    'Release goal funds before reducing its target' =>
      context.l10n.goalBelowAllocation,
    'Release goal allocations before reducing saved funds' =>
      context.l10n.releaseAllocationsFirst,
    'Allocation must not exceed the goal target' =>
      context.l10n.allocationTooLarge,
    'Currency changed; refresh and try again' => context.l10n.currencyChanged,
    _ => null,
  };
  return message == null
      ? failure
      : ValidationFailure(
          message: message,
          statusCode: failure.statusCode,
          errorCode: failure.errorCode,
        );
}

class SavingsLoadError extends StatelessWidget {
  const SavingsLoadError({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Padding(
        padding: AppDimensions.paddingAllL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              context.l10n.savingsDataLoadFailed,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    ),
  );
}

String moneyInputText(double value) =>
    value.toStringAsFixed(value % 1 == 0 ? 0 : 2);

String savingsActionMessage(BuildContext context, String message) =>
    switch (message) {
      'Goal allocation updated' => context.l10n.allocationSaved,
      'Saving recorded' => context.l10n.savingRecordedMessage,
      'Saving updated' => context.l10n.savingUpdatedMessage,
      'Impulse item created' ||
      'Impulse item updated' => context.l10n.habitSavedMessage,
      'Savings goal created' ||
      'Savings goal updated' => context.l10n.goalSavedMessage,
      'Savings settings updated' => context.l10n.settingsSavedMessage,
      'Deleted' => context.l10n.entryDeletedMessage,
      _ => context.l10n.changesSavedMessage,
    };

String? validateMoneyInput(BuildContext context, String? value, String field) {
  final text = (value ?? '').trim();
  final number = double.tryParse(text.replaceAll(',', '.'));
  if (number == null || !number.isFinite || number <= 0) {
    return context.l10n.numberMustBePositive(field);
  }
  if (!RegExp(r'^\d{1,10}([.,]\d{1,2})?$').hasMatch(text)) {
    return context.l10n.moneyFormatError;
  }
  return null;
}

// Kept as a compatible name for existing widgets; amounts remain in their
// original unit and are converted only for presentation.
String formatRubles(
  BuildContext context,
  double value, {
  String? currencyCode,
  bool original = false,
}) {
  final data = FinancialDisplayScope.of(context);
  final from = currencyCode ?? data.currency;
  final factor = original ? 1.0 : data.factor(from, data.displayCurrency);
  final code = original || factor == null ? from : data.displayCurrency;
  final converted = value * (factor ?? 1);
  return NumberFormat.currency(
    locale: Localizations.localeOf(context).toLanguageTag(),
    symbol: currencySymbol(code),
    decimalDigits: converted % 1 == 0 ? 0 : 2,
  ).format(converted);
}

String formatCompactRubles(BuildContext context, double value) {
  final data = FinancialDisplayScope.of(context);
  final factor = data.factor(data.currency, data.displayCurrency);
  return NumberFormat.compactCurrency(
    locale: Localizations.localeOf(context).toLanguageTag(),
    symbol: currencySymbol(
      factor == null ? data.currency : data.displayCurrency,
    ),
    decimalDigits: 0,
  ).format(value * (factor ?? 1));
}

String formatRate(BuildContext context, double value) =>
    NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(value);

double impulseAnnualPotential(ImpulseItemResponse item) =>
    item.weeklyFrequency > 0
    ? item.defaultAmount * item.weeklyFrequency * 52
    : item.defaultAmount * 12;

double oneSkipFutureValue(double amount, double annualRate, int years) {
  final monthlyRate = annualRate / 1200;
  return amount * math.pow(1 + monthlyRate, years * 12).toDouble();
}

double regularSkipsFutureValue(
  double annualAmount,
  double annualRate,
  int years,
) {
  final months = years * 12;
  final monthlyContribution = annualAmount / 12;
  final monthlyRate = annualRate / 1200;
  if (monthlyRate == 0) return monthlyContribution * months;
  return monthlyContribution *
      (math.pow(1 + monthlyRate, months).toDouble() - 1) /
      monthlyRate;
}

String impulseIconLabel(BuildContext context, String key) => switch (key) {
  'coffee' => context.l10n.impulseIconCoffee,
  'restaurant' => context.l10n.impulseIconRestaurant,
  'delivery' => context.l10n.impulseIconDelivery,
  'smoking' => context.l10n.impulseIconSmoking,
  'taxi' => context.l10n.impulseIconTaxi,
  'shopping' => context.l10n.impulseIconShopping,
  'subscription' => context.l10n.impulseIconSubscription,
  _ => context.l10n.impulseIconOther,
};

const impulseIconKeys = <String>[
  'coffee',
  'restaurant',
  'delivery',
  'smoking',
  'taxi',
  'shopping',
  'subscription',
  'other',
];
