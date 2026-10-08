import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
import 'package:mobile_template/features/savings/presentation/pages/bloc/savings_bloc.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_dialogs.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_ui.dart';
import 'package:mobile_template/presentation/widgets/common/confirmation_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/error_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:mobile_template/presentation/widgets/layout/scroll_shell.dart';

class ImpulseItemsPage extends StatelessWidget {
  const ImpulseItemsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocConsumer<SavingsBloc, SavingsState>(
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
    builder: (context, state) => ScrollShell(
      title: context.l10n.habits,
      expandedHeaderHeight: 58,
      isLoading: state.isLoading && state.impulses.isEmpty,
      onRefresh: () async {
        context.read<SavingsBloc>().add(const LoadImpulseItems());
        await context.read<SavingsBloc>().stream.firstWhere(
          (value) => !value.isLoading,
        );
      },
      actions: [
        IconButton(
          tooltip: context.l10n.addHabit,
          onPressed: () => showImpulseEditorDialog(context),
          icon: const Icon(Icons.add_rounded),
        ),
      ],
      headerContent: Text(
        context.l10n.habitsDescription,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white.withValues(alpha: 0.92),
          fontWeight: FontWeight.w600,
        ),
      ),
      body: state.impulses.isEmpty
          ? _EmptyHabits(onAdd: () => showImpulseEditorDialog(context))
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _PotentialSummary(items: state.impulses),
                    const SizedBox(height: AppDimensions.spaceL),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.quickChoices,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.l10n.impulseAnnualHint,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: () => showImpulseEditorDialog(context),
                          icon: const Icon(Icons.add_rounded),
                          label: Text(context.l10n.addHabit),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spaceM),
                    AppLayoutItemBuilder<Widget>(
                      narrow: () => Column(
                        children: [
                          for (final item in state.impulses)
                            _HabitCard(item: item, allItems: state.impulses),
                        ],
                      ),
                      wide: () => GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.impulses.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 390,
                              mainAxisExtent: 228,
                              crossAxisSpacing: AppDimensions.spaceM,
                              mainAxisSpacing: AppDimensions.spaceM,
                            ),
                        itemBuilder: (context, index) => _HabitCard(
                          item: state.impulses[index],
                          allItems: state.impulses,
                          addBottomSpacing: false,
                        ),
                      ),
                    )(context),
                  ],
                ),
              ),
            ),
    ),
  );
}

class _PotentialSummary extends StatelessWidget {
  const _PotentialSummary({required this.items});

  final List<ImpulseItemResponse> items;

  @override
  Widget build(BuildContext context) {
    final annual = items.fold<double>(
      0,
      (total, item) => total + impulseAnnualPotential(item),
    );
    final weekly = items.fold<double>(
      0,
      (total, item) => total + item.defaultAmount * item.weeklyFrequency,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: AppDimensions.borderRadiusXL,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: AppLayoutItemBuilder<Widget>(
          narrow: () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SummaryValue(
                icon: Icons.calendar_view_week_outlined,
                label: context.l10n.weeklyPotential,
                value: formatRubles(context, weekly),
              ),
              const SizedBox(height: AppDimensions.spaceM),
              _SummaryValue(
                icon: Icons.rocket_launch_outlined,
                label: context.l10n.annualPotential,
                value: formatRubles(context, annual),
                highlighted: true,
              ),
            ],
          ),
          wide: () => Row(
            children: [
              Expanded(
                child: _SummaryValue(
                  icon: Icons.calendar_view_week_outlined,
                  label: context.l10n.weeklyPotential,
                  value: formatRubles(context, weekly),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceXL),
              Expanded(
                child: _SummaryValue(
                  icon: Icons.rocket_launch_outlined,
                  label: context.l10n.annualPotential,
                  value: formatRubles(context, annual),
                  highlighted: true,
                ),
              ),
            ],
          ),
        )(context, width: 700),
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({
    required this.icon,
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: highlighted
              ? AppColors.accent.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: AppDimensions.borderRadiusM,
        ),
        child: Icon(
          icon,
          color: highlighted ? AppColors.accent : AppColors.primaryLight,
        ),
      ),
      const SizedBox(width: AppDimensions.spaceM),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({
    required this.item,
    required this.allItems,
    this.addBottomSpacing = true,
  });

  final ImpulseItemResponse item;
  final List<ImpulseItemResponse> allItems;
  final bool addBottomSpacing;

  @override
  Widget build(BuildContext context) {
    final annual = impulseAnnualPotential(item);
    return Padding(
      padding: EdgeInsets.only(
        bottom: addBottomSpacing ? AppDimensions.spaceM : 0,
      ),
      child: GlassSurfaceCard(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                GlassIconBadge(
                  color: AppColors.primary,
                  child: Icon(
                    impulseIcon(item.iconKey),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${formatRubles(context, item.defaultAmount)} · ${item.weeklyFrequency}×/${context.l10n.weekShort}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: context.l10n.editImpulse,
                  onSelected: (value) {
                    if (value == 'edit') {
                      showImpulseEditorDialog(context, item: item);
                    } else if (value == 'delete') {
                      ConfirmationDialog.show(
                        context,
                        title: context.l10n.delete,
                        content: context.l10n.deleteHabitConfirmation,
                        confirmText: context.l10n.delete,
                        isDestructive: true,
                        onConfirm: () => context.read<SavingsBloc>().add(
                          DeleteImpulseItem(item.id),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.edit_outlined),
                        title: Text(context.l10n.edit),
                      ),
                    ),
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
            const SizedBox(height: AppDimensions.spaceM),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingS,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: AppDimensions.borderRadiusM,
              ),
              child: Row(
                children: [
                  Text(
                    context.l10n.annualPotential,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    formatCompactRubles(context, annual),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            FilledButton.tonalIcon(
              onPressed: () =>
                  showAddSavingDialog(context, allItems, initialImpulse: item),
              icon: const Icon(Icons.add_task_rounded),
              label: Text(context.l10n.recordThisSaving),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHabits extends StatelessWidget {
  const _EmptyHabits({required this.onAdd});
  final VoidCallback onAdd;

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
              Icons.coffee_outlined,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            context.l10n.noHabits,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(context.l10n.addHabit),
          ),
        ],
      ),
    ),
  );
}
