import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/data/models/response/category_response.dart';
import 'package:mobile_template/generated/assets.gen.dart';
import 'package:mobile_template/presentation/widgets/common/app_svg_icon.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
    this.onTap,
    this.onDelete,
  });

  final CategoryResponse category;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: AppSvgIcon(
            icon: Assets.icons.category,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          category.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(
            Icons.more_horiz,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onTap?.call();
              case 'delete':
                onDelete?.call();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  AppSvgIcon(icon: Assets.icons.edit, size: 20),
                  const SizedBox(width: 8),
                  Text(context.l10n.edit),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  AppSvgIcon(
                    icon: Assets.icons.delete,
                    size: 20,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.delete,
                    style: const TextStyle(color: AppColors.error),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
