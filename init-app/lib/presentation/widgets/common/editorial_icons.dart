import 'dart:math' as math;

import 'package:flutter/material.dart';

enum EditorialNavIconKind {
  overview,
  history,
  impulses,
  spent,
  forecast,
  profile,
}

/// A small, consistent line-icon family drawn for this product.
class EditorialNavIcon extends StatelessWidget {
  const EditorialNavIcon({
    required this.kind,
    required this.color,
    this.size = 22,
    super.key,
  });

  final EditorialNavIconKind kind;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(
      painter: _EditorialIconPainter(kind: kind, color: color),
    ),
  );
}

class ImpulseGlyph extends StatelessWidget {
  const ImpulseGlyph({
    required this.keyName,
    required this.color,
    this.size = 24,
    super.key,
  });

  final String keyName;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(
      painter: _ImpulseGlyphPainter(keyName: keyName, color: color),
    ),
  );
}

class _EditorialIconPainter extends CustomPainter {
  const _EditorialIconPainter({required this.kind, required this.color});

  final EditorialNavIconKind kind;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24, size.height / 24);
    final stroke = _stroke(color);
    switch (kind) {
      case EditorialNavIconKind.overview:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(3.5, 4.5, 17, 15),
            const Radius.circular(2),
          ),
          stroke,
        );
        canvas.drawLine(const Offset(7, 9), const Offset(17, 9), stroke);
        canvas.drawCircle(const Offset(8, 15), 1.2, Paint()..color = color);
        canvas.drawLine(const Offset(12, 15), const Offset(17, 15), stroke);
        break;
      case EditorialNavIconKind.history:
        canvas.drawLine(const Offset(5, 3.5), const Offset(5, 20.5), stroke);
        canvas.drawLine(const Offset(9, 6), const Offset(19, 6), stroke);
        canvas.drawLine(const Offset(9, 12), const Offset(19, 12), stroke);
        canvas.drawLine(const Offset(9, 18), const Offset(16, 18), stroke);
        break;
      case EditorialNavIconKind.impulses:
        canvas.drawCircle(const Offset(12, 12), 8, stroke);
        canvas.drawLine(
          const Offset(6.5, 17.5),
          const Offset(17.5, 6.5),
          stroke,
        );
        break;
      case EditorialNavIconKind.profile:
        canvas.drawCircle(const Offset(12, 8), 3.2, stroke);
        final shoulders = Path()
          ..moveTo(5, 20)
          ..quadraticBezierTo(5.5, 14, 12, 14)
          ..quadraticBezierTo(18.5, 14, 19, 20);
        canvas.drawPath(shoulders, stroke);
        break;
      case EditorialNavIconKind.spent:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(4, 8, 16, 13),
            const Radius.circular(2),
          ),
          stroke,
        );
        canvas.drawArc(
          const Rect.fromLTWH(8, 3, 8, 10),
          math.pi,
          math.pi,
          false,
          stroke,
        );
        canvas.drawLine(const Offset(9, 15), const Offset(15, 15), stroke);
        break;
      case EditorialNavIconKind.forecast:
        canvas.drawPath(
          Path()
            ..moveTo(4, 4)
            ..lineTo(4, 20)
            ..lineTo(21, 20),
          stroke,
        );
        canvas.drawPath(
          Path()
            ..moveTo(7, 16)
            ..lineTo(12, 11)
            ..lineTo(15, 13)
            ..lineTo(21, 5)
            ..moveTo(16, 5)
            ..lineTo(21, 5)
            ..lineTo(21, 10),
          stroke,
        );
        break;
    }
  }

  @override
  bool shouldRepaint(_EditorialIconPainter oldDelegate) =>
      oldDelegate.kind != kind || oldDelegate.color != color;
}

class _ImpulseGlyphPainter extends CustomPainter {
  const _ImpulseGlyphPainter({required this.keyName, required this.color});

