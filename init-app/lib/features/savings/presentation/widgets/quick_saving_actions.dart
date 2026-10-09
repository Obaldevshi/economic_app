import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/services/savings_native_service.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/features/savings/presentation/pages/bloc/savings_bloc.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_dialogs.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_ui.dart';
import 'package:mobile_template/features/shell/presentation/widgets/navigation_branch_scope.dart';

class QuickSavingActions extends StatefulWidget {
  const QuickSavingActions({super.key});

  @override
  State<QuickSavingActions> createState() => _QuickSavingActionsState();
}

class _QuickSavingActionsState extends State<QuickSavingActions> {
  bool _opening = false;

  @override
  Widget build(BuildContext context) {
    final native = getIt<SavingsNativeService>();
    return ValueListenableBuilder<int?>(
      valueListenable: native.pendingImpulse,
      builder: (context, pending, _) {
        final state = context.watch<SavingsBloc>().state;
        if (pending != null &&
            !_opening &&
            NavigationBranchScope.isActive(context, AppNavigationBranch.home) &&
            !state.isImpulseLoading &&
            !state.isSaving &&
            !state.impulseLoadFailed) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!context.mounted || native.pendingImpulse.value != pending)
              return;
            if (!NavigationBranchScope.isActive(
              context,
              AppNavigationBranch.home,
            ))
              return;
            final current = context.read<SavingsBloc>().state;
            if (_opening || current.isImpulseLoading || current.isSaving)
              return;
            native.pendingImpulse.value = null;
            final item = current.impulses
                .where((item) => item.id == pending && item.isActive)
                .firstOrNull;
            if (item != null) {
              _opening = true;
              try {
                await showAddSavingDialog(
                  context,
                  current.impulses,
                  initialImpulse: item,
                );
              } finally {
                if (mounted) setState(() => _opening = false);
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.widgetItemUnavailable)),
              );
            }
          });
        }
        return ValueListenableBuilder<List<int>>(
          valueListenable: native.favorites,
          builder: (context, ids, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.favoriteActions,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (ids.isEmpty) Text(context.l10n.favoriteActionsHint),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final item in state.impulses.where(
                    (item) => ids.contains(item.id) && item.isActive,
                  ))
                    ActionChip(
                      label: Text(
                        '${item.name} · ${formatRubles(context, item.defaultAmount, currencyCode: item.currencyCode)}',
                      ),
                      onPressed: state.isSaving
                          ? null
                          : () => showAddSavingDialog(
                              context,
                              state.impulses,
                              initialImpulse: item,
                            ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
