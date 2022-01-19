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
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + kToolbarHeight / 2 + 12,
      right: 0,
      left: 0,
      child: IgnorePointer(
        child: AnimatedOpacity(
          curve: Curves.fastOutSlowIn,
          opacity: pagesCount > 1 ? 1 : 0,
          duration: ConfigConstant.duration,
          child: Container(
            alignment: Alignment.bottomCenter,
            child: SmoothPageIndicator(
              controller: controller,
              effect: ConfigConstant.indicatorEffect,
              count: pagesCount,
            ),
          ),
        ),
      ),
    );
  }
}
