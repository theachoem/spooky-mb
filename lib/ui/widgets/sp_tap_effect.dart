import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';

enum SpTapEffectType {
  touchableOpacity,
  scaleDown,
  border,
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
  late Animation<double> scaleAnimation;
  late Animation<double> opacityAnimation;
  late Animation<double> borderAnimation;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: widget.duration);
    scaleAnimation = Tween<double>(begin: 1, end: scaleActive).animate(controller);
    opacityAnimation = Tween<double>(begin: 1, end: opacityActive).animate(controller);
    borderAnimation = Tween<double>(begin: 0, end: 1).animate(controller);
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
        child: buildChild(controller),
      );
    } else {
      return buildChild(controller);
    }
  }

  AnimatedBuilder buildChild(AnimationController controller) {
    return AnimatedBuilder(
      child: widget.child,
      animation: controller,
      builder: (context, child) {
        Widget result = child ?? const SizedBox();
        for (var effect in widget.effects) {
          switch (effect) {
            case SpTapEffectType.scaleDown:
              result = ScaleTransition(scale: scaleAnimation, child: result);
              break;
            case SpTapEffectType.touchableOpacity:
              result = Opacity(opacity: opacityAnimation.value, child: result);
              break;
            case SpTapEffectType.border:
              result = Stack(
                alignment: Alignment.center,
                children: [
                  result,
                  Positioned.fill(
                    child: Container(
                      transform: Matrix4.identity()..scale(1.25),
                      transformAlignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.lerp(Colors.transparent, M3Color.of(context).onSurface, borderAnimation.value)!,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              );
              break;
          }
        }
        return result;
      },
    );
  }
}
