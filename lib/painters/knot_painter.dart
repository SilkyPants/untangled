import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../knot_type.dart';

class KnotPainter extends CustomPainter {
  final double margin;
  final double rowSpacing;

  final List<Color> threadColors;
  final List<List<KnotType>> knotRows;

  KnotPainter({
    required this.margin,
    required this.rowSpacing,
    required this.threadColors,
    required this.knotRows,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final threads = [...threadColors];

    for (int i = 0; i < knotRows.length; i++) {
      final y = i * rowSpacing + margin + rowSpacing;
      final isEvenRow = (i + 1) % 2 == 0;
      final threadStart = isEvenRow ? 1 : 0;

      knotRows[i].forEachIndexed((idx, knotType) {
        final leftThreadIdx = threadStart + (idx * 2);
        final rightThreadIdx = leftThreadIdx + 1;

        final leftThread = threads[leftThreadIdx];
        final rightThread = threads[rightThreadIdx];

        final Color knotColor;
        switch (knotType) {
          case KnotType.forward:
          case KnotType.forwardBackward:
            knotColor = leftThread;
            break;

          case KnotType.backward:
          case KnotType.backwardForward:
            knotColor = rightThread;
            break;

          case KnotType.open:
            knotColor = Colors.transparent;
            break;
        }

        switch (knotType) {
          case KnotType.forward:
          case KnotType.backward:
            threads.swap(leftThreadIdx, rightThreadIdx);
            break;

          default:
            break;
        }

        drawKnot(leftThreadIdx, knotType, knotColor, y, canvas);
      });
    }
  }

  void drawKnot(
      final int index, KnotType type, Color color, double y, Canvas canvas) {
    var threadX = rowSpacing + rowSpacing * index;
    final double xOffset = rowSpacing / 2;
    const double radius = 20;
    const double padding = 13;
    const arrowLineLength = radius - padding;
    final arrowPaint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    var center = Offset(threadX + xOffset, y);

    canvas.drawCircle(center, radius, Paint()..color = color);

    if (type.threePointArrow) {
      final offset = type.isBackwards ? -arrowLineLength : arrowLineLength;
      center = Offset(threadX + xOffset + offset / 2, y);
    }

    final Offset arrowTip;
    final Offset arrowOffset;
    switch (type) {
      case KnotType.forward:
      case KnotType.backwardForward:
        arrowOffset = const Offset(arrowLineLength, arrowLineLength);
        arrowTip = center + arrowOffset;
        canvas.drawLine(
            arrowTip, arrowTip - const Offset(0, arrowLineLength), arrowPaint);
        canvas.drawLine(
            arrowTip, arrowTip - const Offset(arrowLineLength, 0), arrowPaint);
        break;

      case KnotType.backward:
      case KnotType.forwardBackward:
        arrowOffset = const Offset(-arrowLineLength, arrowLineLength);
        arrowTip = center + arrowOffset;
        canvas.drawLine(
            arrowTip, arrowTip - const Offset(0, arrowLineLength), arrowPaint);
        canvas.drawLine(
            arrowTip, arrowTip + const Offset(arrowLineLength, 0), arrowPaint);
        break;

      case KnotType.open:
        arrowTip = center;
        arrowOffset = center;
        break;
    }

    var p1 = arrowTip;
    var p2 = center - arrowOffset;

    if (type.threePointArrow) {
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
