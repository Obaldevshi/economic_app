import 'package:flutter/material.dart';
import 'package:mobile_template/app/theme/app_colors.dart';

/// An original saved-coin mark. Flutter, SVG and launcher icons share geometry.
class BrandMark extends StatelessWidget {
  const BrandMark({this.size = 36, this.onDark = false, super.key});

  final double size;
  final bool onDark;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: onDark ? Colors.transparent : AppColors.primaryDark,
        borderRadius: BorderRadius.circular(size * 0.19),
      ),
      child: CustomPaint(
        painter: _BrandMarkPainter(
          lineColor: AppColors.surface,
          coinColor: AppColors.accent,
        ),
      ),
    ),
  );
}

class _BrandMarkPainter extends CustomPainter {
  const _BrandMarkPainter({required this.lineColor, required this.coinColor});

  final Color lineColor;
  final Color coinColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 32, size.height / 32);
    canvas.drawCircle(const Offset(18, 10), 4.5, Paint()..color = coinColor);
    final pocket = Paint()
      ..color = lineColor
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
      Path()
        ..moveTo(7, 14)
        ..lineTo(7, 19)
        ..cubicTo(7, 23, 11, 26, 16, 26)
        ..cubicTo(21, 26, 25, 23, 25, 19)
        ..lineTo(25, 14),
      pocket,
    );
    canvas.drawPath(
      Path()
        ..moveTo(7, 14)
        ..lineTo(16, 20)
        ..lineTo(25, 14),
      pocket,
    );
  }

  @override
  bool shouldRepaint(_BrandMarkPainter oldDelegate) =>
      oldDelegate.lineColor != lineColor || oldDelegate.coinColor != coinColor;
}
