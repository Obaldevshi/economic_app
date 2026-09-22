import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class CategoriesSearchField extends StatelessWidget {
  const CategoriesSearchField({
    required this.controller,
    required this.query,
    super.key,
  });

  final TextEditingController controller;
  final String query;

  static final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppDimensions.radius),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = AppLayoutItemBuilder<bool>.values(narrow: false, wide: true)(
      context,
    );
    final foreground = isWide ? theme.colorScheme.onSurface : Colors.white;
    final mutedForeground = isWide
        ? theme.colorScheme.onSurfaceVariant
        : Colors.white.withValues(alpha: 0.7);

    return TextField(
      controller: controller,
      style: TextStyle(color: foreground, fontSize: 15),
      cursorColor: isWide ? theme.colorScheme.primary : Colors.white,
      decoration: InputDecoration(
        hintText: context.l10n.searchCategories,
        hintStyle: TextStyle(color: mutedForeground),
        prefixIcon: Icon(Icons.search, color: mutedForeground, size: 22),
        suffixIcon: query.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: mutedForeground,
                  size: 20,
                ),
                onPressed: () => controller.clear(),
              )
            : null,
        filled: true,
        fillColor: isWide
            ? theme.colorScheme.surfaceContainerHighest
            : Colors.white.withValues(alpha: 0.15),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: _border,
        enabledBorder: _border,
        focusedBorder: _border,
      ),
    );
  }
}
