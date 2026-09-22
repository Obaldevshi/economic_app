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
    listenWhen: (previous, current) => previous.failure != current.failure,
    listener: (context, state) {
      if (state.failure != null) ErrorDialog.show(context, state.failure!);
    },
    builder: (context, state) => ScrollShell(
      title: context.l10n.habits,
      expandedHeaderHeight: 48,
      isLoading: state.isLoading && state.impulses.isEmpty,
      actions: [
        IconButton(
          tooltip: context.l10n.addHabit,
          onPressed: () => showImpulseEditorDialog(context),
          icon: const Icon(Icons.add_rounded),
        ),
      ],
      headerContent: Text(
        context.l10n.habitsDescription,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: Colors.white),
      ),
      body: state.impulses.isEmpty
          ? _EmptyHabits(onAdd: () => showImpulseEditorDialog(context))
          : AppLayoutItemBuilder<Widget>(
              narrow: () => Column(
                children: [
                  for (final item in state.impulses) _HabitCard(item: item),
                ],
              ),
              wide: () => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.impulses.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 420,
                  mainAxisExtent: 150,
                  crossAxisSpacing: AppDimensions.spaceM,
                  mainAxisSpacing: AppDimensions.spaceM,
                ),
                itemBuilder: (context, index) =>
                    _HabitCard(item: state.impulses[index]),
              ),
            )(context),
    ),
  );
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({required this.item});
  final ImpulseItemResponse item;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppDimensions.spaceM),
    child: GlassSurfaceCard(
      onTap: () => showImpulseEditorDialog(context, item: item),
      child: Row(
        children: [
          GlassIconBadge(
            color: AppColors.primary,
            child: Icon(impulseIcon(item.iconKey), color: AppColors.primary),
          ),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  '${formatRubles(context, item.defaultAmount)} · ${item.weeklyFrequency}×/${context.l10n.weekShort}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: context.l10n.delete,
            onPressed: () => ConfirmationDialog.show(
              context,
              title: context.l10n.delete,
              content: context.l10n.deleteHabitConfirmation,
              confirmText: context.l10n.delete,
              isDestructive: true,
              onConfirm: () =>
                  context.read<SavingsBloc>().add(DeleteImpulseItem(item.id)),
            ),
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
    ),
  );
}

class _EmptyHabits extends StatelessWidget {
  const _EmptyHabits({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.coffee_outlined, size: 60, color: AppColors.primary),
        const SizedBox(height: AppDimensions.spaceM),
        Text(
          context.l10n.noHabits,
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
  );
}
