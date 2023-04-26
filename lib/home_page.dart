import 'package:flutter/material.dart';

import 'knot_type.dart';
import 'pattern.dart';

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
