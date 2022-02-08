import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spooky/core/route/router.gr.dart';
import 'package:spooky/core/route/setting/base_route_setting.dart';
import 'package:spooky/core/route/setting/default_route_setting.dart';
import 'package:spooky/ui/views/detail/detail_view.dart';
import 'package:spooky/ui/views/home/home_view.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class SpRouteConfig {
  final RouteSettings? settings;
  final BuildContext? context;

  SpRouteConfig({
    this.settings,
    this.context,
  });

  static const String home = Home.name;
  static const String detail = Detail.name;
  static const String notFound = '/not-found';

  bool hasRoute(String name) => routes.containsKey(name);

  Route<dynamic> generate() {
    String? name = settings?.name;
    if (name == null || !hasRoute(name)) name = notFound;

    BaseRouteSetting? setting = routes[name];
    if (setting is DefaultRouteSetting) {
      if (Platform.isIOS) {
        return SwipeablePageRoute(
          canSwipe: setting.canSwap == true && !(setting.isRoot == true),
          canOnlySwipeFromEdge: setting.canSwap == true && !(setting.isRoot == true),
          settings: settings?.copyWith(arguments: setting),
          builder: setting.route,
          fullscreenDialog: setting.fullscreenDialog,
        );
      } else {
        return MaterialPageRoute(
          settings: settings?.copyWith(arguments: setting),
          builder: setting.route,
          fullscreenDialog: setting.fullscreenDialog,
        );
      }
    }

    return MaterialPageRoute(
      fullscreenDialog: true,
      settings: settings?.copyWith(arguments: routes[name]!),
      builder: (context) {
        return _buildNotFound();
      },
    );
  }

  Map<String, BaseRouteSetting> get routes {
    return {
      home: DefaultRouteSetting(
        title: "Home",
        isRoot: false,
        canSwap: false,
        fullscreenDialog: false,
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is HomeArgs) {
            return HomeView(
              onTabChange: arguments.onTabChange,
              onYearChange: arguments.onYearChange,
              onListReloaderReady: arguments.onListReloaderReady,
            );
          }
          return _buildNotFound();
        },
      ),
      detail: DefaultRouteSetting(
        title: "Detail",
        isRoot: false,
        canSwap: false,
        fullscreenDialog: false,
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is DetailArgs) {
            return DetailView(
              initialStory: arguments.initialStory,
              intialFlow: arguments.intialFlow,
            );
          }
          return _buildNotFound();
        },
      ),
    };
  }

  Widget _buildNotFound() {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Not found"),
      ),
    );
  }
}
