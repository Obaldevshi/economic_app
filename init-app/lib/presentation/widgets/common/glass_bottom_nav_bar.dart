import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';

class GlassNavBarItem {
  const GlassNavBarItem({required this.icon, required this.activeIcon});

  final Widget icon;
  final Widget activeIcon;
}

/// Лёгкая нижняя навигация со сплошным фоном и без blur/градиентов.
class GlassBottomNavBar extends StatelessWidget {
  const GlassBottomNavBar({
    required this.currentIndex,
    required this.onTabSelected,
    required this.items,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final List<GlassNavBarItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset + 10),
      child: Center(
        child: Material(
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < items.length; index++)
                  _NavItem(
                    item: items[index],
                    isSelected: currentIndex == index,
                    onTap: () {
                      if (currentIndex == index) return;
                      HapticFeedback.selectionClick();
                      onTabSelected(index);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final GlassNavBarItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Material(
        color: isSelected
            ? theme.colorScheme.primaryContainer
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radius),
          child: SizedBox(
            width: 54,
            height: 52,
            child: Center(child: isSelected ? item.activeIcon : item.icon),
          ),
        ),
      ),
    );
  }
}
