import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final double margin;
  final double rowSpacing;
  final double fontSize;
  final int rowCount;
  final Color color;

  GridPainter({
    required this.margin,
    required this.rowSpacing,
    required this.color,
    required this.rowCount,
    this.fontSize = 16,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()..color = color;

    for (int i = 0; i < rowCount; i++) {
      final start = Offset(margin, i * rowSpacing + margin + rowSpacing);
      final end =
          Offset(size.width - (margin), i * rowSpacing + margin + rowSpacing);
      canvas.drawLine(
        start,
        end,
        linePaint,
      );

      final textPainter = TextPainter(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: '${i + 1}',
          style: TextStyle(
            textBaseline: TextBaseline.ideographic,
            color: color,
            fontSize: fontSize,
          ),
        ),
      );

      textPainter.layout();

      // NOTE: Not a fan of how this works - magic numbers and all
      // But **it is** aligned correctly sooo... :|
      textPainter.paint(canvas,
          start - Offset(textPainter.width + 3, textPainter.height * .5 + 2));
      textPainter.paint(
          canvas, end + Offset(4, -(textPainter.height * .5 + 2)));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }

  @override
  bool? hitTest(Offset position) {
    return false;
  }
}
