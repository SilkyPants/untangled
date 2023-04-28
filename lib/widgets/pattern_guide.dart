import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:untangled/entities/bracelet_pattern.dart';

import '../entities/knot.dart';
import '../entities/knot_type.dart';
import '../entities/thread_path.dart';
import '../painters/grid_painter.dart';

import 'pattern_knot.dart';
import 'pattern_thread_stack.dart';

class PatternGuide extends StatefulWidget {
  const PatternGuide({
    super.key,
    required this.pattern,
    this.margin = 20,
    this.spacing = 50,
    this.knotRadius = 20,
  });

  final BraceletPattern pattern;
  final double margin;
  final double spacing;
  final double knotRadius;

  @override
  State<PatternGuide> createState() => _PatternState();
}

class _PatternState extends State<PatternGuide> {
  @override
  Widget build(BuildContext context) {
    final width =
        widget.margin * 2 + widget.spacing * widget.pattern.threadColors.length;
    final height = widget.margin * 2 +
        widget.spacing * (widget.pattern.threadColors.length + 1);
    final size = Size(width, height);

    // This would be a good candidate for a BLoC state calculation
    final threadPaths = calculateThreads();
    final knots = calculateKnots();

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(
            color: Colors.amber,
          ),
          CustomPaint(
            painter: GridPainter(
              margin: widget.margin,
              rowSpacing: widget.spacing,
              color: Colors.grey.shade600.withAlpha(96),
              rowCount: widget.pattern.threadColors.length,
            ),
            size: size,
          ),
          PatternThreadStack(
            threadPaths: threadPaths,
            size: size,
          ),
          ...knots.map(
            (knot) => PatternKnot(knot: knot),
          ),
        ],
      ),
    );
  }

  List<Knot> calculateKnots() {
    var knots = <Knot>[];

    final threads = [...widget.pattern.threadColors];
    for (int i = 0; i < widget.pattern.knots.length; i++) {
      final y = i * widget.spacing + widget.margin + widget.spacing;
      final isEvenRow = (i + 1) % 2 == 0;
      final threadStart = isEvenRow ? 1 : 0;

      widget.pattern.knots[i].forEachIndexed((idx, knotType) {
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

        final x = widget.spacing * (leftThreadIdx + 1.5);

        knots.add(
          Knot(
            color: knotColor,
            type: knotType,
            position: Offset(x, y),
          ),
        );
      });
    }

    return knots;
  }

  List<ThreadPath> calculateThreads() {
    final threadPaths =
        widget.pattern.threadColors.map((e) => ThreadPath(e)).toList();
    for (int j = 0; j < threadPaths.length; j++) {
      final thread = threadPaths[j];
      var threadX = widget.spacing + widget.spacing * j;
      thread.path.reset();
      thread.path.moveTo(threadX, widget.margin);

      // Make point above knot points
      thread.path.lineTo(threadX, widget.margin + widget.spacing * .5);
    }

    for (int i = 0; i < widget.pattern.knots.length; i++) {
      final isEvenRow = (i + 1) % 2 == 0;
      final threadStart = isEvenRow ? 1 : 0;

      if (isEvenRow) {
        threadPaths.first.path.lineTo(
          widget.spacing,
          i * widget.spacing + widget.margin + widget.spacing,
        );

        threadPaths.last.path.lineTo(
          widget.spacing * widget.pattern.threadColors.length,
          i * widget.spacing + widget.margin + widget.spacing,
        );
      }

      final knotRow = widget.pattern.knots[i];
      final y = i * widget.spacing + widget.margin + widget.spacing;

      knotRow.forEachIndexed((idx, knotType) {
        final leftThreadIdx = threadStart + (idx * 2);
        final rightThreadIdx = leftThreadIdx + 1;

        final leftThread = threadPaths[leftThreadIdx];
        final rightThread = threadPaths[rightThreadIdx];

        drawThread(leftThreadIdx, leftThread, isEvenRow, y);
        drawThread(rightThreadIdx, rightThread, isEvenRow, y);

        switch (knotType) {
          case KnotType.forward:
          case KnotType.backward:
            threadPaths.swap(leftThreadIdx, rightThreadIdx);
            break;

          default:
            break;
        }
      });
    }

    for (int j = 0; j < widget.pattern.threadColors.length; j++) {
      final thread = threadPaths[j];
      var threadX = widget.spacing + widget.spacing * j;

      thread.path.lineTo(
          threadX,
          widget.pattern.knots.length * widget.spacing +
              widget.margin +
              widget.spacing * .5);

      thread.path.lineTo(
          threadX,
          widget.pattern.knots.length * widget.spacing +
              widget.margin +
              widget.spacing);
    }

    return threadPaths;
  }

  void drawThread(
    final int index,
    ThreadPath thread,
    bool isEvenRow,
    double y,
  ) {
    var threadX = widget.spacing + widget.spacing * index;
    final isEven = index % 2 == 0;
    final double xOffset;

    if (isEvenRow) {
      xOffset = !isEven ? widget.spacing * .5 : widget.spacing * -0.5;
    } else {
      xOffset = isEven ? widget.spacing * .5 : widget.spacing * -0.5;
    }

    thread.path.lineTo(threadX + xOffset, y);
  }
}
