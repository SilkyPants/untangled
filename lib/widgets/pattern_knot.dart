import 'package:flutter/material.dart';

import '../entities/knot.dart';
import '../painters/knot_painter.dart';

class PatternKnot extends StatefulWidget {
  const PatternKnot({
    super.key,
    required this.knot,
    this.radius = 20,
    this.hoverRadius = 30,
  });

  final Knot knot;
  final double radius;
  final double hoverRadius;

  @override
  State<PatternKnot> createState() => _PatternKnotState();
}

class _PatternKnotState extends State<PatternKnot> {
  double radius = 0;

  @override
  void initState() {
    radius = widget.radius;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = Size.fromRadius(radius);
    return Positioned.fromRect(
      rect: Rect.fromCircle(
        center: widget.knot.position,
        radius: radius,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints.tight(size),
        child: MouseRegion(
          opaque: false,
          onEnter: (event) {
            setState(() {
              radius = widget.hoverRadius;
            });
          },
          onExit: (event) {
            setState(() {
              radius = widget.radius;
            });
          },
          child: CustomPaint(
            painter: KnotPainter(
              knot: widget.knot,
              radius: radius,
            ),
          ),
        ),
      ),
    );
  }
}
