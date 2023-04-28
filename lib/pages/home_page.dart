import 'package:flutter/material.dart';
import 'package:untangled/entities/bracelet_pattern.dart';

import '../entities/knot_type.dart';
import '../widgets/pattern_guide.dart';

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
  final pattern = BraceletPattern(threadColors: [
    Colors.blue,
    Colors.red,
    Colors.pink,
    Colors.green,
  ], knots: [
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
  ]);

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
            PatternGuide(pattern: pattern),
            const Text('I am below'),
          ],
        ),
      ),
    );
  }
}
