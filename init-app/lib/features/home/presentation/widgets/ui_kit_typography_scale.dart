import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/app/theme/app_text_styles.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:flutter/material.dart';

class UiKitTypographyScale extends StatelessWidget {
  const UiKitTypographyScale({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sample = context.l10n.homeTypographySample;

    final styles = <String, TextStyle>{
      'Display L': theme.textTheme.displayLarge!,
      'Display M': theme.textTheme.displayMedium!,
      'Headline M': theme.textTheme.headlineMedium!,
      'Title L': theme.textTheme.titleLarge!,
      'Title M': theme.textTheme.titleMedium!,
      'Body L': theme.textTheme.bodyLarge!,
      'Body M': theme.textTheme.bodyMedium!,
      'Label M': theme.textTheme.labelMedium!,
      'Label S': theme.textTheme.labelSmall!,
    };

    return GlassSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.homeFontFamily,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Row(
            children: [
              _FontWeightChip(
                label: context.l10n.homeFontRegular,
                weight: FontWeight.w400,
              ),
              const SizedBox(width: AppDimensions.spaceS),
              _FontWeightChip(
                label: context.l10n.homeFontMedium,
                weight: FontWeight.w500,
              ),
              const SizedBox(width: AppDimensions.spaceS),
              _FontWeightChip(
                label: context.l10n.homeFontBold,
                weight: FontWeight.w700,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceL),
          for (final entry in styles.entries) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(
                  width: 88,
                  child: Text(
                    entry.key,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: AppTextStyles.fontFamily,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    sample,
                    style: entry.value.copyWith(
                      fontFamily: AppTextStyles.fontFamily,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceM),
          ],
        ],
      ),
    );
  }
}

class _FontWeightChip extends StatelessWidget {
  const _FontWeightChip({required this.label, required this.weight});

  final String label;
  final FontWeight weight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppDimensions.radius),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontWeight: weight,
          fontSize: 13,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
