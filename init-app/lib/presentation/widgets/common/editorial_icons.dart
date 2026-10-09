import 'dart:math' as math;

import 'package:flutter/material.dart';

enum EditorialNavIconKind { overview, history, impulses, profile }

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
