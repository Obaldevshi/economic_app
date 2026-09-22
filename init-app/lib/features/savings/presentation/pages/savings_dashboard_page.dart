import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
import 'package:mobile_template/features/savings/presentation/pages/bloc/savings_bloc.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_dialogs.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_ui.dart';
import 'package:mobile_template/presentation/widgets/common/error_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:mobile_template/presentation/widgets/layout/scroll_shell.dart';

class SavingsDashboardPage extends StatelessWidget {
  const SavingsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SavingsBloc, SavingsState>(
      listenWhen: (previous, current) => previous.failure != current.failure,
      listener: (context, state) {
        if (state.failure != null) ErrorDialog.show(context, state.failure!);
      },
      builder: (context, state) {
        final dashboard = state.dashboard;
        return ScrollShell(
          title: context.l10n.appName,
          expandedHeaderHeight: 58,
          isLoading: state.isLoading && dashboard == null,
          onRefresh: () async {
            context.read<SavingsBloc>().add(const LoadSavingsDashboard());
            await context.read<SavingsBloc>().stream.firstWhere(
              (value) => !value.isLoading,
            );
          },
          actions: [
            if (dashboard != null)
              IconButton(
                tooltip: context.l10n.rateAndHorizon,
                onPressed: () =>
                    showProjectionSettingsDialog(context, dashboard),
                icon: const Icon(Icons.tune_rounded),
              ),
          ],
          headerContent: Text(
            context.l10n.savingsTagline,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
          body: dashboard == null
              ? _EmptyDashboard(
                  onRetry: () {
                    context.read<SavingsBloc>()
                      ..add(const LoadSavingsDashboard())
                      ..add(const LoadImpulseItems());
                  },
                )
              : _DashboardBody(dashboard: dashboard, impulses: state.impulses),
        );
      },
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.dashboard, required this.impulses});

  final SavingsDashboardResponse dashboard;
  final List<ImpulseItemResponse> impulses;

