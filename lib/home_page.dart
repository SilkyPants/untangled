import 'package:flutter/material.dart';
import 'package:untangled/painters/grid_painter.dart';

import 'knot_type.dart';

import 'painters/knot_painter.dart';
import 'painters/path_painter.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final threads = <Color>[
    Colors.blue,
    Colors.red,
    Colors.pink,
    Colors.green,
  ];

  final knots = [
    [
      KnotType.forward,
      KnotType.backward,
    ],
    [
      KnotType.backwardForward,
    ],
    [
      KnotType.forwardBackward,
      KnotType.backwardForward,
    ],
    [
      KnotType.forward,
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('I am above'),
            Pattern(threads: threads, knots: knots),
            const Text('I am below'),
          ],
        ),
      ),
    );
  }
}

class Pattern extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final width = margin * 2 + spacing * threads.length;
    final height = margin * 2 + spacing * (threads.length + 1);
    final size = Size(width, height);

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
              margin: margin,
              rowSpacing: spacing,
              color: Colors.grey.shade600.withAlpha(96),
              rowCount: threads.length,
            ),
            size: size,
          ),
          CustomPaint(
            painter: PathPainter(
              margin: margin,
              rowSpacing: spacing,
              threadColors: threads,
              knotRows: knots,
            ),
            size: size,
          ),
          CustomPaint(
            painter: KnotPainter(
              margin: margin,
              rowSpacing: spacing,
              threadColors: threads,
              knotRows: knots,
            ),
            size: size,
          ),
        ],
      ),
    );
  }
}
