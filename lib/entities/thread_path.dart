import 'package:flutter/material.dart';

class ThreadPath {
  final Path path = Path();
  final Color color;
  final double strokeWidth;
  final double width;

  Paint get paint => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width - strokeWidth
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.miter;

  Paint get strokePaint => Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.miter;

  ThreadPath(
    this.color, {
    this.width = 8,
    this.strokeWidth = 4,
  });
}
