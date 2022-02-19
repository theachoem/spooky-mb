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
    Widget _firstChild = firstChild;
    Widget _secondChild = secondChild;

    if (firstChild.key == null) {
      _firstChild = SizedBox(
        key: ValueKey("1"),
        child: firstChild,
      );
    }
    if (secondChild.key == null) {
      _secondChild = SizedBox(
        key: ValueKey("2"),
        child: secondChild,
      );
    }

    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.fastOutSlowIn,
      switchOutCurve: Curves.easeInToLinear,
      child: showFirst ? _firstChild : _secondChild,
      transitionBuilder: (child, animation) {
        return RotationTransition(
          turns: child.key == _firstChild.key
              ? Tween<double>(begin: 0.25, end: 0).animate(animation)
              : Tween<double>(begin: 0.75, end: 1).animate(animation),
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
    );
  }
}
