import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
import 'package:mobile_template/features/savings/presentation/pages/bloc/savings_bloc.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_ui.dart';
import 'package:mobile_template/presentation/widgets/common/confirmation_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/error_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:mobile_template/presentation/widgets/layout/scroll_shell.dart';

enum _HistoryFilter { all, invested, potential }

class SavingHistoryPage extends StatefulWidget {
  const SavingHistoryPage({super.key});

  @override
  State<SavingHistoryPage> createState() => _SavingHistoryPageState();
}

class _SavingHistoryPageState extends State<SavingHistoryPage> {
  _HistoryFilter _filter = _HistoryFilter.all;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SavingsBloc, SavingsState>(
      listenWhen: (previous, current) =>
          previous.failure != current.failure ||
          previous.actionMessage != current.actionMessage,
      listener: (context, state) {
        if (state.failure != null) {
          ErrorDialog.show(context, state.failure!);
        } else if (state.actionMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.actionMessage!)));
        }
      },
      builder: (context, state) {
        final filtered = switch (_filter) {
          _HistoryFilter.all => state.history,
          _HistoryFilter.invested =>
            state.history.where((event) => event.isInvested).toList(),
          _HistoryFilter.potential =>
            state.history.where((event) => !event.isInvested).toList(),
        };

        return ScrollShell(
          title: context.l10n.history,
          expandedHeaderHeight: 58,
          isLoading: state.isLoading && state.history.isEmpty,
          onRefresh: () async {
            context.read<SavingsBloc>()
              ..add(const LoadSavingHistory())
              ..add(const LoadSavingsDashboard());
            await context.read<SavingsBloc>().stream.firstWhere(
              (value) => !value.isLoading,
            );
          },
          headerContent: Text(
            context.l10n.historyDescription,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              fontWeight: FontWeight.w600,
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: state.history.isEmpty
                  ? const _EmptyHistory()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _HistoryOverview(
                          events: state.history,
                          totalCount: state.historyTotal,
                          dashboard: state.dashboard,
                        ),
                        const SizedBox(height: AppDimensions.spaceL),
                        Text(
                          context.l10n.historyOverview,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppDimensions.spaceM),
                        Wrap(
                          spacing: AppDimensions.spaceS,
                          runSpacing: AppDimensions.spaceS,
                          children: [
                            ChoiceChip(
                              label: Text(context.l10n.allSavings),
                              selected: _filter == _HistoryFilter.all,
                              onSelected: (_) =>
                                  setState(() => _filter = _HistoryFilter.all),
                            ),
                            ChoiceChip(
                              avatar: const Icon(
                                Icons.account_balance_outlined,
                                size: 18,
                              ),
                              label: Text(context.l10n.realSavings),
                              selected: _filter == _HistoryFilter.invested,
                              onSelected: (_) => setState(
                                () => _filter = _HistoryFilter.invested,
                              ),
                            ),
                            ChoiceChip(
                              avatar: const Icon(
                                Icons.savings_outlined,
                                size: 18,
                              ),
                              label: Text(context.l10n.potentialSavings),
                              selected: _filter == _HistoryFilter.potential,
                              onSelected: (_) => setState(
                                () => _filter = _HistoryFilter.potential,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spaceL),
                        if (filtered.isEmpty)
                          _FilteredEmptyState(
                            message: context.l10n.noFilteredHistory,
                          )
                        else
                          ..._buildGroupedHistory(context, filtered),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildGroupedHistory(
    BuildContext context,
    List<SavingEventResponse> events,
  ) {
    final widgets = <Widget>[];
    String? previousGroup;
    for (final event in events) {
      final group = _dateGroup(context, event.occurredAt);
      if (group != previousGroup) {
        if (widgets.isNotEmpty) {
          widgets.add(const SizedBox(height: AppDimensions.spaceS));
        }
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(
              left: AppDimensions.paddingXS,
              bottom: AppDimensions.paddingS,
            ),
            child: Text(
              group,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
        previousGroup = group;
      }
      widgets.add(_HistoryItem(event: event));
    }
    return widgets;
  }

  String _dateGroup(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final value = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);
    if (value == today) return context.l10n.today;
    if (value == today.subtract(const Duration(days: 1))) {
      return context.l10n.yesterday;
    }
    return context.l10n.past;
  }
}

class _HistoryOverview extends StatelessWidget {
  const _HistoryOverview({
    required this.events,
    required this.totalCount,
    this.dashboard,
  });

  final List<SavingEventResponse> events;
  final int totalCount;
  final SavingsDashboardResponse? dashboard;

  @override
  Widget build(BuildContext context) {
    final total =
        dashboard?.totalSaved ??
        events.fold<double>(0, (sum, event) => sum + event.amount);
    final invested =
        dashboard?.investedTotal ??
        events
            .where((event) => event.isInvested)
            .fold<double>(0, (sum, event) => sum + event.amount);
    final cards = [
      (
        context.l10n.savedTotal,
        formatRubles(context, total),
        Icons.savings_outlined,
        AppColors.primary,
      ),
      (
        context.l10n.realSavings,
        formatRubles(context, invested),
        Icons.account_balance_outlined,
        AppColors.success,
      ),
      (
        context.l10n.decisionCount,
        NumberFormat.decimalPattern(
          Localizations.localeOf(context).toLanguageTag(),
        ).format(totalCount),
        Icons.check_circle_outline_rounded,
        AppColors.secondary,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 720
            ? 3
            : constraints.maxWidth >= 500
            ? 2
            : 1;
        final cardWidth =
            (constraints.maxWidth - AppDimensions.spaceM * (columns - 1)) /
            columns;
        return Wrap(
          spacing: AppDimensions.spaceM,
          runSpacing: AppDimensions.spaceM,
          children: [
            for (final card in cards)
              SizedBox(
                width: cardWidth,
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
                              card.$2,
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

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({required this.event});
  final SavingEventResponse event;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppDimensions.spaceM),
    child: GlassSurfaceCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: event.isInvested
                ? AppColors.success.withValues(alpha: 0.14)
                : AppColors.primaryContainer,
            child: Icon(
              event.isInvested
                  ? Icons.account_balance_outlined
                  : Icons.check_rounded,
              color: event.isInvested ? AppColors.success : AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.impulseName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat.yMMMd(
                    Localizations.localeOf(context).toLanguageTag(),
                  ).add_Hm().format(event.occurredAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                if (event.note?.isNotEmpty == true) ...[
                  const SizedBox(height: 5),
                  Text(
                    event.note!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spaceS),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${formatRubles(context, event.amount)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: event.isInvested
                        ? context.l10n.realSavings
                        : context.l10n.potentialSavings,
                    child: Icon(
                      event.isInvested
                          ? Icons.verified_rounded
                          : Icons.hourglass_bottom_rounded,
                      size: 18,
                      color: event.isInvested
                          ? AppColors.success
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  PopupMenuButton<String>(
                    tooltip: context.l10n.delete,
                    onSelected: (_) => ConfirmationDialog.show(
                      context,
                      title: context.l10n.delete,
                      content: context.l10n.deleteSavingConfirmation,
                      confirmText: context.l10n.delete,
                      isDestructive: true,
                      onConfirm: () => context.read<SavingsBloc>().add(
                        DeleteSavingEvent(event.id),
                      ),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.error,
                          ),
                          title: Text(context.l10n.delete),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _FilteredEmptyState extends StatelessWidget {
  const _FilteredEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => GlassSurfaceCard(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
      child: Column(
        children: [
          Icon(
            Icons.filter_alt_off_outlined,
            size: 42,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            context.l10n.noHistory,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    ),
  );
}
