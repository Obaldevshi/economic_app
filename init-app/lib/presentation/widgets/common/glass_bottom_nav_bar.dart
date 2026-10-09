import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';

class GlassNavBarItem {
  const GlassNavBarItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
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
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Material(
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: AppDimensions.borderRadiusL,
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: double.infinity,
              height: 72,
              child: Row(
                children: [
                  for (var index = 0; index < items.length; index++)
                    Expanded(
                      child: _NavItem(
                        item: items[index],
                        isSelected: currentIndex == index,
                        onTap: () {
                          if (currentIndex == index) return;
                          HapticFeedback.selectionClick();
                          onTabSelected(index);
                        },
                      ),
                    ),
                ],
              ),
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

    final foreground = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    return Tooltip(
      message: item.label,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Material(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: AppDimensions.borderRadiusS,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppDimensions.borderRadiusS,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isSelected ? item.activeIcon : item.icon,
                const SizedBox(height: 3),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: foreground,
                    fontSize: 10,
                    letterSpacing: 0,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
