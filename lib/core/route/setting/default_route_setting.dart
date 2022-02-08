import 'package:flutter/src/widgets/framework.dart';
import 'package:spooky/core/route/setting/base_route_setting.dart';

class DefaultRouteSetting extends BaseRouteSetting {
  DefaultRouteSetting({
    required String title,
    required this.isRoot,
    required this.canSwap,
    required this.fullscreenDialog,
    required Widget Function(dynamic p1) route,
  }) : super(route: route, title: title);

  final bool isRoot;
  final bool fullscreenDialog;
  final bool canSwap;
}
