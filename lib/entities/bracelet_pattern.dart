import 'package:flutter/material.dart';
import 'package:untangled/entities/knot_type.dart';

class BraceletPattern {
  final List<Color> threadColors;
  final List<List<KnotType>> knots;

  BraceletPattern({
    required this.threadColors,
    required this.knots,
  });
}
