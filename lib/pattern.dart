import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'knot_type.dart';
import 'painters/grid_painter.dart';
import 'pattern_knot.dart';
import 'pattern_thread.dart';
import 'thread_path.dart';

class Pattern extends StatefulWidget {
  const Pattern({
    super.key,
    required this.threads,
    required this.knots,
    this.margin = 20,
    this.spacing = 50,
    this.knotRadius = 20,
  });

  final List<Color> threads;
  final List<List<KnotType>> knots;
  final double margin;
  final double spacing;
  final double knotRadius;

  @override
  State<Pattern> createState() => _PatternState();
}

class _PatternState extends State<Pattern> {
  @override
  Widget build(BuildContext context) {
    final width = widget.margin * 2 + widget.spacing * widget.threads.length;
    final height =
        widget.margin * 2 + widget.spacing * (widget.threads.length + 1);
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
              rowCount: widget.threads.length,
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

    final threads = [...widget.threads];
    for (int i = 0; i < widget.knots.length; i++) {
      final y = i * widget.spacing + widget.margin + widget.spacing;
      final isEvenRow = (i + 1) % 2 == 0;
      final threadStart = isEvenRow ? 1 : 0;

      widget.knots[i].forEachIndexed((idx, knotType) {
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
    final threadPaths = widget.threads.map((e) => ThreadPath(e)).toList();
    for (int j = 0; j < threadPaths.length; j++) {
      final thread = threadPaths[j];
      var threadX = widget.spacing + widget.spacing * j;
      thread.path.reset();
      thread.path.moveTo(threadX, widget.margin);

      // Make point above knot points
      thread.path.lineTo(threadX, widget.margin + widget.spacing * .5);
    }

    for (int i = 0; i < widget.knots.length; i++) {
      final isEvenRow = (i + 1) % 2 == 0;
      final threadStart = isEvenRow ? 1 : 0;

      if (isEvenRow) {
        threadPaths.first.path.lineTo(
          widget.spacing,
          i * widget.spacing + widget.margin + widget.spacing,
        );

        threadPaths.last.path.lineTo(
          widget.spacing * widget.threads.length,
          i * widget.spacing + widget.margin + widget.spacing,
        );
      }

      final knotRow = widget.knots[i];
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

    for (int j = 0; j < widget.threads.length; j++) {
      final thread = threadPaths[j];
      var threadX = widget.spacing + widget.spacing * j;

      thread.path.lineTo(
          threadX,
          widget.knots.length * widget.spacing +
              widget.margin +
              widget.spacing * .5);

      thread.path.lineTo(
          threadX,
          widget.knots.length * widget.spacing +
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

class PatternThreadStack extends StatefulWidget {
  const PatternThreadStack({
    super.key,
    required this.threadPaths,
    required this.size,
  });

  final List<ThreadPath> threadPaths;
  final Size size;

  @override
  State<PatternThreadStack> createState() => _PatternThreadStackState();
}

class _PatternThreadStackState extends State<PatternThreadStack> {
  int selectedThread = -1;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MouseRegion(
        opaque: false,
        onHover: (event) {
          var hitIndex = -1;
          widget.threadPaths.forEachIndexedWhile((index, threadPath) {
            if (threadPath.path.contains(event.localPosition)) {
              hitIndex = index;
              return false;
            }
            return true;
          });

          setState(() {
            selectedThread = hitIndex;
          });
        },
        child: Stack(
          children: widget.threadPaths
              .mapIndexed(
                (index, thread) => PatternThread(
                  size: widget.size,
                  thread: thread,
                  selected: index == selectedThread,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
