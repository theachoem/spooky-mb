import 'package:flutter/material.dart';

class SpAnimatedIcons extends StatelessWidget {
  const SpAnimatedIcons({
    Key? key,
    required this.firstChild,
    required this.secondChild,
    required this.showFirst,
  }) : super(key: key);

  final Widget firstChild;
  final Widget secondChild;
  final bool showFirst;

  @override
  Widget build(BuildContext context) {
    assert(firstChild.key != null);
    assert(secondChild.key != null);
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 750),
      switchInCurve: Curves.fastOutSlowIn,
      switchOutCurve: Curves.easeInToLinear,
      child: showFirst ? firstChild : secondChild,
      transitionBuilder: (child, animation) {
        return RotationTransition(
          turns: child.key == firstChild.key
              ? Tween<double>(begin: 1, end: 0.75).animate(animation)
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
