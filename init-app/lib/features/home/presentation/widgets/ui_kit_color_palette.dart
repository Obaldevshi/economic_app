import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/app/theme/app_glass.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:mobile_template/app/layout/app_layout_item_builder.dart';

class _ColorSwatch {
  const _ColorSwatch(this.name, this.color, this.hex);

  final String name;
  final Color color;
  final String hex;
}

class UiKitColorPalette extends StatelessWidget {
  const UiKitColorPalette({super.key});

  String _hex(Color color) {
    final value = color.toARGB32() & 0xFFFFFF;
    return '#${value.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final background = isDark ? AppColors.backgroundDark : AppColors.background;

    final swatches = [
      _ColorSwatch(
        l10n.colorPrimary,
        AppColors.primary,
        _hex(AppColors.primary),
      ),
      _ColorSwatch(
        l10n.colorPrimaryLight,
        AppColors.primaryLight,
        _hex(AppColors.primaryLight),
      ),
      _ColorSwatch(
        l10n.colorPrimaryDark,
        AppColors.primaryDark,
        _hex(AppColors.primaryDark),
      ),
      _ColorSwatch(
        l10n.colorSecondary,
        AppColors.secondary,
        _hex(AppColors.secondary),
      ),
      _ColorSwatch(
        l10n.colorSuccess,
        AppColors.success,
        _hex(AppColors.success),
      ),
      _ColorSwatch(
        l10n.colorWarning,
        AppColors.warning,
        _hex(AppColors.warning),
      ),
      _ColorSwatch(l10n.colorError, AppColors.error, _hex(AppColors.error)),
      _ColorSwatch(l10n.colorSurface, surface, _hex(surface)),
      _ColorSwatch(l10n.colorBackground, background, _hex(background)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: AppLayoutItemBuilder<SliverGridDelegate>(
            narrow: () => const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppDimensions.spaceM,
              crossAxisSpacing: AppDimensions.spaceM,
              childAspectRatio: 1.35,
            ),
            wide: () => const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              mainAxisExtent: 150,
              mainAxisSpacing: AppDimensions.spaceM,
              crossAxisSpacing: AppDimensions.spaceM,
            ),
          )(context, width: 900),
          itemCount: swatches.length,
          itemBuilder: (context, index) => _SwatchCard(swatch: swatches[index]),
        ),
      ],
    );
  }
}

class _SwatchCard extends StatelessWidget {
  const _SwatchCard({required this.swatch});

  final _ColorSwatch swatch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightColor = swatch.color.computeLuminance() > 0.72;
    final radius = AppDimensions.radius;
    final borderColor = AppGlass.border(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: AppGlass.borderWidth),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - AppGlass.borderWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ColoredBox(
                color: swatch.color,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      swatch.hex,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isLightColor
                            ? AppColors.onSurface
                            : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ColoredBox(
                color: theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    swatch.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
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
