import 'package:flutter/material.dart';

class SpCrossFade extends StatelessWidget {
  const SpCrossFade({
    super.key,
    required this.firstChild,
    required this.secondChild,
    required this.showFirst,
    this.alignment = Alignment.topCenter,
    this.duration = Durations.medium1,
  });

  final Widget firstChild;
  final Widget secondChild;
  final bool showFirst;
  final AlignmentGeometry alignment;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      alignment: alignment,
      firstChild: firstChild,
      secondChild: secondChild,
      sizeCurve: Curves.ease,
      crossFadeState: showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: duration,
    );
  }
}
