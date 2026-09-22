import 'package:flutter/material.dart';
import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';

class UiKitHeroBanner extends StatelessWidget {
  const UiKitHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppLayoutItemBuilder<Widget>(
      narrow: () => GlassSurfaceCard(
        variant: GlassSurfaceVariant.onGradient,
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: _buildContent(
          context,
          foreground: Colors.white,
          centered: false,
        ),
      ),
      wide: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 56),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _buildContent(
                context,
                foreground: theme.colorScheme.onSurface,
                centered: false,
                largeTitle: true,
              ),
            ),
            const SizedBox(width: 48),
            Expanded(child: _buildWebPreview(context)),
          ],
        ),
      ),
    )(context, width: 900);
  }

  Widget _buildContent(
    BuildContext context, {
    required Color foreground,
    required bool centered,
    bool largeTitle = false,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: centered
                ? theme.colorScheme.surfaceContainerHighest
                : Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(AppDimensions.radius),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingS,
              vertical: AppDimensions.paddingXS,
            ),
            child: Text(
              context.l10n.homeUiKitSubtitle,
              style: theme.textTheme.labelMedium?.copyWith(
                color: centered ? theme.colorScheme.primary : foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceM),
        Text(
          context.l10n.homeUiKitTitle,
          style:
              (largeTitle
                      ? theme.textTheme.displayLarge
                      : centered
                      ? theme.textTheme.displayMedium
                      : theme.textTheme.headlineMedium)
                  ?.copyWith(color: foreground, fontWeight: FontWeight.w800),
          textAlign: centered ? TextAlign.center : TextAlign.left,
        ),
        SizedBox(
          height: centered ? AppDimensions.spaceM : AppDimensions.spaceS,
        ),
        Text(
          context.l10n.homeUiKitDescription,
          style:
              (largeTitle || centered
                      ? theme.textTheme.titleLarge
                      : theme.textTheme.bodyMedium)
                  ?.copyWith(
                    color: foreground.withValues(alpha: 0.88),
                    height: 1.45,
                  ),
          textAlign: centered ? TextAlign.center : TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildWebPreview(BuildContext context) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: 1.25,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: AppDimensions.borderRadius,
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Stack(
          children: [
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                heightFactor: 0.5,
                child: Transform.rotate(
                  angle: -0.08,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: AppDimensions.borderRadius,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.l10n.appName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            context.l10n.homeUiKitTitle,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: AppDimensions.paddingL,
              bottom: AppDimensions.paddingL,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: AppDimensions.borderRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                    vertical: AppDimensions.paddingS,
                  ),
                  child: Text(
                    context.l10n.homeUiKitSubtitle,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
