import 'package:flutter/material.dart';

class ThreadPathPainter extends CustomPainter {
  final Path threadPath;
  final Color threadColor;
  final int alpha;
  final double width;
  final double strokeWidth;

  ThreadPathPainter({
    required this.threadPath,
    required this.threadColor,
    required this.width,
    required this.strokeWidth,
    this.alpha = 255,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = threadColor.withAlpha(alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width - strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.miter;

    Paint strokePaint = Paint()
      ..color = Colors.white.withAlpha(alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(
      threadPath,
      strokePaint,
    );

    canvas.drawPath(
      threadPath,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
