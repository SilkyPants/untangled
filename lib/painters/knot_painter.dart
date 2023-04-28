import 'package:flutter/material.dart';

import '../entities/knot_type.dart';
import '../entities/knot.dart';

class KnotPainter extends CustomPainter {
  final Knot knot;
  final double radius;

  KnotPainter({
    required this.knot,
    this.radius = 20,
  });

  @override
  bool? hitTest(Offset position) {
    final halfRadius = radius / 2;
    return Rect.fromCircle(
      center: Offset(halfRadius, halfRadius),
      radius: radius,
    ).contains(position);
  }

  @override
  void paint(Canvas canvas, Size size) {
    const double padding = 13;
    final arrowLineLength = radius - padding;
    final arrowPaint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    var center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, Paint()..color = knot.color);

    if (knot.type.threePointArrow) {
      final offset = knot.type.isBackwards ? -arrowLineLength : arrowLineLength;
      center += Offset(offset / 2, 0);
    }

    final Offset arrowTip;
    final Offset arrowOffset;
    switch (knot.type) {
      case KnotType.forward:
      case KnotType.backwardForward:
        arrowOffset = Offset(arrowLineLength, arrowLineLength);
        arrowTip = center + arrowOffset;
        canvas.drawLine(
            arrowTip, arrowTip - Offset(0, arrowLineLength), arrowPaint);
        canvas.drawLine(
            arrowTip, arrowTip - Offset(arrowLineLength, 0), arrowPaint);
        break;

      case KnotType.backward:
      case KnotType.forwardBackward:
        arrowOffset = Offset(-arrowLineLength, arrowLineLength);
        arrowTip = center + arrowOffset;
        canvas.drawLine(
            arrowTip, arrowTip - Offset(0, arrowLineLength), arrowPaint);
        canvas.drawLine(
            arrowTip, arrowTip + Offset(arrowLineLength, 0), arrowPaint);
        break;

      case KnotType.open:
        arrowTip = center;
        arrowOffset = center;
        break;
    }

    var p1 = arrowTip;
    var p2 = center - arrowOffset;

    if (knot.type.threePointArrow) {
      canvas.drawLine(p1, center, arrowPaint);
      p1 = center;
      p2 = center - Offset(-arrowOffset.dx, arrowOffset.dy);
    }

    canvas.drawLine(p1, p2, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
