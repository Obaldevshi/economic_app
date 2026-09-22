import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface.dart';
import 'package:flutter/material.dart';

export 'glass_surface.dart' show GlassSurfaceVariant;

class GlassSurfaceCard extends StatelessWidget {
  const GlassSurfaceCard({
    required this.child,
    this.padding = AppDimensions.paddingAllM,
    this.margin,
    this.borderRadius = AppDimensions.radius,
    this.variant = GlassSurfaceVariant.onLight,
    this.onTap,
    this.showBorder = true,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final GlassSurfaceVariant variant;
  final VoidCallback? onTap;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final card = GlassSurface(
      variant: variant,
      borderRadius: BorderRadius.circular(borderRadius),
      margin: margin,
      padding: padding,
      showBorder: showBorder,
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      ),
    );
  }
}

class GlassIconBadge extends StatelessWidget {
  const GlassIconBadge({
    required this.child,
    this.size = 44,
    this.color,
    super.key,
  });

  final Widget child;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;
    final radius = BorderRadius.circular(AppDimensions.radius);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: radius,
        color: accent.withValues(alpha: 0.12),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Center(child: child),
    );
  }
}
