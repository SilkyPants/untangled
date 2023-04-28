import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../entities/thread_path.dart';
import '../painters/thread_path_painter.dart';

class PatternThread extends StatelessWidget {
  const PatternThread({
    super.key,
    required this.size,
    required this.thread,
    this.selected = false,
  });

  final Size size;
  final ThreadPath thread;
  final bool selected;

  static final log = Logger('Pattern');

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: CustomPaint(
        painter: ThreadPathPainter(
          thread: thread,
          alpha: selected ? 255 : 96,
        ),
      ),
    );
  }
}
