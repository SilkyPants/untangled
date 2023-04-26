import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'knot_type.dart';

import 'painters/grid_painter.dart';
import 'painters/knot_painter.dart';
import 'painters/path_painter.dart';
import 'thread_path.dart';

class Pattern extends StatefulWidget {
  const Pattern({
    super.key,
    required this.threads,
    required this.knots,
    this.margin = 20,
    this.spacing = 50,
  });

  final List<Color> threads;
  final List<List<KnotType>> knots;
  final double margin;
  final double spacing;

  @override
  State<Pattern> createState() => _PatternState();
}

class _PatternState extends State<Pattern> {
  // which thread we have clicked on
  var selectedThread = -1;

  @override
  Widget build(BuildContext context) {
    final width = widget.margin * 2 + widget.spacing * widget.threads.length;
    final height =
        widget.margin * 2 + widget.spacing * (widget.threads.length + 1);
    final size = Size(width, height);

    // This would be a good candidate for a BLoC state calculation
    final threadPaths = calculateThreads();

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
          ...threadPaths.mapIndexed(
            (index, element) => PatternThread(
              size: size,
              thread: element,
              selected: index == selectedThread,
              onTap: () {
                selectedThread = index;
              },
            ),
          ),
          CustomPaint(
            painter: KnotPainter(
              margin: widget.margin,
              rowSpacing: widget.spacing,
              threadColors: widget.threads,
              knotRows: widget.knots,
            ),
            size: size,
          ),
        ],
      ),
    );
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

class PatternThread extends StatelessWidget {
  const PatternThread({
    super.key,
    required this.size,
    required this.thread,
    this.selected = false,
    this.onTap,
  });

  final Size size;
  final ThreadPath thread;
  final bool selected;
  final void Function()? onTap;

  static final log = Logger('Pattern');

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PathPainter(
        thread: thread,
        alpha: selected ? 255 : 96,
      ),
      size: size,
      child: GestureDetector(
        onTapUp: (details) {
          var b = thread.path.contains(details.localPosition);
          log.finest(b);
        },
      ),
    );
  }
}
