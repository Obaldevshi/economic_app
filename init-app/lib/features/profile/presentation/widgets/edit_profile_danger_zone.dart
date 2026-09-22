import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:flutter/material.dart';

class EditProfileDangerZone extends StatelessWidget {
  const EditProfileDangerZone({required this.onDelete, super.key});

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.error),
              const SizedBox(width: AppDimensions.spaceS),
              Text(
                context.l10n.dangerZone,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            context.l10n.deleteAccountDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          OutlinedButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_forever_outlined),
            label: Text(context.l10n.deleteAccount),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              minimumSize: const Size.fromHeight(AppDimensions.buttonHeightM),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
