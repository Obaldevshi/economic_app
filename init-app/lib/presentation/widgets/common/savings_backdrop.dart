import 'package:flutter/material.dart';
import 'package:mobile_template/app/theme/app_colors.dart';

/// Original line drawing: small coins accumulate in a pocket. No raster assets,
/// motion, external fonts or image requests; the content stays on opaque cards.
class SavingsBackdrop extends StatelessWidget {
  const SavingsBackdrop({required this.child, this.onDark = false, super.key});
  final Widget child;
  final bool onDark;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _SavingsBackdropPainter(
      ink:
          (onDark ? AppColors.surface : Theme.of(context).colorScheme.onSurface)
              .withValues(alpha: onDark ? 0.065 : 0.045),
    ),
    child: child,
  );
}

class _SavingsBackdropPainter extends CustomPainter {
  const _SavingsBackdropPainter({required this.ink});
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    final line = Paint()
      ..color = ink
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.save();
    canvas.translate(size.width - 120, 82);
    canvas.rotate(-0.15);
    for (var i = 0; i < 3; i++) {
      final center = Offset(22.0 + i * 30, -22.0 - i * 23);
      canvas.drawCircle(center, 19, line);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: 13),
        -1.1,
        2.6,
        false,
        line,
      );
    }
    canvas.drawPath(
      Path()
        ..moveTo(-40, 20)
        ..lineTo(-40, 80)
        ..cubicTo(-40, 118, -10, 142, 28, 142)
        ..cubicTo(66, 142, 96, 118, 96, 80)
        ..lineTo(96, 20),
      line,
    );
    canvas.drawPath(
      Path()
        ..moveTo(-40, 20)
        ..lineTo(28, 66)
        ..lineTo(96, 20),
      line,
    );
    canvas.restore();
    // A second quiet mark in the margin, rather than a repeated wallpaper.
    canvas.translate(26, size.height > 700 ? 560 : size.height * .72);
    for (var stack = 0; stack < 3; stack++) {
      for (var coin = 0; coin <= stack; coin++) {
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(stack * 37.0, -coin * 9.0),
            width: 27,
            height: 11,
          ),
          line,
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SavingsBackdropPainter oldDelegate) =>
      ink != oldDelegate.ink;
}
