import 'package:flutter/material.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SpFadeIn extends StatelessWidget {
  const SpFadeIn({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      duration: ConfigConstant.fadeDuration,
      tween: IntTween(begin: 0, end: 1),
      child: child,
      builder: (context, value, child) {
        return AnimatedOpacity(
          opacity: value == 1 ? 1.0 : 0.0,
          duration: ConfigConstant.fadeDuration,
          child: child,
        );
      },
    );
  }
}
