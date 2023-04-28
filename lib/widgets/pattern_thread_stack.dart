import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../entities/thread_path.dart';

import 'pattern_thread.dart';

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
