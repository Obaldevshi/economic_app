import 'package:flutter/material.dart';
import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/app/theme/app_glass.dart';
import 'package:mobile_template/presentation/widgets/common/savings_backdrop.dart';

enum GlassSurfaceVariant { onGradient, onLight, panel }

/// Сплошная поверхность с минимальной стоимостью отрисовки.
///
/// Имя и варианты сохранены, чтобы существующие экраны не требовали миграции.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    required this.child,
    this.variant = GlassSurfaceVariant.onLight,
    this.borderRadius = AppDimensions.borderRadius,
    this.padding,
    this.margin,
    this.showBorder = true,
    super.key,
  });

  final Widget child;
  final GlassSurfaceVariant variant;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final color = switch (variant) {
      GlassSurfaceVariant.onGradient => AppColors.primaryDark,
      GlassSurfaceVariant.onLight => Theme.of(context).colorScheme.surface,
      GlassSurfaceVariant.panel => Theme.of(context).scaffoldBackgroundColor,
    };
    final content = padding == null
        ? child
        : Padding(padding: padding!, child: child);

    Widget surface = DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: showBorder
            ? Border.all(
                color: variant == GlassSurfaceVariant.onGradient
                    ? AppColors.primaryDark
                    : AppGlass.border(context),
                width: AppGlass.borderWidth,
              )
            : null,
      ),
      child: variant == GlassSurfaceVariant.panel
          ? ClipRRect(
              borderRadius: borderRadius,
              child: SavingsBackdrop(child: content),
            )
          : content,
    );

    if (margin != null) {
      surface = Padding(padding: margin!, child: surface);
    }

    return surface;
  }
}
