import 'package:flutter/material.dart';
import 'package:spooky/core/routes/setting/base_route_setting.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class DefaultRouteSetting<T> extends BaseRouteSetting<T> {
  DefaultRouteSetting({
    @Deprecated("Isn't used anymore") this.canSwap = true,
    required Widget Function(dynamic p1) route,
    required bool fullscreenDialog,
  }) : super(route: route, fullscreenDialog: fullscreenDialog);

  final bool canSwap;

  @override
  Route<T> toRoute(BuildContext context, RouteSettings? settings) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        // return AnimatedPageRoute.sharedAxis<T>(
        //   builder: route,
        //   settings: settings?.copyWith(arguments: this),
        //   fullscreenDialog: fullscreenDialog,
        //   fillColor: M3Color.of(context).background,
        //   type: SharedAxisTransitionType.horizontal,
        // );

        return MaterialPageRoute<T>(
          builder: route,
          settings: RouteSettings(arguments: this, name: settings?.name),
          fullscreenDialog: fullscreenDialog,
        );

      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return SwipeablePageRoute<T>(
          canSwipe: true,
          builder: route,
          settings: RouteSettings(arguments: this, name: settings?.name),
          fullscreenDialog: fullscreenDialog,
        );
    }
  }
}
