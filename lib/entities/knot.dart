import 'dart:ui';

import 'knot_type.dart';

class Knot {
  final Color color;
  final KnotType type;
  final Offset position;

  Knot({
    required this.color,
    required this.type,
    required this.position,
  });
}
