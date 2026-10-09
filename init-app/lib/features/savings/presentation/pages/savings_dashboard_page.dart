import 'dart:math' as math;
import 'package:mobile_template/features/savings/presentation/widgets/financial_currency_bar.dart';
import 'package:mobile_template/features/savings/presentation/widgets/projection_period_selector.dart';

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
import 'package:mobile_template/features/savings/presentation/widgets/scenario_comparison.dart';
import 'package:mobile_template/features/savings/presentation/widgets/saving_receipt.dart';
import 'package:mobile_template/features/savings/presentation/widgets/quick_saving_actions.dart';
import 'package:mobile_template/features/shell/presentation/widgets/navigation_branch_scope.dart';
import 'package:mobile_template/presentation/widgets/common/error_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:mobile_template/presentation/widgets/common/editorial_icons.dart';
import 'package:mobile_template/presentation/widgets/common/brand_mark.dart';
import 'package:mobile_template/presentation/widgets/layout/scroll_shell.dart';

class SavingsDashboardPage extends StatelessWidget {
  const SavingsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SavingsBloc, SavingsState>(
      listenWhen: (previous, current) =>
          previous.failure != current.failure ||
          previous.actionMessage != current.actionMessage,
      listener: (context, state) {
        if (!NavigationBranchScope.isActive(
          context,
          AppNavigationBranch.home,
        )) {
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
              content: Text(
                savingsActionMessage(context, state.actionMessage!),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final dashboard = state.dashboard;
        return ScrollShell(
          title: context.l10n.appName,
          expandedHeaderHeight: 58,
          isLoading: state.isDashboardLoading && dashboard == null,
          onRefresh: () async {
            context.read<SavingsBloc>()
              ..add(const LoadSavingsDashboard())
              ..add(const LoadImpulseItems());
            await context.read<SavingsBloc>().stream.firstWhere(
              (value) => !value.isLoading,
            );
          },
          actions: [
            IconButton(
              tooltip: context.l10n.weeklyReceipt,
              onPressed: () => showWeeklyReceiptDialog(context),
              icon: const Icon(Icons.receipt_long_outlined),
            ),
            if (dashboard != null)
              IconButton(
                tooltip: context.l10n.rateAndHorizon,
                onPressed: state.isSaving || state.isLoading
                    ? null
                    : () => showProjectionSettingsDialog(context, dashboard),
                icon: const Icon(Icons.tune_rounded),
              ),
          ],
          headerContent: Text(
            context.l10n.savingsTagline,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: ScrollShell.subtitleColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          body: dashboard == null
              ? state.dashboardLoadFailed
                    ? SavingsLoadError(
                        onRetry: () => context.read<SavingsBloc>().add(
                          const LoadSavingsDashboard(),
                        ),
                      )
                    : _EmptyDashboard(
                        onRetry: () {
                          context.read<SavingsBloc>()
                            ..add(const LoadSavingsDashboard())
                            ..add(const LoadImpulseItems());
                        },
                      )
              : _DashboardBody(
                  dashboard: dashboard,
                  impulses: state.impulses
                      .where((item) => item.isActive)
                      .toList(),
                ),
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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FinancialCurrencyBar(dashboard: dashboard),
            const SizedBox(height: AppDimensions.spaceM),
            _SavingsHero(dashboard: dashboard, impulses: impulses),
            const SizedBox(height: AppDimensions.spaceL),
            const QuickSavingActions(),
            const SizedBox(height: AppDimensions.spaceL),
            ScenarioComparison(items: impulses, rate: dashboard.annualRate),
            if (impulses.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spaceL),
              _QuickChoices(impulses: impulses),
            ],
            const SizedBox(height: AppDimensions.spaceL),
            _SummarySection(dashboard: dashboard),
            const SizedBox(height: AppDimensions.spaceL),
            AppLayoutItemBuilder<Widget>(
              narrow: () => Column(
                children: [
                  _ProjectionCard(dashboard: dashboard),
                  const SizedBox(height: AppDimensions.spaceM),
                  _DynamicsCard(points: dashboard.monthlySeries),
                  const SizedBox(height: AppDimensions.spaceM),
                  _TopSourcesCard(items: dashboard.impulseTotals),
                  const SizedBox(height: AppDimensions.spaceM),
                  _GoalsCard(dashboard: dashboard),
                  const SizedBox(height: AppDimensions.spaceM),
                  _RecentSavings(events: dashboard.recentEvents),
                ],
              ),
              wide: () => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _ProjectionCard(dashboard: dashboard),
                        const SizedBox(height: AppDimensions.spaceM),
                        _DynamicsCard(points: dashboard.monthlySeries),
                        const SizedBox(height: AppDimensions.spaceM),
                        _TopSourcesCard(items: dashboard.impulseTotals),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _GoalsCard(dashboard: dashboard),
                        const SizedBox(height: AppDimensions.spaceM),
                        _RecentSavings(events: dashboard.recentEvents),
                      ],
                    ),
                  ),
                ],
              ),
            )(context, width: 900),
          ],
        ),
      ),
    );
  }
}

