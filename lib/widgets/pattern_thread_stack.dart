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

class _PatternThreadStackState extends State<PatternThreadStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation alphaAnimation;
  late Animation sizeAnimation;

  late Animation selectedAlphaAnimation;
  late Animation selectedSizeAnimation;

  int selectedThread = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 50),
    );

    alphaAnimation =
        Tween<double>(begin: 255.0, end: 96.0).animate(_controller);
    sizeAnimation = Tween<double>(begin: 12.0, end: 8.0).animate(_controller);

    selectedAlphaAnimation =
        Tween<double>(begin: 96, end: 255).animate(_controller);
    selectedSizeAnimation =
        Tween<double>(begin: 8.0, end: 12.0).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: widget.size,
      child: GestureDetector(
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

              if (selectedThread >= 0) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            });
          },
          child: Stack(
            children: widget.threadPaths
                .mapIndexed(
                  (index, thread) => PatternThread(
                    thread: thread,
                    width: selectedThread == -1
                        ? 8
                        : index == selectedThread
                            ? selectedSizeAnimation.value
                            : sizeAnimation.value,
                    strokeWidth: 3,
                    alpha: selectedThread == -1
                        ? 255
                        : index == selectedThread
                            ? selectedAlphaAnimation.value
                            : alphaAnimation.value,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
