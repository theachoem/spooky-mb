import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/overlay_render_box_mixin.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';

enum SpOverlayFloatingType {
  topToBottom,
  bottomToTop,
}

typedef SpOverlayChildBuilder = Widget Function(
  BuildContext context,
  GlobalKey<RectGetterState> key,
  VoidCallback callback,
);

typedef SpOverlayBuilder = Widget Function(
  BuildContext context,
  VoidCallback callback,
);

class SpOverlayEntryButton extends StatefulWidget {
  final Duration duration;
  final SpOverlayFloatingType type;
  final SpOverlayBuilder floatingBuilder;
  final SpOverlayChildBuilder childBuilder;

  const SpOverlayEntryButton({
    Key? key,
    required this.floatingBuilder,
    required this.childBuilder,
    this.type = SpOverlayFloatingType.topToBottom,
    this.duration = ConfigConstant.fadeDuration,
  }) : super(key: key);

  @override
  State<SpOverlayEntryButton> createState() => _SpOverlayEntryButtonState();
}

class _SpOverlayEntryButtonState extends State<SpOverlayEntryButton>
    with SingleTickerProviderStateMixin, OverlayRenderBoxMixin, StatefulMixin {
  OverlayEntry? floating;

  set isFloatingOpen(bool value) => setState(() => _isFloatingOpen = value);
  bool _isFloatingOpen = false;
  bool get isFloatingOpen => _isFloatingOpen;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: ConfigConstant.duration);
    super.initState();
  }

  @override
  void dispose() {
    if (isFloatingOpen) floating?.remove();
    controller.dispose();
    super.dispose();
  }

  late final AnimationController controller;

  Future<void> close() async {
    if (controller.isAnimating == false && isFloatingOpen) {
      await controller.reverse();
      floating?.remove();
      isFloatingOpen = false;
    }
  }

  void open() {
    floating = createFloating(context: context);
    if (floating == null) return;
    Overlay.of(context)?.insert(floating!);
    controller.forward();
    isFloatingOpen = true;
  }

  double get layoutPadding => (ConfigConstant.layoutPadding.left + ConfigConstant.layoutPadding.right) / 2;
  OverlayEntry? createFloating({required BuildContext context}) {
    if (childSize == null || childPosition == null) return null;

    double? left = max(layoutPadding, 0);
    double? right = max(layoutPadding, 0);

    double top = max(kToolbarHeight, childPosition!.dy + childSize!.height - 32.0);

    if (childPosition!.dx >= screenSize.width / 2) {
      left = null;
    } else {
      right = null;
    }

    return OverlayEntry(
      builder: (context) {
        return buildOverlayChild(
          left: left,
          right: right,
          top: top,
        );
      },
    );
  }

  Widget buildOverlayChild({
    double? left,
    double? right,
    double? top,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => close(),
      child: Stack(
        children: [
          Positioned(
            left: left,
            right: right,
            top: top,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                double dy = getDy();
                return Transform.translate(
                  offset: Offset(0.0, dy),
                  child: Opacity(
                    opacity: controller.value,
                    child: child,
                  ),
                );
              },
              child: widget.floatingBuilder(context, () => close()),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.childBuilder(
      context,
      globalKey,
      () => open(),
    );
  }

  double getDy() {
    double dy = 0;
    switch (widget.type) {
      case SpOverlayFloatingType.bottomToTop:
        dy = (1 - controller.value) * 10;
        break;
      case SpOverlayFloatingType.topToBottom:
        dy = controller.value * 10;
        break;
      default:
    }
    return dy;
  }
}
