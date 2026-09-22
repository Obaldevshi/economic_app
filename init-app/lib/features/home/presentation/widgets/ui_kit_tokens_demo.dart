import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/app/theme/app_glass.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:flutter/material.dart';

class UiKitTokensDemo extends StatelessWidget {
  const UiKitTokensDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final spacings = <String, double>{
      'XS': AppDimensions.spaceXS,
      'S': AppDimensions.spaceS,
      'M': AppDimensions.spaceM,
      'L': AppDimensions.spaceL,
      'XL': AppDimensions.spaceXL,
    };

    return GlassSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeRadius,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppDimensions.radius),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Text(
                '${AppDimensions.radius.toInt()} px',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceL),
          Text(
            l10n.homeSpacing,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          for (final entry in spacings.entries) ...[
            Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    entry.key,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Container(
                  height: 10,
                  width: entry.value * 3,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${entry.value.toInt()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceS),
          ],
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            l10n.homeGlassTokens,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          const _TokenRow(label: 'Rendering', value: 'Solid'),
          _TokenRow(label: 'Border', value: '${AppGlass.borderWidth} px'),
        ],
      ),
    );
  }
}

class _TokenRow extends StatelessWidget {
  const _TokenRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
