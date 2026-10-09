import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/utils/keyboard_inset.dart';
import 'package:mobile_template/presentation/widgets/common/glass_bottom_nav_bar.dart';
import 'package:mobile_template/presentation/widgets/common/brand_mark.dart';
import 'package:mobile_template/presentation/widgets/common/editorial_icons.dart';
import 'package:mobile_template/features/shell/presentation/widgets/navigation_branch_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/services/savings_native_service.dart';

/// Main shell: bottom navigation on narrow screens and top navigation on web.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  @override
  void initState() {
    super.initState();
    getIt<SavingsNativeService>().pendingImpulse.addListener(_widgetTap);
    WidgetsBinding.instance.addPostFrameCallback((_) => _widgetTap());
  }

  void _widgetTap() {
    if (mounted && getIt<SavingsNativeService>().pendingImpulse.value != null) {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    getIt<SavingsNativeService>().pendingImpulse.removeListener(_widgetTap);
    super.dispose();
  }

  void _onTabSelected(int index) {
    KeyboardInset.dismiss();
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final inactiveColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final items = [
      _AdaptiveNavigationItem(
        label: context.l10n.home,
        icon: EditorialNavIconKind.overview,
      ),
      _AdaptiveNavigationItem(
        label: context.l10n.history,
        icon: EditorialNavIconKind.history,
      ),
      _AdaptiveNavigationItem(
        label: context.l10n.habits,
        icon: EditorialNavIconKind.impulses,
      ),
      _AdaptiveNavigationItem(
        label: context.l10n.profile,
        icon: EditorialNavIconKind.profile,
      ),
    ];

    return NavigationBranchScope(
      currentIndex: widget.navigationShell.currentIndex,
      child: AppLayoutItemBuilder<Widget>(
        narrow: () => _buildNarrowNavigation(context, items, inactiveColor),
        wide: () => _buildWideNavigation(context, items, inactiveColor),
      )(context),
    );
  }

  Widget _buildNarrowNavigation(
    BuildContext context,
    List<_AdaptiveNavigationItem> items,
    Color inactiveColor,
  ) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.navigationShell,
          KeyboardInsetBuilder(
            builder: (context, keyboardInset) {
              if (keyboardInset > 0) return const SizedBox.shrink();
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: GlassBottomNavBar(
                  currentIndex: widget.navigationShell.currentIndex,
                  onTabSelected: _onTabSelected,
                  items: items
                      .map(
                        (item) => GlassNavBarItem(
                          label: item.label,
                          icon: EditorialNavIcon(
                            kind: item.icon,
                            color: inactiveColor,
                          ),
                          activeIcon: EditorialNavIcon(
                            kind: item.icon,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWideNavigation(
    BuildContext context,
    List<_AdaptiveNavigationItem> items,
    Color inactiveColor,
  ) {
    final theme = Theme.of(context);
    final showLabels = AppLayoutItemBuilder<bool>.values(
      narrow: false,
      wide: true,
    )(context, width: 760);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingL,
                AppDimensions.paddingM,
                AppDimensions.paddingL,
                AppDimensions.paddingS,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                ),
                child: SizedBox(
                  height: 74,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                    ),
                    child: Row(
                      children: [
                        const BrandMark(size: 34),
                        const SizedBox(width: AppDimensions.spaceS),
                        Text(
                          context.l10n.appName,
                          style: theme.textTheme.titleLarge,
                        ),
                        const Spacer(),
                        for (var index = 0; index < items.length; index++) ...[
                          _WebNavigationButton(
                            item: items[index],
                            selected:
                                widget.navigationShell.currentIndex == index,
                            showLabel: showLabels,
                            inactiveColor: inactiveColor,
                            onPressed: () => _onTabSelected(index),
                          ),
                          if (index != items.length - 1)
                            const SizedBox(width: AppDimensions.spaceS),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: widget.navigationShell),
        ],
      ),
    );
  }
}

class _WebNavigationButton extends StatelessWidget {
  const _WebNavigationButton({
    required this.item,
    required this.selected,
    required this.showLabel,
    required this.inactiveColor,
    required this.onPressed,
  });

  final _AdaptiveNavigationItem item;
  final bool selected;
  final bool showLabel;
  final Color inactiveColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = selected ? theme.colorScheme.primary : inactiveColor;

    return Tooltip(
      message: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppDimensions.borderRadiusS,
          child: Container(
            height: 58,
            padding: EdgeInsets.symmetric(
              horizontal: showLabel
                  ? AppDimensions.paddingM
                  : AppDimensions.paddingS,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected ? foreground : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EditorialNavIcon(kind: item.icon, color: foreground),
                  if (showLabel) ...[
                    const SizedBox(width: AppDimensions.spaceS),
                    Text(
                      item.label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: foreground,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdaptiveNavigationItem {
  const _AdaptiveNavigationItem({required this.label, required this.icon});

  final String label;
  final EditorialNavIconKind icon;
}
