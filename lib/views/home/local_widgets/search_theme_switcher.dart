import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_page_view/sp_page_view_datas.dart';
import 'package:spooky/widgets/sp_theme_switcher.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SearchThemeSwicher extends StatefulWidget {
  const SearchThemeSwicher({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchThemeSwicher> createState() => _SearchThemeSwicherState();
}

class _SearchThemeSwicherState extends State<SearchThemeSwicher> {
  late final PageController controller;
  late final ValueNotifier<double> offsetNotifier;
  Timer? timer;

  @override
  void initState() {
    offsetNotifier = ValueNotifier(0);
    controller = PageController(initialPage: 100, keepPage: false);

    controller.addListener(_listener);
    setTimer();

    super.initState();
  }

  void _listener() {
    offsetNotifier.value = controller.offset;
    setTimer();
  }

  void setTimer() {
    if (timer?.isActive == true) timer?.cancel();
    timer = Timer(const Duration(seconds: 10), animateNext);
  }

  void animateNext() {
    controller.animateToPage(
      (controller.page?.toInt() ?? 0) + 1,
      duration: ConfigConstant.duration * 2,
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    controller.dispose();
    offsetNotifier.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      double height = constraint.maxHeight;
      return PageView.builder(
        controller: controller,
        itemCount: null,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return ValueListenableBuilder<double>(
            valueListenable: offsetNotifier,
            child: Center(
              child: index.isEven ? SpThemeSwitcher() : const _SearchButton(),
            ),
            builder: (context, offset, child) {
              return buildItem(index, height, child);
            },
          );
        },
      );
    });
  }

  Widget buildItem(int index, double height, Widget? child) {
    SpPageViewDatas? datas = controller.position.haveDimensions
        ? SpPageViewDatas.fromOffset(
            pageOffset: offsetNotifier.value,
            itemIndex: index,
            controller: controller,
            width: height,
          )
        : null;
    double opacity = datas?.opacity ?? 1.0;
    return Container(
      transformAlignment: Alignment.center,
      transform: Matrix4.identity()
        ..scale(opacity)
        ..translate(0.0, opacity),
      child: Opacity(
        opacity: opacity,
        child: child,
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpIconButton(
      backgroundColor: M3Color.of(context).readOnly.surface5,
      icon: Icon(
        Icons.search,
        color: M3Color.of(context).primary,
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(
          SpRouter.search.path,
          arguments: SearchArgs(
            initialQuery: StoryQueryOptionsModel(),
          ),
        );
      },
    );
  }
}
