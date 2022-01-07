// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;

import '../../ui/views/detail/detail_view.dart' as _i1;
import '../../ui/views/explore/explore_view.dart' as _i4;
import '../../ui/views/file_manager/file_manager_view.dart' as _i6;
import '../../ui/views/home/home_view.dart' as _i3;
import '../../ui/views/main/main_view.dart' as _i2;
import '../../ui/views/setting/setting_view.dart' as _i5;
import '../models/story_model.dart' as _i9;

class Router extends _i7.RootStackRouter {
  Router([_i8.GlobalKey<_i8.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    Detail.name: (routeData) {
      final args =
          routeData.argsAs<DetailArgs>(orElse: () => const DetailArgs());
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i1.DetailView(key: args.key, story: args.story));
    },
    Main.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.MainView());
    },
    Home.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.HomeView());
    },
    Explore.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.ExploreView());
    },
    Setting.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.SettingView());
    },
    FileManager.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.FileManagerView());
    }
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(Detail.name, path: '/detail-view'),
        _i7.RouteConfig(Main.name, path: '/', children: [
          _i7.RouteConfig(Home.name, path: 'home-view', parent: Main.name),
          _i7.RouteConfig(Explore.name,
              path: 'explore-view', parent: Main.name),
          _i7.RouteConfig(Setting.name,
              path: 'setting-view', parent: Main.name),
          _i7.RouteConfig(FileManager.name,
              path: 'file-manager-view', parent: Main.name)
        ])
      ];
}

/// generated route for
/// [_i1.DetailView]
class Detail extends _i7.PageRouteInfo<DetailArgs> {
  Detail({_i8.Key? key, _i9.StoryModel? story})
      : super(Detail.name,
            path: '/detail-view', args: DetailArgs(key: key, story: story));

  static const String name = 'Detail';
}

class DetailArgs {
  const DetailArgs({this.key, this.story});

  final _i8.Key? key;

  final _i9.StoryModel? story;

  @override
  String toString() {
    return 'DetailArgs{key: $key, story: $story}';
  }
}

/// generated route for
/// [_i2.MainView]
class Main extends _i7.PageRouteInfo<void> {
  const Main({List<_i7.PageRouteInfo>? children})
      : super(Main.name, path: '/', initialChildren: children);

  static const String name = 'Main';
}

/// generated route for
/// [_i3.HomeView]
class Home extends _i7.PageRouteInfo<void> {
  const Home() : super(Home.name, path: 'home-view');

  static const String name = 'Home';
}

/// generated route for
/// [_i4.ExploreView]
class Explore extends _i7.PageRouteInfo<void> {
  const Explore() : super(Explore.name, path: 'explore-view');

  static const String name = 'Explore';
}

/// generated route for
/// [_i5.SettingView]
class Setting extends _i7.PageRouteInfo<void> {
  const Setting() : super(Setting.name, path: 'setting-view');

  static const String name = 'Setting';
}

/// generated route for
/// [_i6.FileManagerView]
class FileManager extends _i7.PageRouteInfo<void> {
  const FileManager() : super(FileManager.name, path: 'file-manager-view');

  static const String name = 'FileManager';
}
