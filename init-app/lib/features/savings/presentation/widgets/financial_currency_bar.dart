import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/data/models/request/savings_request.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
import 'package:mobile_template/features/savings/presentation/pages/bloc/savings_bloc.dart';
import 'package:mobile_template/features/savings/presentation/widgets/financial_display_scope.dart';

class FinancialCurrencyBar extends StatelessWidget {
  const FinancialCurrencyBar({required this.dashboard, super.key});
  final SavingsDashboardResponse dashboard;
  @override
  Widget build(BuildContext context) {
    final data = FinancialDisplayData(
      currency: dashboard.currencyCode,
      displayCurrency: dashboard.displayCurrency,
      rates: dashboard.exchangeRates,
    );
    final displayed = data.factor(data.currency, data.displayCurrency) == null
        ? data.currency
        : data.displayCurrency;
    final date = dashboard.exchangeRates?.asOf;
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 220,
          child: DropdownButtonFormField<String>(
            key: ValueKey(displayed),
            initialValue: displayed,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: context.l10n.displayCurrency,
            ),
            items: [
              for (final code in financialCurrencies)
                DropdownMenuItem(
                  value: code,
                  enabled: data.factor(data.currency, code) != null,
                  child: Text('$code · ${currencySymbol(code)}'),
                ),
            ],
            onChanged: context.watch<SavingsBloc>().state.isSaving
                ? null
                : (code) {
                    if (code == null || code == displayed) return;
                    context.read<SavingsBloc>().add(
                      UpdateSavingsSettings(
                        SavingsSettingsRequest(
                          annualRate: dashboard.annualRate,
                          projectionYears: dashboard.projectionYears,
                          displayCurrency: code,
                        ),
                      ),
                    );
                  },
          ),
        ),
        if (date != null)
          Tooltip(
            message:
                '${context.l10n.conversionHint}\n${dashboard.exchangeRates!.source}',
            child: Text(
              context.l10n.exchangeRateDate(
                DateFormat.yMd(
                  Localizations.localeOf(context).toLanguageTag(),
                ).format(date),
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}
