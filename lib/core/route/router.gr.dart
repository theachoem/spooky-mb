// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'dart:io' as _i10;

import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i3;

import '../../ui/views/detail/detail_view.dart' as _i1;
import '../../ui/views/explore/explore_view.dart' as _i6;
import '../../ui/views/file_manager/file_manager_view.dart' as _i2;
import '../../ui/views/home/home_view.dart' as _i5;
import '../../ui/views/main/main_view.dart' as _i4;
import '../../ui/views/setting/setting_view.dart' as _i7;
import '../models/story_model.dart' as _i9;

class AppRouter extends _i8.RootStackRouter {
  AppRouter([_i3.GlobalKey<_i3.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    Detail.name: (routeData) {
      final args = routeData.argsAs<DetailArgs>();
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i1.DetailView(key: args.key, story: args.story));
    },
    FileManager.name: (routeData) {
      final args = routeData.argsAs<FileManagerArgs>();
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i2.FileManagerView(key: args.key, directory: args.directory));
    },
    LicensePage.name: (routeData) {
      final args = routeData.argsAs<LicensePageArgs>(
          orElse: () => const LicensePageArgs());
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.LicensePage(
              key: args.key,
              applicationName: args.applicationName,
              applicationVersion: args.applicationVersion,
              applicationIcon: args.applicationIcon,
              applicationLegalese: args.applicationLegalese));
    },
    Main.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.MainView());
    },
    Home.name: (routeData) {
      final args = routeData.argsAs<HomeArgs>();
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.HomeView(key: args.key, onTabChange: args.onTabChange));
    },
    Explore.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.ExploreView());
    },
    Setting.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i7.SettingView());
    }
  };

  @override
  List<_i8.RouteConfig> get routes => [
        _i8.RouteConfig(Detail.name, path: '/detail-view'),
        _i8.RouteConfig(FileManager.name, path: '/file-manager-view'),
        _i8.RouteConfig(LicensePage.name, path: '/license-page'),
        _i8.RouteConfig(Main.name, path: '/', children: [
          _i8.RouteConfig(Home.name, path: 'home-view', parent: Main.name),
          _i8.RouteConfig(Explore.name,
              path: 'explore-view', parent: Main.name),
          _i8.RouteConfig(Setting.name, path: 'setting-view', parent: Main.name)
        ])
      ];
}

/// generated route for
/// [_i1.DetailView]
class Detail extends _i8.PageRouteInfo<DetailArgs> {
  Detail({_i3.Key? key, required _i9.StoryModel story})
      : super(Detail.name,
            path: '/detail-view', args: DetailArgs(key: key, story: story));

  static const String name = 'Detail';
}

class DetailArgs {
  const DetailArgs({this.key, required this.story});

  final _i3.Key? key;

  final _i9.StoryModel story;

  @override
  String toString() {
    return 'DetailArgs{key: $key, story: $story}';
  }
}

/// generated route for
/// [_i2.FileManagerView]
class FileManager extends _i8.PageRouteInfo<FileManagerArgs> {
  FileManager({_i3.Key? key, required _i10.Directory directory})
      : super(FileManager.name,
            path: '/file-manager-view',
            args: FileManagerArgs(key: key, directory: directory));

  static const String name = 'FileManager';
}

class FileManagerArgs {
  const FileManagerArgs({this.key, required this.directory});

  final _i3.Key? key;

  final _i10.Directory directory;

  @override
  String toString() {
    return 'FileManagerArgs{key: $key, directory: $directory}';
  }
}

/// generated route for
/// [_i3.LicensePage]
class LicensePage extends _i8.PageRouteInfo<LicensePageArgs> {
  LicensePage(
      {_i3.Key? key,
      String? applicationName,
      String? applicationVersion,
      _i3.Widget? applicationIcon,
      String? applicationLegalese})
      : super(LicensePage.name,
            path: '/license-page',
            args: LicensePageArgs(
                key: key,
                applicationName: applicationName,
                applicationVersion: applicationVersion,
                applicationIcon: applicationIcon,
                applicationLegalese: applicationLegalese));

  static const String name = 'LicensePage';
}

class LicensePageArgs {
  const LicensePageArgs(
      {this.key,
      this.applicationName,
      this.applicationVersion,
      this.applicationIcon,
      this.applicationLegalese});

  final _i3.Key? key;

  final String? applicationName;

  final String? applicationVersion;

  final _i3.Widget? applicationIcon;

  final String? applicationLegalese;

  @override
  String toString() {
    return 'LicensePageArgs{key: $key, applicationName: $applicationName, applicationVersion: $applicationVersion, applicationIcon: $applicationIcon, applicationLegalese: $applicationLegalese}';
  }
}

/// generated route for
/// [_i4.MainView]
class Main extends _i8.PageRouteInfo<void> {
  const Main({List<_i8.PageRouteInfo>? children})
      : super(Main.name, path: '/', initialChildren: children);

  static const String name = 'Main';
}

/// generated route for
/// [_i5.HomeView]
class Home extends _i8.PageRouteInfo<HomeArgs> {
  Home({_i3.Key? key, required void Function(int) onTabChange})
      : super(Home.name,
            path: 'home-view',
            args: HomeArgs(key: key, onTabChange: onTabChange));

  static const String name = 'Home';
}

class HomeArgs {
  const HomeArgs({this.key, required this.onTabChange});

  final _i3.Key? key;

  final void Function(int) onTabChange;

  @override
  String toString() {
    return 'HomeArgs{key: $key, onTabChange: $onTabChange}';
  }
}

/// generated route for
/// [_i6.ExploreView]
class Explore extends _i8.PageRouteInfo<void> {
  const Explore() : super(Explore.name, path: 'explore-view');

  static const String name = 'Explore';
}

/// generated route for
/// [_i7.SettingView]
class Setting extends _i8.PageRouteInfo<void> {
  const Setting() : super(Setting.name, path: 'setting-view');

  static const String name = 'Setting';
}
