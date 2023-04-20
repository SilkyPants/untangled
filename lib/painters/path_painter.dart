import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../knot_type.dart';
import '../thread_path.dart';

class PathPainter extends CustomPainter {
  final double margin;
  final double rowSpacing;

  final List<Color> threadColors;
  final List<List<KnotType>> knotRows;

  PathPainter({
    required this.margin,
    required this.rowSpacing,
    required this.threadColors,
    required this.knotRows,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final threads = threadColors.map((e) => ThreadPath(e)).toList();
    for (int j = 0; j < threads.length; j++) {
      final thread = threads[j];
      var threadX = rowSpacing + rowSpacing * j;
      thread.path.reset();
      thread.path.moveTo(threadX, margin);

      // Make point above knot points
      thread.path.lineTo(threadX, margin + rowSpacing * .5);
    }

    for (int i = 0; i < knotRows.length; i++) {
      final isEvenRow = (i + 1) % 2 == 0;
      final threadStart = isEvenRow ? 1 : 0;

      if (isEvenRow) {
        threads.first.path.lineTo(
          rowSpacing,
          i * rowSpacing + margin + rowSpacing,
        );

        threads.last.path.lineTo(
          rowSpacing * threadColors.length,
          i * rowSpacing + margin + rowSpacing,
        );
      }

      final knots = knotRows[i];
      final y = i * rowSpacing + margin + rowSpacing;

      knots.forEachIndexed((idx, knotType) {
        final leftThreadIdx = threadStart + (idx * 2);
        final rightThreadIdx = leftThreadIdx + 1;

        final leftThread = threads[leftThreadIdx];
        final rightThread = threads[rightThreadIdx];

        drawThread(leftThreadIdx, leftThread, isEvenRow, y);
        drawThread(rightThreadIdx, rightThread, isEvenRow, y);

        switch (knotType) {
          case KnotType.forward:
          case KnotType.backward:
            threads.swap(leftThreadIdx, rightThreadIdx);
            break;

          default:
            break;
        }
      });
    }

    for (int j = 0; j < threadColors.length; j++) {
      final thread = threads[j];
      var threadX = rowSpacing + rowSpacing * j;

      thread.path.lineTo(
          threadX, knotRows.length * rowSpacing + margin + rowSpacing * .5);

      thread.path
          .lineTo(threadX, knotRows.length * rowSpacing + margin + rowSpacing);

      canvas.drawPath(thread.path, thread.strokePaint);
      canvas.drawPath(thread.path, thread.paint);
    }
  }

  void drawThread(
      final int index, ThreadPath thread, bool isEvenRow, double y) {
    var threadX = rowSpacing + rowSpacing * index;
    final isEven = index % 2 == 0;
    final double xOffset;

    if (isEvenRow) {
      xOffset = !isEven ? rowSpacing * .5 : rowSpacing * -0.5;
    } else {
      xOffset = isEven ? rowSpacing * .5 : rowSpacing * -0.5;
    }

    thread.path.lineTo(threadX + xOffset, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
