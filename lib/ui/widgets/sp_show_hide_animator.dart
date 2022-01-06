import 'package:flutter/material.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SpShowHideAnimator extends StatelessWidget {
  final Duration animationDuration;
  final Widget child;
  final Curve showCurve;
  final Curve hideCurve;
  final bool shouldShow;

  const SpShowHideAnimator({
    Key? key,
    required this.child,
    this.animationDuration = ConfigConstant.fadeDuration,
    this.showCurve = Curves.ease,
    this.hideCurve = Curves.ease,
    this.shouldShow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: animationDuration,
      switchInCurve: showCurve,
      switchOutCurve: hideCurve,
      child: shouldShow ? child : const Offstage(),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
    );
  }
}
