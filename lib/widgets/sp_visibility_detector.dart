import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SpVisibilityDetector extends StatefulWidget {
  const SpVisibilityDetector({
    Key? key,
    required this.detectorKey,
    required this.builder,
    required this.child,
  }) : super(key: key);

  final Key detectorKey;
  final Widget? child;
  final Widget Function(BuildContext context, bool visible, Widget? child) builder;

  @override
  State<SpVisibilityDetector> createState() => _SpVisibilityDetectorState();
}

class _SpVisibilityDetectorState extends State<SpVisibilityDetector> {
  late final ValueNotifier<double> visibleNotifier;

  @override
  void initState() {
    visibleNotifier = ValueNotifier<double>(0.0);
    super.initState();
  }

  @override
  void dispose() {
    visibleNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.detectorKey,
      onVisibilityChanged: (visibilityInfo) {
        visibleNotifier.value = visibilityInfo.visibleFraction;
      },
      child: ValueListenableBuilder<double>(
        valueListenable: visibleNotifier,
        child: widget.child,
        builder: (context, visible, child) {
          return widget.builder(
            context,
            visible > 0.5,
            child,
          );
        },
      ),
    );
  }
}
