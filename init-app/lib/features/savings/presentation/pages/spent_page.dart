import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
import 'package:mobile_template/features/savings/presentation/pages/bloc/savings_bloc.dart';
import 'package:mobile_template/features/savings/presentation/widgets/financial_currency_bar.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_dialogs.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_ui.dart';
import 'package:mobile_template/features/shell/presentation/widgets/navigation_branch_scope.dart';
import 'package:mobile_template/presentation/widgets/common/error_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:mobile_template/presentation/widgets/layout/scroll_shell.dart';

/// Actual impulse purchases never enter the savings balance or goal allocations.
class SpentPage extends StatefulWidget {
  const SpentPage({super.key});
  @override
  State<SpentPage> createState() => _SpentPageState();
}

class _SpentPageState extends State<SpentPage> {
  int _years = 1;

  void _refresh() => context.read<SavingsBloc>()
    ..add(const LoadSavingsDashboard())
    ..add(const LoadImpulseItems())
    ..add(const LoadSpentHistory());

  Future<void> _delete(SpentEventResponse event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.delete),
        content: Text(context.l10n.deleteSpentConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<SavingsBloc>().add(DeleteSpentEvent(event.id));
    }
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<SavingsBloc, SavingsState>(
    listenWhen: (a, b) =>
        a.failure != b.failure || a.actionMessage != b.actionMessage,
    listener: (context, state) {
      if (!NavigationBranchScope.isActive(context, AppNavigationBranch.spent)) {
        return;
      }
      if (state.failure != null) {
        ErrorDialog.show(
          context,
          localizeSavingsFailure(context, state.failure!),
        );
      } else if (state.actionMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(savingsActionMessage(context, state.actionMessage!)),
          ),
        );
      }
    },
    builder: (context, state) {
      final dashboard = state.dashboard;
      final ready =
          dashboard != null &&
          state.spentPage > 0 &&
          state.spentCurrency == dashboard.currencyCode;
      final rate = dashboard?.annualRate ?? 0.0;
      return ScrollShell(
        title: context.l10n.spentTab,
        headerContent: const SizedBox.shrink(),
        expandedHeaderHeight: 0,
        isLoading: !ready && (state.isSpentLoading || state.isDashboardLoading),
        onRefresh: () async {
          _refresh();
          await context.read<SavingsBloc>().stream.firstWhere(
            (s) => !s.isSpentLoading && !s.isDashboardLoading,
          );
        },
        body: dashboard == null || !ready
            ? SavingsLoadError(onRetry: _refresh)
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FinancialCurrencyBar(dashboard: dashboard),
                      const SizedBox(height: AppDimensions.spaceM),
                      GlassSurfaceCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              context.l10n.spentIntro,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: AppDimensions.spaceL),
                            Text(
                              context.l10n.spentPrincipal,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              formatRubles(context, state.spentAmount),
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: AppDimensions.spaceM),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: FilledButton.icon(
                                onPressed: state.isSaving
                                    ? null
                                    : () => showSpentDialog(
                                        context,
                                        state.impulses,
                                        currencyCode: dashboard.currencyCode,
                                      ),
                                icon: const Icon(Icons.add_rounded),
                                label: Text(context.l10n.recordSpent),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceL),
                      if (state.spentTotal > 0) ...[
                        _OpportunityCard(
                          principal: state.spentAmount,
                          rate: rate,
                          years: _years,
                          onYearsChanged: (year) =>
                              setState(() => _years = year),
                          dashboard: dashboard,
                        ),
                        const SizedBox(height: AppDimensions.spaceL),
                      ],
                      GlassSurfaceCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              context.l10n.spentHistory,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppDimensions.spaceM),
                            if (state.spent.isEmpty)
                              Text(context.l10n.noSpentYet)
                            else ...[
                              Text(
                                context.l10n.spentLoadedCount(
                                  state.spent.length,
                                  state.spentTotal,
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: AppDimensions.spaceS),
                              for (final event in state.spent)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppDimensions.spaceS,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event.impulseName,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                            ),
                                            Text(
                                              DateFormat.yMMMd(
                                                Localizations.localeOf(
                                                  context,
                                                ).toLanguageTag(),
                                              ).format(event.occurredAt),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                            ),
                                            if (event.note?.isNotEmpty == true)
                                              Text(event.note!),
                                            const SizedBox(height: 4),
                                            Text(
                                              formatRubles(
                                                context,
                                                event.amount,
                                                currencyCode:
                                                    event.currencyCode,
                                              ),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleSmall,
                                            ),
                                            Text(
                                              context.l10n.spentMissedLine(
                                                formatRubles(
                                                  context,
                                                  oneSkipFutureValue(
                                                        event.amount,
                                                        rate,
                                                        _years,
                                                      ) -
                                                      event.amount,
                                                  currencyCode:
                                                      event.currencyCode,
                                                ),
                                                _years,
                                              ),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        enabled: !state.isSaving,
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            showSpentDialog(
                                              context,
                                              state.impulses,
                                              currencyCode: event.currencyCode,
                                              event: event,
                                            );
                                          }
                                          if (value == 'delete') {
                                            _delete(event);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Text(
                                              context.l10n.editSaving,
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Text(context.l10n.delete),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              if (state.spentLoadFailed)
                                TextButton(
                                  onPressed: () =>
                                      context.read<SavingsBloc>().add(
                                        LoadSpentHistory(
                                          page: state.spentPage + 1,
                                          append: true,
                                        ),
                                      ),
                                  child: Text(context.l10n.retry),
                                ),
                              if (state.hasMoreSpent)
                                OutlinedButton(
                                  onPressed: state.isSpentLoading
                                      ? null
                                      : () => context.read<SavingsBloc>().add(
                                          LoadSpentHistory(
                                            page: state.spentPage + 1,
                                            append: true,
                                          ),
                                        ),
                                  child: Text(context.l10n.loadMoreHistory),
                                ),
                              if (state.isSpentLoading)
                                const LinearProgressIndicator(),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      );
    },
  );
}

class _OpportunityCard extends StatelessWidget {
  const _OpportunityCard({
    required this.principal,
    required this.rate,
    required this.years,
    required this.onYearsChanged,
    required this.dashboard,
  });
  final double principal;
  final double rate;
  final int years;
  final ValueChanged<int> onYearsChanged;
  final SavingsDashboardResponse dashboard;
  @override
  Widget build(BuildContext context) => GlassSurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.spentOpportunity,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppDimensions.spaceM),
        Wrap(
          spacing: AppDimensions.spaceS,
          runSpacing: AppDimensions.spaceS,
          children: [
            for (final year in projectionPeriods)
              ChoiceChip(
                label: Text(context.l10n.projectionPeriod(year)),
                selected: years == year,
                onSelected: (_) => onYearsChanged(year),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceL),
        Text(
          context.l10n.spentMissedInterest,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          formatRubles(
            context,
            oneSkipFutureValue(principal, rate, years) - principal,
          ),
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceM),
        Text(
          context.l10n.spentPossibleTotal(
            formatRubles(context, oneSkipFutureValue(principal, rate, years)),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceM),
        Text(
          context.l10n.spentAssumptions(rate.toStringAsFixed(2)),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: context.watch<SavingsBloc>().state.isSaving
                ? null
                : () => showProjectionSettingsDialog(context, dashboard),
            icon: const Icon(Icons.tune_rounded, size: 18),
            label: Text(context.l10n.rateAndHorizon),
          ),
        ),
      ],
    ),
  );
}
