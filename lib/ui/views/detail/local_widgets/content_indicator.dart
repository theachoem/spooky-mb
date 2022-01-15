import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class ContentIndicator extends StatelessWidget {
  const ContentIndicator({
    Key? key,
    required this.controller,
    required this.pagesCount,
  }) : super(key: key);

  final PageController controller;
  final int pagesCount;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        curve: Curves.fastOutSlowIn,
        opacity: pagesCount > 1 ? 1 : 0,
        duration: ConfigConstant.duration,
        child: Container(
          alignment: Alignment.topRight,
          margin: EdgeInsets.all(ConfigConstant.margin1),
          child: SmoothPageIndicator(
            controller: controller,
            effect: WormEffect(dotHeight: 4.0, spacing: 4),
            count: pagesCount,
          ),
        ),
      ),
    );
  }
}
