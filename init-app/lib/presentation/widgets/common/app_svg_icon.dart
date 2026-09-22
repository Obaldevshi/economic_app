import 'package:mobile_template/generated/assets.gen.dart';
import 'package:flutter/material.dart';

/// Typed SVG icon wrapper over [SvgGenImage] from flutter_gen.
class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon({required this.icon, this.size = 24, this.color, super.key});

  final SvgGenImage icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return icon.svg(
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? IconTheme.of(context).color ?? Colors.white,
        BlendMode.srcIn,
      ),
    );
  }
}
