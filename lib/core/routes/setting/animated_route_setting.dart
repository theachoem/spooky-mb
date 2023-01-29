import 'package:flutter/material.dart';
import 'package:spooky/core/routes/setting/base_route_setting.dart';
import 'package:spooky/core/routes/page_routes/animated_page_route.dart';

class AnimatedRouteSetting<T> extends BaseRouteSetting<T> {
  AnimatedRouteSetting({
    required this.fillColor,
    required Widget Function(dynamic p1) route,
    required bool fullscreenDialog,
  }) : super(route: route, fullscreenDialog: fullscreenDialog);

  final Color? fillColor;

  @override
  Route<T> toRoute(BuildContext context, RouteSettings? settings) {
    return AnimatedPageRoute.sharedAxis<T>(
      builder: route,
      settings: RouteSettings(arguments: this, name: settings?.name),
      fillColor: fillColor,
      fullscreenDialog: fullscreenDialog,
      type: SharedAxisTransitionType.vertical,
    );
  }
}
