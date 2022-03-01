import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SpDimissableBackground extends StatelessWidget {
  const SpDimissableBackground({
    Key? key,
    required this.iconData,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.alignment = Alignment.centerRight,
    this.iconSize = ConfigConstant.iconSize3,
    this.shouldAnimatedIcon = true,
  }) : super(key: key);

  final Alignment alignment;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData iconData;
  final String? label;
  final double iconSize;
  final bool shouldAnimatedIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<int>(
            duration: ConfigConstant.duration,
            tween: IntTween(begin: 0, end: 1),
            builder: (context, value, child) {
              if (shouldAnimatedIcon) {
                return SpAnimatedIcons(
                  firstChild: buildChild(),
                  secondChild: Icon(
                    Icons.swap_horiz,
                    size: iconSize,
                    color: foregroundColor,
                    key: const ValueKey(Icons.swap_horiz),
                  ),
                  showFirst: value == 1,
                );
              }
              return buildChild();
            },
          ),
          if (label != null) ConfigConstant.sizedBoxH0,
          if (label != null) Text(label!, style: TextStyle(color: foregroundColor)),
        ],
      ),
    );
  }

  Icon buildChild() {
    return Icon(
      iconData,
      size: iconSize,
      color: foregroundColor,
      key: ValueKey(iconData),
    );
  }
}
