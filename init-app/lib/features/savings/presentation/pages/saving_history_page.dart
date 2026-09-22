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

class SavingHistoryPage extends StatelessWidget {
  const SavingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) => BlocConsumer<SavingsBloc, SavingsState>(
    listenWhen: (previous, current) => previous.failure != current.failure,
    listener: (context, state) {
      if (state.failure != null) ErrorDialog.show(context, state.failure!);
    },
    builder: (context, state) => ScrollShell(
      title: context.l10n.history,
      expandedHeaderHeight: 48,
      isLoading: state.isLoading && state.history.isEmpty,
      onRefresh: () async {
        context.read<SavingsBloc>().add(const LoadSavingHistory());
        await context.read<SavingsBloc>().stream.firstWhere(
          (value) => !value.isLoading,
        );
      },
      headerContent: Text(
        context.l10n.historyDescription,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: Colors.white),
      ),
      body: state.history.isEmpty
          ? Center(child: Text(context.l10n.noHistory))
          : Column(
              children: [
                for (final event in state.history) _HistoryItem(event: event),
              ],
            ),
    ),
  );
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
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat.yMMMd(
                    Localizations.localeOf(context).toLanguageTag(),
                  ).add_Hm().format(event.occurredAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (event.note?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    event.note!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${formatRubles(context, event.amount)}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.success),
              ),
              IconButton(
                tooltip: context.l10n.delete,
                onPressed: () => ConfirmationDialog.show(
                  context,
                  title: context.l10n.delete,
                  content: context.l10n.deleteSavingConfirmation,
                  confirmText: context.l10n.delete,
                  isDestructive: true,
                  onConfirm: () => context.read<SavingsBloc>().add(
                    DeleteSavingEvent(event.id),
                  ),
                ),
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
