import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  Widget build(BuildContext context) => widget.child;
}
