import 'package:flutter/material.dart';

import '../entities/thread_path.dart';
import '../painters/thread_path_painter.dart';

class PatternThread extends StatelessWidget {
  const PatternThread({
    super.key,
    required this.thread,
    required this.width,
    required this.strokeWidth,
    this.alpha = 255,
  });

  final ThreadPath thread;
  final double alpha;
  final double width;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ThreadPathPainter(
        threadPath: thread.path,
        threadColor: thread.color,
        width: width,
        strokeWidth: strokeWidth,
        alpha: alpha.toInt(),
      ),
    );
  }
}
