import 'package:flutter/material.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SpScaleIn extends StatelessWidget {
  const SpScaleIn({
    Key? key,
    required this.child,
    this.curve,
    this.duration = ConfigConstant.fadeDuration,
    this.transformAlignment = Alignment.bottomCenter,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Curve? curve;
  final Alignment transformAlignment;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      duration: duration,
      tween: IntTween(begin: 0, end: 1),
      child: child,
      builder: (context, value, child) {
        return AnimatedContainer(
          transformAlignment: transformAlignment,
          transform: Matrix4.identity()..scale(value == 1 ? 1.0 : 0.5),
          duration: ConfigConstant.fadeDuration,
          curve: curve ?? Curves.linear,
          child: child,
        );
      },
    );
  }
}
