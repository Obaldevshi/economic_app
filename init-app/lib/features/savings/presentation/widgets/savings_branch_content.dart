import 'package:flutter/widgets.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/services/offline_savings_service.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_template/features/savings/presentation/widgets/financial_display_scope.dart';
import 'package:mobile_template/features/savings/presentation/pages/bloc/savings_bloc.dart';
import 'package:mobile_template/features/shell/presentation/widgets/navigation_branch_scope.dart';

/// Refresh retained branch data without recreating its BLoC or page state.
class SavingsBranchContent extends StatefulWidget {
  const SavingsBranchContent({
    required this.branch,
    required this.refreshEvents,
    required this.child,
    super.key,
  });

  final AppNavigationBranch branch;
  final List<SavingsEvent> refreshEvents;
  final Widget child;

  @override
  State<SavingsBranchContent> createState() => _SavingsBranchContentState();
}

class _SavingsBranchContentState extends State<SavingsBranchContent> {
  bool? _wasActive;
  Timer? _refreshTimer;
  final _offline = getIt<OfflineSavingsService>();
  int _revision = 0;

  @override
  void initState() {
    super.initState();
    _revision = _offline.revision;
    _offline.addListener(_offlineChanged);
    _refreshTimer = Timer.periodic(const Duration(hours: 1), (_) {
      if (_wasActive == true && mounted) {
        context.read<SavingsBloc>().add(const LoadSavingsDashboard());
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _offline.removeListener(_offlineChanged);
    super.dispose();
  }

  void _offlineChanged() {
    if (_revision == _offline.revision || !mounted) return;
    _revision = _offline.revision;
    if (_wasActive != true) return;
    final bloc = context.read<SavingsBloc>();
    for (final event in widget.refreshEvents) {
      bloc.add(event);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final active = NavigationBranchScope.isActive(context, widget.branch);
    // Initial loading is owned by the existing route provider.
    if (_wasActive == false && active) {
      final bloc = context.read<SavingsBloc>();
      for (final event in widget.refreshEvents) {
        bloc.add(event);
      }
    }
    _wasActive = active;
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<SavingsBloc, SavingsState>(
    builder: (context, state) => FinancialDisplayScope(
      data: FinancialDisplayData.fromState(state),
      child: widget.child,
    ),
  );
}
