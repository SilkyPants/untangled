import 'package:flutter/material.dart';

import '../entities/thread_path.dart';

class ThreadPathPainter extends CustomPainter {
  final ThreadPath thread;
  final int alpha;

  ThreadPathPainter({
    required this.thread,
    this.alpha = 255,
  });

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
