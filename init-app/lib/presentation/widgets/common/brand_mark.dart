import 'package:flutter/material.dart';
import 'package:mobile_template/features/savings/presentation/widgets/financial_display_scope.dart';
import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/services/app_languages.dart';
import 'package:mobile_template/core/services/locale_service.dart';

/// An original saved-coin mark. Flutter, SVG and launcher icons share geometry.
class BrandMark extends StatelessWidget {
  const BrandMark({this.size = 36, this.onDark = false, super.key});

  final double size;
  final bool onDark;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: getIt<LocaleService>(),
    builder: (context, _) => SizedBox.square(
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
            coinCode: getIt<LocaleService>().locale == null
                ? null
                : FinancialDisplayScope.maybeOf(context)?.currency ??
                      AppLanguage.find(getIt<LocaleService>().locale)?.coinCode,
          ),
        ),
      ),
    ),
  );
}

class _BrandMarkPainter extends CustomPainter {
  const _BrandMarkPainter({
    required this.lineColor,
    required this.coinColor,
    this.coinCode,
  });

  final Color lineColor;
  final Color coinColor;
  final String? coinCode;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 32, size.height / 32);
    canvas.drawCircle(const Offset(18, 10), 4.5, Paint()..color = coinColor);
    final coinDetail = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 0.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(const Offset(18, 10), 3.35, coinDetail);
    if (coinCode != null) _paintDenomination(canvas, coinDetail);
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

  // Original paths keep every currency mark independent of font assets.
  void _paintDenomination(Canvas canvas, Paint pen) {
    canvas.save();
    canvas.translate(18, 10);
    pen.strokeWidth = 0.55;
    Path ruble() => Path()
      ..moveTo(-.9, 2.05)
      ..lineTo(-.9, -2.05)
      ..lineTo(.35, -2.05)
      ..cubicTo(2, -2.05, 2, .25, .35, .25)
      ..lineTo(-1.4, .25)
      ..moveTo(-1.4, 1.2)
      ..lineTo(.45, 1.2);
    Path dollar() => Path()
      ..moveTo(1.25, -1.5)
      ..cubicTo(-1.9, -3, -2.2, -.1, 0, 0)
      ..cubicTo(2.3, .1, 1.8, 3, -1.25, 1.5)
      ..moveTo(0, -2.4)
      ..lineTo(0, 2.4);
    Path letterR() => Path()
      ..moveTo(-1, 2)
      ..lineTo(-1, -2)
      ..lineTo(.2, -2)
      ..cubicTo(2, -2, 2, 0, .2, 0)
      ..lineTo(-1, 0)
      ..moveTo(.2, 0)
      ..lineTo(1.4, 2);
    switch (coinCode) {
      case 'RUB':
        canvas.drawPath(ruble(), pen);
      case 'USD':
        canvas.drawPath(dollar(), pen);
      case 'EUR':
        canvas.drawPath(
          Path()
            ..moveTo(1.5, -1.6)
            ..cubicTo(-2, -3.2, -2, 3.2, 1.5, 1.6)
            ..moveTo(-1.8, -.55)
            ..lineTo(.9, -.55)
            ..moveTo(-1.8, .55)
            ..lineTo(.6, .55),
          pen,
        );
      case 'CNY':
        canvas.drawPath(
          Path()
            ..moveTo(-1.4, -2)
            ..lineTo(0, -.2)
            ..lineTo(1.4, -2)
            ..moveTo(0, -.2)
            ..lineTo(0, 2)
            ..moveTo(-1.3, .1)
            ..lineTo(1.3, .1)
            ..moveTo(-1.3, 1)
            ..lineTo(1.3, 1),
          pen,
        );
      case 'KZT':
        canvas.drawPath(
          Path()
            ..moveTo(-1.5, -2)
            ..lineTo(1.5, -2)
            ..moveTo(-1.5, -1.2)
            ..lineTo(1.5, -1.2)
            ..moveTo(0, -1.2)
            ..lineTo(0, 2),
          pen,
        );
      case 'INR':
        canvas.drawPath(
          Path()
            ..moveTo(-1.4, -2)
            ..lineTo(1.4, -2)
            ..moveTo(-1.4, -1.1)
            ..lineTo(1.4, -1.1)
            ..moveTo(-.4, -2)
            ..cubicTo(1.8, -2, 1.8, .2, -1.2, .2)
            ..lineTo(1.3, 2),
          pen,
        );
      case 'BRL':
        canvas.scale(.65);
        canvas.translate(-1.9, 0);
        canvas.drawPath(letterR(), pen);
        canvas.translate(3.6, 0);
        canvas.drawPath(dollar(), pen);
      case 'SAR':
        // A regional riyal reference, drawn as its code rather than a font glyph.
        canvas.scale(.45);
        canvas.translate(-3.8, 0);
        canvas.drawPath(
          Path()
            ..moveTo(1.2, -1.7)
            ..cubicTo(-2, -3, -2, -.2, 0, 0)
            ..cubicTo(2, .2, 2, 3, -1.2, 1.7),
          pen..strokeWidth = .8,
        );
        canvas.translate(3.8, 0);
        canvas.drawPath(
          Path()
            ..moveTo(-1.5, 2)
            ..lineTo(0, -2)
            ..lineTo(1.5, 2)
            ..moveTo(-.9, .5)
            ..lineTo(.9, .5),
          pen,
        );
        canvas.translate(3.8, 0);
        canvas.drawPath(letterR(), pen);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BrandMarkPainter oldDelegate) =>
      oldDelegate.lineColor != lineColor ||
      oldDelegate.coinColor != coinColor ||
      oldDelegate.coinCode != coinCode;
}