class _SavingsHero extends StatelessWidget {
  const _SavingsHero({required this.dashboard, required this.impulses});

  final SavingsDashboardResponse dashboard;
  final List<ImpulseItemResponse> impulses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${dashboard.annualRate.toStringAsFixed(1)}%  /  ${context.l10n.projectionPeriod(dashboard.projectionYears)}',
          style: theme.textTheme.labelMedium?.copyWith(
            color: AppColors.primaryLight,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceS),
        ProjectionPeriodSelector(dashboard: dashboard, onDark: true),
        const SizedBox(height: AppDimensions.spaceM),
        Text(
          context.l10n.futureProjection,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.78),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatRubles(context, dashboard.projectedTotal),
          style: theme.textTheme.displaySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceS),
        Text(
          context.l10n.projectionExplanation,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.78),
          ),
        ),
      ],
    );

    final action = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeroMetric(
          icon: Icons.trending_up_rounded,
          label: context.l10n.currentPace,
          value: formatRubles(context, dashboard.monthlyPace),
        ),
        const SizedBox(height: AppDimensions.spaceS),
        _HeroMetric(
          icon: Icons.auto_graph_rounded,
          label: context.l10n.compoundEffect,
          value: '+${formatRubles(context, dashboard.projectedInterest)}',
        ),
        const SizedBox(height: AppDimensions.spaceM),
        FilledButton.icon(
          onPressed: context.watch<SavingsBloc>().state.isSaving
              ? null
              : () => showAddSavingDialog(context, impulses),
          icon: const Icon(Icons.add_rounded),
          label: Text(context.l10n.recordSaving),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.primaryDark,
            disabledBackgroundColor: Colors.white.withValues(alpha: 0.18),
            disabledForegroundColor: Colors.white.withValues(alpha: 0.6),
            minimumSize: const Size.fromHeight(54),
          ),
        ),
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: AppDimensions.borderRadiusXL,
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const BrandMark(size: 32, onDark: true),
                const SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceL),
            AppLayoutItemBuilder<Widget>(
              narrow: () => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  details,
                  const SizedBox(height: AppDimensions.spaceL),
                  action,
                ],
              ),
              wide: () => Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 3, child: details),
                  const SizedBox(width: AppDimensions.spaceXL),
                  Expanded(flex: 2, child: action),
                ],
              ),
            )(context, width: 760),
          ],
        ),
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceS),
    child: Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        const SizedBox(width: AppDimensions.spaceS),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _QuickChoices extends StatelessWidget {
  const _QuickChoices({required this.impulses});

  final List<ImpulseItemResponse> impulses;

  @override
  Widget build(BuildContext context) {
    final visible = impulses.take(6).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.quickChoices,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.quickChoicesDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceM),
        SizedBox(
          height: 132,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: visible.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppDimensions.spaceS),
            itemBuilder: (context, index) {
              final item = visible[index];
              return SizedBox(
                width: 190,
                child: GlassSurfaceCard(
                  onTap: () => showAddSavingDialog(
                    context,
                    impulses,
                    initialImpulse: item,
                  ),
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GlassIconBadge(
                            size: 38,
                            color: Theme.of(context).colorScheme.primary,
                            child: ImpulseGlyph(
                              keyName: item.iconKey,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.add_circle_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatRubles(
                          context,
                          item.defaultAmount,
                          currencyCode: item.currencyCode,
                        ),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
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
      (
        context.l10n.savedToday,
        dashboard.todayTotal,
        Icons.today_outlined,
        Theme.of(context).colorScheme.secondary,
      ),
      (
        context.l10n.savedThisMonth,
        dashboard.monthTotal,
        Icons.calendar_month_outlined,
        Theme.of(context).colorScheme.primary,
      ),
      (
        context.l10n.savedTotal,
        dashboard.totalSaved,
        Icons.savings_outlined,
        AppColors.success,
      ),
      (
        context.l10n.investedTotal,
        dashboard.investedTotal,
        Icons.account_balance_outlined,
        AppColors.warning,
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
                        color: card.$4,
                        child: Icon(card.$3, color: card.$4),
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
                                  ?.copyWith(fontWeight: FontWeight.w800),
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
  Widget build(BuildContext context) {
    final finalPoint = dashboard.projectionSeries.lastOrNull;
    final state = context.watch<SavingsBloc>().state;
    final contributions =
        finalPoint?.contributions ??
        (dashboard.projectedTotal - dashboard.projectedInterest);
    final contributionShare = dashboard.projectedTotal <= 0
        ? 0.0
        : (contributions / dashboard.projectedTotal).clamp(0.0, 1.0);

    return GlassSurfaceCard(
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
              TextButton.icon(
                onPressed: state.isSaving || state.isLoading
                    ? null
                    : () => showProjectionSettingsDialog(context, dashboard),
                icon: const Icon(Icons.tune_rounded, size: 18),
                label: Text('${dashboard.annualRate.toStringAsFixed(1)}%'),
              ),
            ],
          ),
          Text(
            '${context.l10n.projectionPeriod(dashboard.projectionYears)} · ${context.l10n.currentPace}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          ProjectionPeriodSelector(dashboard: dashboard),
          const SizedBox(height: AppDimensions.spaceL),
          SizedBox(
            height: 190,
            child: _ProjectionChart(points: dashboard.projectionSeries),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          Text(
            context.l10n.savingsBreakdown,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppDimensions.spaceS),
          ClipRRect(
            borderRadius: AppDimensions.borderRadiusCircular,
            child: LayoutBuilder(
              builder: (context, constraints) => Row(
                children: [
                  Container(
                    width: constraints.maxWidth * contributionShare,
                    height: 10,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Expanded(
                    child: Container(height: 10, color: AppColors.accent),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Wrap(
            spacing: AppDimensions.spaceL,
            runSpacing: AppDimensions.spaceS,
            children: [
              _LegendItem(
                color: Theme.of(context).colorScheme.primary,
                label: context.l10n.contributions,
                value: formatCompactRubles(context, contributions),
              ),
              _LegendItem(
                color: AppColors.accent,
                label: context.l10n.interestIncome,
                value: formatCompactRubles(
                  context,
                  dashboard.projectedInterest,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            context.l10n.projectionExplanation,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (dashboard.projectionSeries.isNotEmpty)
            _ProjectionTable(points: dashboard.projectionSeries),
        ],
      ),
    );
  }
}

class _ProjectionTable extends StatefulWidget {
  const _ProjectionTable({required this.points});
  final List<ProjectionPoint> points;

  @override
  State<_ProjectionTable> createState() => _ProjectionTableState();
}

class _ProjectionTableState extends State<_ProjectionTable> {
  final _horizontalScroll = ScrollController();

  @override
  void dispose() {
    _horizontalScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExpansionTile(
    tilePadding: EdgeInsets.zero,
    title: Text(
      context.l10n.projectionTableTitle,
      style: Theme.of(context).textTheme.titleSmall,
    ),
    children: [
      Scrollbar(
        controller: _horizontalScroll,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _horizontalScroll,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(bottom: AppDimensions.spaceM),
          child: DataTable(
            horizontalMargin: 0,
            columnSpacing: AppDimensions.spaceL,
            columns: [
              DataColumn(label: Text(context.l10n.projectionTableYear)),
              DataColumn(
                label: Text(context.l10n.contributions),
                numeric: true,
              ),
              DataColumn(
                label: Text(context.l10n.interestIncome),
                numeric: true,
              ),
              DataColumn(
                label: Text(context.l10n.projectionTableTotal),
                numeric: true,
              ),
            ],
            rows: [
              for (final point in widget.points)
                DataRow(
                  cells: [
                    DataCell(Text('${point.year}')),
                    DataCell(Text(formatRubles(context, point.contributions))),
                    DataCell(Text(formatRubles(context, point.interest))),
                    DataCell(Text(formatRubles(context, point.total))),
                  ],
                ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text('$label · $value', style: Theme.of(context).textTheme.bodySmall),
    ],
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
    final visiblePoints = points.length <= 8
        ? points
        : points
              .where(
                (point) =>
                    point.year == 1 ||
                    point.year % 5 == 0 ||
                    point.year == points.last.year,
              )
              .toList();
    final maxValue = visiblePoints.map((point) => point.total).reduce(math.max);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final point in visiblePoints) ...[
          Expanded(
            child: Tooltip(
              message: formatRubles(context, point.total),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: maxValue == 0
                            ? 0
                            : point.total / maxValue,
                        widthFactor: 0.55,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
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
          ),
          if (point != visiblePoints.last) const SizedBox(width: 4),
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
            height: 160,
            child: points.isEmpty
                ? Center(child: Text(context.l10n.noData))
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final point in points)
                        Expanded(
                          child: Tooltip(
                            message: formatRubles(context, point.amount),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: FractionallySizedBox(
                                        heightFactor: maxValue == 0
                                            ? 0.02
                                            : math.max(
                                                0.04,
                                                point.amount / maxValue,
                                              ),
                                        widthFactor: 0.65,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary
                                                .withValues(alpha: 0.72),
                                            borderRadius:
                                                const BorderRadius.vertical(
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
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          if (points.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spaceM),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(context.l10n.monthlyAmounts),
              children: [
                for (final point in points)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingS,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat.yMMMM(
                              Localizations.localeOf(context).toLanguageTag(),
                            ).format(DateTime.parse('${point.month}-01')),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceM),
                        Flexible(
                          child: Text(
                            formatRubles(context, point.amount),
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TopSourcesCard extends StatelessWidget {
  const _TopSourcesCard({required this.items});
  final List<ImpulseTotal> items;

  @override
  Widget build(BuildContext context) {
    final maxValue = items.isEmpty
        ? 0.0
        : items.map((item) => item.amount).reduce(math.max);
    return GlassSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.topSavingsSources,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.paddingM,
              ),
              child: Text(context.l10n.noData),
            )
          else
            for (final item in items) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    formatRubles(context, item.amount),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              LinearProgressIndicator(
                value: maxValue == 0 ? 0 : item.amount / maxValue,
                minHeight: 8,
                borderRadius: AppDimensions.borderRadiusCircular,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
              ),
              const SizedBox(height: AppDimensions.spaceM),
            ],
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
              tooltip: context.l10n.addGoal,
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    goal.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  '${((goal.allocatedAmount / goal.targetAmount).clamp(0, 1) * 100).floor()}%',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.allocateGoal,
                  onPressed: context.watch<SavingsBloc>().state.isSaving
                      ? null
                      : () =>
                            showGoalAllocationDialog(context, goal, dashboard),
                  icon: const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 20,
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.editGoal,
                  onPressed: context.watch<SavingsBloc>().state.isSaving
                      ? null
                      : () => showGoalDialog(context, goal: goal),
                  icon: const Icon(Icons.edit_outlined, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (goal.allocatedAmount / goal.targetAmount).clamp(0, 1),
              minHeight: 10,
              borderRadius: AppDimensions.borderRadiusCircular,
            ),
            const SizedBox(height: 7),
            Text(
              '${formatRubles(context, goal.allocatedAmount)} / ${formatRubles(context, goal.targetAmount)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              goal.allocatedAmount >= goal.targetAmount
                  ? context.l10n.goalReached
                  : context.l10n.goalRemaining(
                      formatRubles(
                        context,
                        goal.targetAmount - goal.allocatedAmount,
                      ),
                    ),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        if (dashboard.goals.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            context.l10n.unallocatedMoney(
              formatRubles(
                context,
                math.max(
                  0,
                  dashboard.investedTotal -
                      dashboard.goals.fold<double>(
                        0,
                        (sum, goal) => sum + goal.allocatedAmount,
                      ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            context.l10n.goalProgressExplanation,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
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
                backgroundColor: event.isInvested
                    ? AppColors.success.withValues(alpha: 0.13)
                    : Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  event.isInvested
                      ? Icons.account_balance_outlined
                      : Icons.check_rounded,
                  color: event.isInvested
                      ? AppColors.success
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(
                event.impulseName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                DateFormat.MMMd(
                  Localizations.localeOf(context).toLanguageTag(),
                ).format(event.occurredAt),
              ),
              trailing: Text(
                '+${formatRubles(context, event.amount, currencyCode: event.currencyCode)}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w800,
                ),
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
          Icon(
            Icons.savings_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
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
