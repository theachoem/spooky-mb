import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SpTabView extends StatelessWidget {
  const SpTabView({
    Key? key,
    this.children = const [],
    this.controller,
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,
    this.listener,
  }) : super(key: key);

  /// if `TabController` isn't provided, make sure you have
  /// wraped your widget with `DefaultTabController`
  final TabController? controller;
  final ScrollPhysics? physics;
  final List<Widget> children;
  final DragStartBehavior dragStartBehavior;
  final void Function(TabController controller)? listener;

  @override
  Widget build(BuildContext context) {
    final TabController? tabController = controller ?? DefaultTabController.of(context);
    final List<Widget> children = buildChildren(context: context, controller: tabController);

    return TabBarView(
      key: key,
      controller: tabController,
      physics: physics,
      children: children,
      dragStartBehavior: dragStartBehavior,
    );
  }

  List<Widget> buildChildren({
    required BuildContext context,
    TabController? controller,
  }) {
    final double width = MediaQuery.of(context).size.width;
    List<Widget> result = [];

    for (int itemIndex = 0; itemIndex < children.length; itemIndex++) {
      final Widget child = children[itemIndex];
      result.add(
        AnimatedBuilder(
          child: child,
          animation: controller!.animation!,
          builder: (context, child) {
            final double offset = controller.offset;
            if (listener != null) {
              listener!(controller);
            }

            final bool isCurrentChild = itemIndex == controller.index;
            final int currentIndex = controller.index;

            final bool dragToRight = offset > 0;

            /// `translateX1` is used to keep `child` in current position
            /// on horizontal scroll
            double translateX1 = 0;

            /// `translateX2` is used to animate `child` to abit left or right
            /// on horizontal scroll
            double? translateX2 = 0;

            /// `opacity` is used to to fadely animate `child`
            /// on horizontal scroll
            double? opacity = 1;

            /// In most case, `opacity = lerpDouble(0, 1, ..)` which its
            /// value is between `0 -> 1`,
            /// but since we want to fade opacity faster, we change it to
            /// `opacity = lerpDouble(1, -1, ..)` instead.
            /// But, we still check to make sure it is valid value.

            if (dragToRight) {
              bool inScope = itemIndex <= currentIndex + 1 && itemIndex >= currentIndex;

              if (inScope) {
                if (isCurrentChild) {
                  translateX1 = width * offset;
                  opacity = lerpDouble(1, -1, offset);
                  translateX2 = lerpDouble(0, -50, offset);
                } else {
                  translateX1 = width * (offset - 1);
                  opacity = lerpDouble(-1, 1, offset);
                  translateX2 = lerpDouble(50, 0, offset);
                }
              }
            } else {
              bool inScope = itemIndex <= currentIndex && itemIndex >= currentIndex - 1;

              if (inScope) {
                if (isCurrentChild) {
                  opacity = lerpDouble(1, -1, -offset);
                  translateX1 = width * offset;
                  translateX2 = lerpDouble(0, -50, offset);
                } else {
                  opacity = lerpDouble(-1, 1, -offset);
                  translateX1 = width * (offset + 1);
                  translateX2 = lerpDouble(-50, -100, offset);
                }
              }
            }

            if (opacity! < 0) opacity = 0;
            if (opacity > 1) opacity = 1;

            return Transform(
              transform: Matrix4.identity()
                ..translate(translateX1)
                ..translate(translateX2),
              child: Opacity(
                opacity: controller.indexIsChanging ? 0 : opacity,
                child: AnimatedOpacity(
                  opacity: controller.indexIsChanging ? 0 : opacity,
                  duration: ConfigConstant.fadeDuration,
                  child: child,
                ),
              ),
            );
          },
        ),
      );
    }

    return result;
  }
}
