import 'package:flutter/material.dart';

class ThreadPath {
  final Path path = Path();
  final Color color;
  final double strokeWidth;
  final double width;

  ThreadPath(
    this.color, {
    this.width = 8,
    this.strokeWidth = 4,
  });
}
