import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/data/models/request/savings_request.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
import 'package:mobile_template/features/savings/presentation/pages/bloc/savings_bloc.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_ui.dart';

class ProjectionPeriodSelector extends StatelessWidget {
  const ProjectionPeriodSelector({
    required this.dashboard,
    this.onDark = false,
    super.key,
  });

  final SavingsDashboardResponse dashboard;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SavingsBloc>().state;
    final busy = state.isSaving || state.isLoading;
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final years in projectionPeriods)
          ChoiceChip(
            label: Text(context.l10n.projectionPeriod(years)),
            selected: dashboard.projectionYears == years,
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            selectedColor: onDark ? AppColors.accent : null,
            backgroundColor: onDark ? AppColors.primaryDark : null,
            side: onDark
                ? BorderSide(color: Colors.white.withValues(alpha: 0.4))
                : null,
            labelStyle: onDark
                ? TextStyle(
                    color: dashboard.projectionYears == years
                        ? AppColors.primaryDark
                        : Colors.white,
                  )
                : null,
            onSelected: busy
                ? null
                : (selected) {
                    if (!selected || years == dashboard.projectionYears) return;
                    context.read<SavingsBloc>().add(
                      UpdateSavingsSettings(
                        SavingsSettingsRequest(
                          annualRate: dashboard.annualRate,
                          projectionYears: years,
                        ),
                      ),
                    );
                  },
          ),
      ],
    );
  }
}
