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
    final radius = BorderRadius.circular(borderRadius);
    final content = Padding(padding: padding, child: child);
    return GlassSurface(
      variant: variant,
      borderRadius: radius,
      margin: margin,
      showBorder: showBorder,
      // Paint ListTile/ExpansionTile and card ink above the opaque surface.
      child: Material(
        type: MaterialType.transparency,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: onTap == null ? content : InkWell(onTap: onTap, child: content),
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
