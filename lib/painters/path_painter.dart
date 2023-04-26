import 'package:flutter/material.dart';

import '../thread_path.dart';

class PathPainter extends CustomPainter {
  final ThreadPath thread;
  final int alpha;

  PathPainter({
    required this.thread,
    this.alpha = 255,
  });

  @override
  bool? hitTest(Offset position) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      thread.path,
      thread.strokePaint..color = Colors.white.withAlpha(alpha),
    );
    canvas.drawPath(
      thread.path,
      thread.paint..color = thread.color.withAlpha(alpha),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
