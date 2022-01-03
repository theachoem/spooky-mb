// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;

import '../../ui/views/detail/detail_view.dart' as _i2;
import '../../ui/views/explore/explore_view.dart' as _i3;
import '../../ui/views/home/home_view.dart' as _i4;
import '../../ui/views/main/main_view.dart' as _i5;
import '../../ui/views/setting/setting_view.dart' as _i1;

class Router extends _i6.RootStackRouter {
  Router([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    Setting.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.SettingView());
    },
    Detail.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i2.DetailView(),
          fullscreenDialog: true);
    },
    Explore.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.ExploreView());
    },
    Home.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.HomeView());
    },
    Main.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.MainView());
    }
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(Setting.name, path: '/setting-view'),
        _i6.RouteConfig(Detail.name, path: '/detail-view'),
        _i6.RouteConfig(Explore.name, path: '/explore-view'),
        _i6.RouteConfig(Home.name, path: '/'),
        _i6.RouteConfig(Main.name, path: '/main-view')
      ];
}

/// generated route for
/// [_i1.SettingView]
class Setting extends _i6.PageRouteInfo<void> {
  const Setting() : super(Setting.name, path: '/setting-view');

  static const String name = 'Setting';
}

/// generated route for
/// [_i2.DetailView]
class Detail extends _i6.PageRouteInfo<void> {
  const Detail() : super(Detail.name, path: '/detail-view');

  static const String name = 'Detail';
}

/// generated route for
/// [_i3.ExploreView]
class Explore extends _i6.PageRouteInfo<void> {
  const Explore() : super(Explore.name, path: '/explore-view');

  static const String name = 'Explore';
}

/// generated route for
/// [_i4.HomeView]
class Home extends _i6.PageRouteInfo<void> {
  const Home() : super(Home.name, path: '/');

  static const String name = 'Home';
}

/// generated route for
/// [_i5.MainView]
class Main extends _i6.PageRouteInfo<void> {
  const Main() : super(Main.name, path: '/main-view');

  static const String name = 'Main';
}
