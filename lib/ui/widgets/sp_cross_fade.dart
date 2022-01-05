import 'package:flutter/material.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SpCrossFade extends StatelessWidget {
  const SpCrossFade({
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
    return AnimatedCrossFade(
      firstChild: firstChild,
      secondChild: secondChild,
      sizeCurve: Curves.ease,
      crossFadeState: showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: ConfigConstant.fadeDuration,
    );
  }
}
