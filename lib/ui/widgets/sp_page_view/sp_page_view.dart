import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spooky/ui/widgets/sp_page_view/sp_page_view_datas.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';

class SpPageView extends StatefulWidget {
  const SpPageView({
    Key? key,
    required this.controller,
    required this.itemBuilder,
    required this.itemCount,
    this.onPageChanged,
    this.physics,
  }) : super(key: key);

  final PageController controller;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ScrollPhysics? physics;
  final ValueChanged<int>? onPageChanged;

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
      onPageChanged: widget.onPageChanged,
      itemBuilder: (context, itemIndex) {
        return FutureBuilder(
          future: initializeController(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return ValueListenableBuilder<double>(
              valueListenable: offsetNotifier,
              child: widget.itemBuilder(context, itemIndex),
              builder: (context, value, child) {
                SpPageViewDatas datas = SpPageViewDatas.fromOffset(
                  pageOffset: offsetNotifier.value,
                  itemIndex: itemIndex,
                  controller: controller,
                  width: width,
                );
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(datas.translateX1)
                    ..translate(datas.translateX2),
                  child: Opacity(
                    opacity: datas.opacity,
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
