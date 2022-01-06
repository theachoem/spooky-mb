import 'package:flutter/material.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SpAnimatedIcons extends StatelessWidget {
  const SpAnimatedIcons({
    Key? key,
    required this.firstChild,
    required this.secondChild,
    required this.showFirst,
    this.duration = ConfigConstant.duration,
  }) : super(key: key);

  final Widget firstChild;
  final Widget secondChild;
  final bool showFirst;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    assert(firstChild.key != null);
    assert(secondChild.key != null);
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.fastOutSlowIn,
      switchOutCurve: Curves.easeInToLinear,
      child: showFirst ? firstChild : secondChild,
      transitionBuilder: (child, animation) {
        return RotationTransition(
          turns: child.key == firstChild.key
              ? Tween<double>(begin: 0.5, end: 0).animate(animation)
              : Tween<double>(begin: 0.5, end: 1).animate(animation),
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
    );
  }
}
