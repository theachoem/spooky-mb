import 'package:flutter/material.dart';

enum SpTapEffectType {
  touchableOpacity,
  scaleDown,
}

class SpTapEffect extends StatefulWidget {
  const SpTapEffect({
    Key? key,
    required this.child,
    required this.onTap,
    this.duration = const Duration(milliseconds: 100),
    this.vibrate = false,
    this.behavior = HitTestBehavior.opaque,
    this.effects = const [
      SpTapEffectType.touchableOpacity,
    ],
    this.onLongPressed,
  }) : super(key: key);

  final Widget child;
  final List<SpTapEffectType> effects;
  final void Function()? onTap;
  final void Function()? onLongPressed;
  final Duration duration;
  final bool vibrate;
  final HitTestBehavior? behavior;

  @override
  State<SpTapEffect> createState() => _SpTapEffectState();
}

class _SpTapEffectState extends State<SpTapEffect> with SingleTickerProviderStateMixin {
  final double scaleActive = 0.98;
  final double opacityActive = 0.2;
  late AnimationController controller;
  late Animation<double> animation;
  late Animation<double> animation2;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: widget.duration);
    animation = Tween<double>(begin: 1, end: scaleActive).animate(controller);
    animation2 = Tween<double>(begin: 1, end: opacityActive).animate(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onTapCancel() => controller.reverse();
  void onTapDown() => controller.forward();
  void onTapUp() => controller.reverse().then((value) => widget.onTap!());

  @override
  Widget build(BuildContext context) {
    if (widget.onTap != null) {
      return GestureDetector(
        behavior: widget.behavior,
        onLongPress: widget.onLongPressed,
        onTapDown: (detail) => onTapDown(),
        onTapUp: (detail) => onTapUp(),
        onTapCancel: () => onTapCancel(),
        child: buildChild(controller, animation, animation2),
      );
    } else {
      return buildChild(controller, animation, animation2);
    }
  }

  AnimatedBuilder buildChild(
    AnimationController controller,
    Animation<double> animation,
    Animation<double> animation2,
  ) {
    return AnimatedBuilder(
      child: widget.child,
      animation: controller,
      builder: (context, child) {
        Widget result = child ?? const SizedBox();
        for (var effect in widget.effects) {
          switch (effect) {
            case SpTapEffectType.scaleDown:
              result = ScaleTransition(scale: animation, child: result);
              break;
            case SpTapEffectType.touchableOpacity:
              result = Opacity(opacity: animation2.value, child: result);
              break;
          }
        }
        return result;
      },
    );
  }
}
