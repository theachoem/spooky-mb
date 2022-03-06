import 'package:flutter/material.dart';
import 'package:spooky/core/routes/setting/base_route_setting.dart';
import 'package:spooky/core/routes/page_routes/animated_page_route.dart';

class AnimatedRouteSetting<T> extends BaseRouteSetting<T> {
  AnimatedRouteSetting({
    required this.fillColor,
    required Widget Function(dynamic p1) route,
    required String title,
    required bool fullscreenDialog,
  }) : super(route: route, title: title, fullscreenDialog: fullscreenDialog);

  final Color? fillColor;

  @override
  Route<T> toRoute(BuildContext context, RouteSettings? settings) {
    return AnimatedPageRoute.sharedAxis<T>(
      builder: route,
      settings: settings?.copyWith(arguments: this),
      fillColor: fillColor,
      fullscreenDialog: fullscreenDialog,
      type: SharedAxisTransitionType.vertical,
    );
  }
}
