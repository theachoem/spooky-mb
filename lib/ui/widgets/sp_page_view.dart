import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';

class SpPageView extends StatefulWidget {
  const SpPageView({
    Key? key,
    required this.controller,
    required this.itemBuilder,
    required this.itemCount,
    this.physics,
  }) : super(key: key);

  final PageController controller;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ScrollPhysics? physics;

  @override
  State<SpPageView> createState() => _SpPageViewState();
}

class _SpPageViewState extends State<SpPageView> with StatefulMixin {
  late ValueNotifier<double> offsetNotifier;

  @override
  void initState() {
    offsetNotifier = ValueNotifier(0);
    initializeController().then((value) {
      widget.controller.addListener(() {
        if (widget.controller.hasClients) offsetNotifier.value = widget.controller.offset;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    offsetNotifier.dispose();
  }

  double get width => mediaQueryData.size.width;
  PageController get controller => widget.controller;

  Future<bool> initializeController() {
    Completer<bool> completer = Completer<bool>();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      completer.complete(true);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.itemCount,
      controller: widget.controller,
      physics: widget.physics,
      itemBuilder: (context, itemIndex) {
        return FutureBuilder(
          future: initializeController(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return ValueListenableBuilder<double>(
              valueListenable: offsetNotifier,
              child: widget.itemBuilder(context, itemIndex),
              builder: (context, value, child) {
                int currentIndex = offsetNotifier.value ~/ width;
                bool isCurrentChild = itemIndex == currentIndex;

                double translateX1 = 0;
                double? translateX2 = 0;
                double? opacity = 1;

                double offset = 0;
                offset = (controller.page ?? 0) % 1;

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

                if (opacity! < 0) opacity = 0;
                if (opacity > 1) opacity = 1;

                return Transform(
                  transform: Matrix4.identity()
                    ..translate(translateX1)
                    ..translate(translateX2),
                  child: Opacity(
                    opacity: opacity,
                    child: child,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
