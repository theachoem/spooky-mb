import 'package:flutter/material.dart';
import 'package:spooky/core/route/setting/base_route_setting.dart';

class DefaultRouteSetting extends BaseRouteSetting {
  DefaultRouteSetting({
    required String title,
    required this.canSwap,
    required Widget Function(dynamic p1) route,
    required bool fullscreenDialog,
  }) : super(route: route, title: title, fullscreenDialog: fullscreenDialog);

  final bool canSwap;
}
