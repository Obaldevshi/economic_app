import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
import 'package:mobile_template/features/savings/presentation/pages/bloc/savings_bloc.dart';

const financialCurrencies = [
  'RUB',
  'USD',
  'EUR',
  'KZT',
  'BRL',
  'CNY',
  'INR',
  'SAR',
];

String currencySymbol(String code) => switch (code) {
  'RUB' => '₽',
  'USD' => r'$',
  'EUR' => '€',
  'KZT' => '₸',
  'BRL' => r'R$',
  'CNY' => '¥',
  'INR' => '₹',
  'SAR' => 'SAR',
  _ => code,
};

class FinancialDisplayData {
  const FinancialDisplayData({
    this.currency = 'RUB',
    this.displayCurrency = 'RUB',
    this.rates,
  });
  factory FinancialDisplayData.fromState(SavingsState state) {
    final currency =
        state.dashboard?.currencyCode ??
        state.settings?.currencyCode ??
        state.impulses.firstOrNull?.currencyCode ??
        state.history.firstOrNull?.currencyCode ??
        'RUB';
    return FinancialDisplayData(
      currency: currency,
      displayCurrency:
          state.dashboard?.displayCurrency ??
          state.settings?.displayCurrency ??
          currency,
      rates: state.dashboard?.exchangeRates,
    );
  }
  final String currency;
  final String displayCurrency;
  final ExchangeRatesResponse? rates;

  double? factor(String from, String to) {
    if (from == to) return 1;
    final source = from == 'RUB' ? 1.0 : rates?.rubPerUnit[from];
    final target = to == 'RUB' ? 1.0 : rates?.rubPerUnit[to];
    if (source == null ||
        target == null ||
        !source.isFinite ||
        !target.isFinite ||
        source <= 0 ||
        target <= 0)
      return null;
    return source / target;
  }
}

class FinancialDisplayScope extends InheritedWidget {
  const FinancialDisplayScope({
    required this.data,
    required super.child,
    super.key,
  });
  final FinancialDisplayData data;
  static FinancialDisplayData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FinancialDisplayScope>()?.data;
  static FinancialDisplayData of(BuildContext context) {
    final inherited = maybeOf(context);
    if (inherited != null) return inherited;
    // Dialogs live in the root overlay, but keep the route's BLoC provider.
    try {
      return FinancialDisplayData.fromState(context.read<SavingsBloc>().state);
    } on ProviderNotFoundException {
      return const FinancialDisplayData();
    }
  }

  @override
  bool updateShouldNotify(FinancialDisplayScope oldWidget) =>
      data != oldWidget.data;
}
