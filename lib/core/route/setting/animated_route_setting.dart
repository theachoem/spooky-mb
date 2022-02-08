import 'package:flutter/material.dart';
import 'package:spooky/core/route/setting/base_route_setting.dart';

class AnimatedRouteSetting extends BaseRouteSetting {
  AnimatedRouteSetting({
    required this.screen,
    required this.fillColor,
    required Widget Function(dynamic p1) route,
    required String title,
  }) : super(route: route, title: title);

  final Widget? screen;
  final Color? fillColor;
}