  final String keyName;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24, size.height / 24);
    final stroke = _stroke(color);
    switch (keyName) {
      case 'coffee':
        canvas.drawPath(
          Path()
            ..moveTo(4, 8)
            ..lineTo(16, 8)
            ..lineTo(15, 17)
            ..quadraticBezierTo(10, 20, 5, 17)
            ..close(),
          stroke,
        );
        canvas.drawPath(
          Path()
            ..moveTo(16, 10)
            ..quadraticBezierTo(22, 9, 20, 14)
            ..quadraticBezierTo(19, 16, 16, 16),
          stroke,
        );
        canvas.drawLine(const Offset(4, 21), const Offset(18, 21), stroke);
        break;
      case 'restaurant':
        canvas.drawCircle(const Offset(14, 12), 6.5, stroke);
        canvas.drawLine(const Offset(5, 4), const Offset(5, 20), stroke);
        canvas.drawLine(const Offset(2.5, 4), const Offset(2.5, 9), stroke);
        canvas.drawLine(const Offset(7.5, 4), const Offset(7.5, 9), stroke);
        canvas.drawLine(const Offset(2.5, 9), const Offset(7.5, 9), stroke);
        break;
      case 'delivery':
        canvas.drawRect(const Rect.fromLTWH(4, 7, 16, 13), stroke);
        canvas.drawLine(const Offset(4, 11), const Offset(20, 11), stroke);
        canvas.drawLine(const Offset(12, 7), const Offset(12, 15), stroke);
        break;
      case 'smoking':
        canvas.drawRect(const Rect.fromLTWH(3, 14, 18, 4), stroke);
        canvas.drawLine(const Offset(17, 14), const Offset(17, 18), stroke);
        canvas.drawPath(
          Path()
            ..moveTo(8, 11)
            ..quadraticBezierTo(6, 9, 8, 7)
            ..quadraticBezierTo(10, 5, 8, 3),
          stroke,
        );
        break;
      case 'taxi':
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(3, 11, 18, 7),
            const Radius.circular(1.5),
          ),
          stroke,
        );
        canvas.drawPath(
          Path()
            ..moveTo(6, 11)
            ..lineTo(8, 6.5)
            ..lineTo(16, 6.5)
            ..lineTo(18, 11),
          stroke,
        );
        canvas.drawCircle(const Offset(7, 19), 1.2, stroke);
        canvas.drawCircle(const Offset(17, 19), 1.2, stroke);
        break;
      case 'shopping':
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(5, 9, 14, 12),
            const Radius.circular(1.5),
          ),
          stroke,
        );
        canvas.drawPath(
          Path()
            ..moveTo(9, 10)
            ..lineTo(9, 7)
            ..quadraticBezierTo(12, 2, 15, 7)
            ..lineTo(15, 10),
          stroke,
        );
        break;
      case 'subscription':
        canvas.drawArc(
          const Rect.fromLTWH(4, 4, 16, 16),
          -math.pi * 0.7,
          math.pi * 1.55,
          false,
          stroke,
        );
        canvas.drawLine(
          const Offset(18.2, 16.8),
          const Offset(20.5, 17),
          stroke,
        );
        canvas.drawLine(const Offset(20.5, 17), const Offset(20, 14.5), stroke);
        canvas.drawCircle(const Offset(12, 12), 2.2, stroke);
        break;
      case 'alcohol':
        canvas.drawPath(
          Path()
            ..moveTo(8, 3)
            ..lineTo(16, 3)
            ..lineTo(16, 9)
            ..quadraticBezierTo(16, 13, 12, 13)
            ..quadraticBezierTo(8, 13, 8, 9)
            ..close(),
          stroke,
        );
        canvas.drawLine(const Offset(12, 13), const Offset(12, 21), stroke);
        canvas.drawLine(const Offset(8, 21), const Offset(16, 21), stroke);
        canvas.drawLine(const Offset(8, 8), const Offset(16, 8), stroke);
        break;
      case 'snacks':
        canvas.drawPath(
          Path()
            ..moveTo(6, 3)
            ..lineTo(18, 3)
            ..lineTo(17, 8)
            ..lineTo(19, 20)
            ..lineTo(5, 20)
            ..lineTo(7, 8)
            ..close(),
          stroke,
        );
        canvas.drawLine(const Offset(7, 6), const Offset(17, 6), stroke);
        canvas.drawOval(const Rect.fromLTWH(9, 10, 6, 7), stroke);
        break;
      case 'bakery':
        canvas.drawPath(
          Path()
            ..moveTo(3, 14)
            ..quadraticBezierTo(4, 6, 9, 8)
            ..quadraticBezierTo(12, 3, 15, 8)
            ..quadraticBezierTo(20, 6, 21, 14)
            ..lineTo(18, 19)
            ..lineTo(6, 19)
            ..close(),
          stroke,
        );
        canvas.drawLine(const Offset(9, 9), const Offset(10, 16), stroke);
        canvas.drawLine(const Offset(15, 9), const Offset(14, 16), stroke);
        break;
      case 'soda':
        canvas.drawPath(
          Path()
            ..moveTo(6, 8)
            ..lineTo(18, 8)
            ..lineTo(16, 21)
            ..lineTo(8, 21)
            ..close(),
          stroke,
        );
        canvas.drawLine(const Offset(5, 8), const Offset(19, 8), stroke);
        canvas.drawPath(
          Path()
            ..moveTo(12, 14)
            ..lineTo(14, 3)
            ..lineTo(20, 3),
          stroke,
        );
        break;
      case 'energy_drink':
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(6, 3, 12, 18),
            const Radius.circular(2),
          ),
          stroke,
        );
        canvas.drawPath(
          Path()
            ..moveTo(13, 7)
            ..lineTo(9, 13)
            ..lineTo(13, 13)
            ..lineTo(11, 18)
            ..lineTo(16, 11)
            ..lineTo(12, 11),
          stroke,
        );
        break;
      case 'fast_food':
        canvas.drawArc(
          const Rect.fromLTWH(4, 5, 16, 12),
          math.pi,
          math.pi,
          false,
          stroke,
        );
        canvas.drawLine(const Offset(3, 12), const Offset(21, 12), stroke);
        canvas.drawLine(const Offset(3, 16), const Offset(21, 16), stroke);
        canvas.drawPath(
          Path()
            ..moveTo(4, 18)
            ..quadraticBezierTo(12, 23, 20, 18),
          stroke,
        );
        break;
      case 'cinema':
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(3, 5, 18, 14),
            const Radius.circular(2),
          ),
          stroke,
        );
        canvas.drawLine(const Offset(3, 9), const Offset(21, 9), stroke);
        canvas.drawLine(const Offset(3, 15), const Offset(21, 15), stroke);
        for (final x in [7.0, 12.0, 17.0]) {
          canvas.drawLine(Offset(x, 5), Offset(x, 9), stroke);
          canvas.drawLine(Offset(x, 15), Offset(x, 19), stroke);
        }
        break;
      case 'games':
        canvas.drawPath(
          Path()
            ..moveTo(7, 7)
            ..lineTo(17, 7)
            ..quadraticBezierTo(21, 7, 22, 17)
            ..quadraticBezierTo(22, 21, 17, 16)
            ..lineTo(7, 16)
            ..quadraticBezierTo(2, 21, 2, 17)
            ..quadraticBezierTo(3, 7, 7, 7),
          stroke,
        );
        canvas.drawLine(const Offset(6, 11), const Offset(10, 11), stroke);
        canvas.drawLine(const Offset(8, 9), const Offset(8, 13), stroke);
        canvas.drawCircle(const Offset(16, 10), 0.8, Paint()..color = color);
        canvas.drawCircle(const Offset(18, 13), 0.8, Paint()..color = color);
        break;
      case 'clothes':
        canvas.drawPath(
          Path()
            ..moveTo(8, 4)
            ..quadraticBezierTo(12, 8, 16, 4)
            ..lineTo(22, 8)
            ..lineTo(19, 12)
            ..lineTo(17, 10)
            ..lineTo(17, 21)
            ..lineTo(7, 21)
            ..lineTo(7, 10)
            ..lineTo(5, 12)
            ..lineTo(2, 8)
            ..close(),
          stroke,
        );
        break;
      case 'cosmetics':
        canvas.drawRect(const Rect.fromLTWH(7, 12, 10, 9), stroke);
        canvas.drawPath(
          Path()
            ..moveTo(9, 12)
            ..lineTo(9, 6)
            ..lineTo(15, 3)
            ..lineTo(15, 12),
          stroke,
        );
        canvas.drawLine(const Offset(7, 16), const Offset(17, 16), stroke);
        break;
      case 'gadgets':
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(6, 2, 12, 20),
            const Radius.circular(2),
          ),
          stroke,
        );
        canvas.drawLine(const Offset(10, 5), const Offset(14, 5), stroke);
        canvas.drawCircle(const Offset(12, 18), 0.8, Paint()..color = color);
        break;
      case 'gifts':
        canvas.drawRect(const Rect.fromLTWH(4, 10, 16, 11), stroke);
        canvas.drawRect(const Rect.fromLTWH(3, 7, 18, 3), stroke);
        canvas.drawLine(const Offset(12, 7), const Offset(12, 21), stroke);
        canvas.drawPath(
          Path()
            ..moveTo(12, 7)
            ..cubicTo(1, 7, 7, -2, 12, 7)
            ..cubicTo(17, -2, 23, 7, 12, 7),
          stroke,
        );
        break;
      case 'hobbies':
        canvas.drawPath(
          Path()
            ..moveTo(4, 3)
            ..lineTo(19, 3)
            ..lineTo(19, 21)
            ..lineTo(4, 21)
            ..close(),
          stroke,
        );
        canvas.drawLine(const Offset(8, 3), const Offset(8, 21), stroke);
        canvas.drawLine(const Offset(11, 8), const Offset(16, 8), stroke);
        canvas.drawLine(const Offset(11, 12), const Offset(16, 12), stroke);
        break;
      default:
        canvas.drawPath(
          Path()
            ..moveTo(12, 3)
            ..lineTo(14.5, 9.5)
            ..lineTo(21, 12)
            ..lineTo(14.5, 14.5)
            ..lineTo(12, 21)
            ..lineTo(9.5, 14.5)
            ..lineTo(3, 12)
            ..lineTo(9.5, 9.5)
            ..close(),
          stroke,
        );
        break;
    }
  }

  @override
  bool shouldRepaint(_ImpulseGlyphPainter oldDelegate) =>
      oldDelegate.keyName != keyName || oldDelegate.color != color;
}

Paint _stroke(Color color) => Paint()
  ..color = color
  ..strokeWidth = 1.8
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round
  ..style = PaintingStyle.stroke;
