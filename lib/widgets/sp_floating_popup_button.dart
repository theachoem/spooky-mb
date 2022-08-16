import 'dart:math';

import 'package:animated_clipper/animated_clipper.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';
import 'package:spooky/utils/util_widgets/measure_size.dart';

class SpFloatingPopUpButton extends StatefulWidget {
  const SpFloatingPopUpButton({
    Key? key,
    this.dyGetter,
    required this.cacheFloatingSize,
    required this.builder,
    required this.floatBuilder,
    this.bottomToTop = true,
    this.pathBuilder = PathBuilders.circleOut,
  }) : super(key: key);

  final PathBuilder pathBuilder;
  final double cacheFloatingSize;
  final double Function(double dy)? dyGetter;
  final Widget Function(void Function() callback) floatBuilder;
  final Widget Function(void Function() callback) builder;
  final bool bottomToTop;

  @override
  State<SpFloatingPopUpButton> createState() => _SpFloatingPopUpButtonState();
}

class _SpFloatingPopUpButtonState extends State<SpFloatingPopUpButton>
    with SingleTickerProviderStateMixin, StatefulMixin {
  late final AnimationController animationController;
  final GlobalKey floatingKey = LabeledGlobalKey("Floating");

  OverlayEntry? floating;
  bool isFloatingOpen = false;
  Size? childSize;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: ConfigConstant.duration);
    super.initState();
  }

  @override
  void dispose() {
    if (isFloatingOpen) floating?.remove();
    animationController.dispose();
    super.dispose();
  }

  void toggle() async {
    BuildContext context = App.navigatorKey.currentContext ?? this.context;
    if (animationController.isAnimating == false) {
      if (isFloatingOpen) {
        await animationController.reverse();
        floating?.remove();
      } else {
        floating = createFloating();
        Overlay.of(context)?.insert(floating!);
        await animationController.forward();
      }
      isFloatingOpen = !isFloatingOpen;
    }
  }

  OverlayEntry? createFloating({Color? currentColor}) {
    if (floatingKey.currentContext == null) return null;
    RenderBox renderBox = floatingKey.currentContext?.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    double childWidth = childSize?.width ?? widget.cacheFloatingSize - 36;
    double? left = max(10, offset.dx - childWidth / 2);
    double? right = max(10, screenSize.width - left - childWidth);
    double top = widget.dyGetter != null ? widget.dyGetter!(offset.dy) : offset.dy;

    if (offset.dx >= screenSize.width / 2) {
      left = null;
    } else {
      right = null;
    }

    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: toggle,
          child: Stack(
            children: [
              Positioned(
                left: left,
                right: right,
                top: top,
                child: MeasureSize(
                  onChange: (Size size) => childSize = size,
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0.0,
                          (1 - animationController.value) * (widget.bottomToTop ? 10 : -10),
                        ),
                        child: Opacity(
                          opacity: animationController.value,
                          child: child,
                        ),
                      );
                    },
                    child: AnimatedClipReveal(
                      revealFirstChild: true,
                      duration: ConfigConstant.fadeDuration,
                      curve: Curves.linear,
                      pathBuilder: widget.pathBuilder,
                      child: widget.floatBuilder(toggle),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: floatingKey,
      child: widget.builder(toggle),
    );
  }
}