  @override
  Widget build(BuildContext context) {
    final summary = _SummarySection(dashboard: dashboard);
    final projection = _ProjectionCard(dashboard: dashboard);
    final dynamics = _DynamicsCard(points: dashboard.monthlySeries);
    final goals = _GoalsCard(dashboard: dashboard);
    final recent = _RecentSavings(events: dashboard.recentEvents);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: impulses.isEmpty
              ? null
              : () => showAddSavingDialog(context, impulses),
          icon: const Icon(Icons.add_rounded),
          label: Text(context.l10n.recordSaving),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
        ),
        const SizedBox(height: AppDimensions.spaceL),
        summary,
        const SizedBox(height: AppDimensions.spaceL),
        AppLayoutItemBuilder<Widget>(
          narrow: () => Column(
            children: [
              projection,
              const SizedBox(height: AppDimensions.spaceM),
              dynamics,
              const SizedBox(height: AppDimensions.spaceM),
              goals,
              const SizedBox(height: AppDimensions.spaceM),
              recent,
            ],
          ),
          wide: () => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    projection,
                    const SizedBox(height: AppDimensions.spaceM),
                    dynamics,
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    goals,
                    const SizedBox(height: AppDimensions.spaceM),
                    recent,
                  ],
                ),
              ),
            ],
          ),
        )(context, width: 820),
      ],
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.dashboard});
  final SavingsDashboardResponse dashboard;

  @override
  Widget build(BuildContext context) {
    final cards = [
      (context.l10n.savedToday, dashboard.todayTotal, Icons.today_outlined),
      (
        context.l10n.savedThisMonth,
        dashboard.monthTotal,
        Icons.calendar_month_outlined,
      ),
      (context.l10n.savedTotal, dashboard.totalSaved, Icons.savings_outlined),
      (
        context.l10n.investedTotal,
        dashboard.investedTotal,
        Icons.account_balance_outlined,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 4
            : constraints.maxWidth >= 520
            ? 2
            : 1;
        final width =
            (constraints.maxWidth - AppDimensions.spaceM * (columns - 1)) /
            columns;
        return Wrap(
          spacing: AppDimensions.spaceM,
          runSpacing: AppDimensions.spaceM,
          children: [
            for (final card in cards)
              SizedBox(
                width: width,
                child: GlassSurfaceCard(
                  child: Row(
                    children: [
                      GlassIconBadge(
                        color: AppColors.primary,
                        child: Icon(card.$3, color: AppColors.primary),
                      ),
                      const SizedBox(width: AppDimensions.spaceM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card.$1,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatRubles(context, card.$2),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ProjectionCard extends StatelessWidget {
  const _ProjectionCard({required this.dashboard});
  final SavingsDashboardResponse dashboard;

  @override
  Widget build(BuildContext context) => GlassSurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.futureProjection,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Text(
              '${dashboard.annualRate.toStringAsFixed(1)}%',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceS),
        Text(
          '${dashboard.projectionYears} ${context.l10n.yearsAtCurrentPace}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceL),
        Text(
          formatRubles(context, dashboard.projectedTotal),
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          '${context.l10n.interestIncome}: ${formatRubles(context, dashboard.projectedInterest)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppDimensions.spaceL),
        SizedBox(
          height: 180,
          child: _ProjectionChart(points: dashboard.projectionSeries),
        ),
      ],
    ),
  );
}

class _ProjectionChart extends StatelessWidget {
  const _ProjectionChart({required this.points});
  final List<ProjectionPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty || points.every((point) => point.total == 0)) {
      return Center(child: Text(context.l10n.noData));
    }
    final maxValue = points.map((point) => point.total).reduce(math.max);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final point in points) ...[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: maxValue == 0 ? 0 : point.total / maxValue,
                      widthFactor: 0.55,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.82),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${point.year}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          if (point != points.last) const SizedBox(width: 4),
        ],
      ],
    );
  }
}

class _DynamicsCard extends StatelessWidget {
  const _DynamicsCard({required this.points});
  final List<MonthlySavingPoint> points;

  @override
  Widget build(BuildContext context) {
    final maxValue = points.isEmpty
        ? 0.0
        : points.map((point) => point.amount).reduce(math.max);
    return GlassSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.savingsDynamics,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppDimensions.spaceL),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final point in points)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: maxValue == 0
                                    ? 0.02
                                    : math.max(0.04, point.amount / maxValue),
                                widthFactor: 0.65,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withValues(
                                      alpha: 0.72,
                                    ),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            point.month.substring(5),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalsCard extends StatelessWidget {
  const _GoalsCard({required this.dashboard});
  final SavingsDashboardResponse dashboard;

  @override
  Widget build(BuildContext context) => GlassSurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.goals,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            IconButton(
              onPressed: () => showGoalDialog(context),
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        if (dashboard.goals.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingM,
            ),
            child: Text(context.l10n.noGoalsYet),
          )
        else
          for (final goal in dashboard.goals) ...[
            const SizedBox(height: AppDimensions.spaceM),
            Text(goal.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: (dashboard.investedTotal / goal.targetAmount).clamp(0, 1),
              minHeight: 9,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 6),
            Text(
              '${formatRubles(context, dashboard.investedTotal)} / ${formatRubles(context, goal.targetAmount)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
      ],
    ),
  );
}

class _RecentSavings extends StatelessWidget {
  const _RecentSavings({required this.events});
  final List<SavingEventResponse> events;

  @override
  Widget build(BuildContext context) => GlassSurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.recentSavings,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppDimensions.spaceS),
        if (events.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingM,
            ),
            child: Text(context.l10n.noSavingsYet),
          )
        else
          for (final event in events)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryContainer,
                child: Icon(Icons.check_rounded, color: AppColors.primary),
              ),
              title: Text(event.impulseName),
              subtitle: Text(
                DateFormat.MMMd(
                  Localizations.localeOf(context).toLanguageTag(),
                ).format(event.occurredAt),
              ),
              trailing: Text(
                '+${formatRubles(context, event.amount)}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.success),
              ),
            ),
      ],
    ),
  );
}

class _EmptyDashboard extends StatelessWidget {
  const _EmptyDashboard({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.savings_outlined,
            size: 64,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            context.l10n.noData,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          OutlinedButton(onPressed: onRetry, child: Text(context.l10n.retry)),
        ],
      ),
    ),
  );
}
