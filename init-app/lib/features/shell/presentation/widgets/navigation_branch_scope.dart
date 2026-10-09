import 'package:flutter/widgets.dart';

enum AppNavigationBranch { home, history, habits, profile }

/// Branch visibility also follows browser back/forward navigation.
class NavigationBranchScope extends InheritedWidget {
  const NavigationBranchScope({
    required this.currentIndex,
    required super.child,
    super.key,
  });

  final int currentIndex;

  static bool isActive(BuildContext context, AppNavigationBranch branch) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<NavigationBranchScope>();
    return scope == null || scope.currentIndex == branch.index;
  }

  @override
  bool updateShouldNotify(NavigationBranchScope oldWidget) =>
      currentIndex != oldWidget.currentIndex;
}
