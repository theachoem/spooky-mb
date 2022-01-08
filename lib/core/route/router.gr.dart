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

import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i4;

import '../../ui/views/detail/detail_view.dart' as _i2;
import '../../ui/views/explore/explore_view.dart' as _i7;
import '../../ui/views/file_manager/file_manager_view.dart' as _i3;
import '../../ui/views/file_viewer/file_viewer_view.dart' as _i1;
import '../../ui/views/home/home_view.dart' as _i6;
import '../../ui/views/main/main_view.dart' as _i5;
import '../../ui/views/setting/setting_view.dart' as _i8;
import '../models/story_model.dart' as _i11;

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i4.GlobalKey<_i4.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    FileViewer.name: (routeData) {
      final args = routeData.argsAs<FileViewerArgs>();
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i1.FileViewerView(key: args.key, file: args.file));
    },
    Detail.name: (routeData) {
      final args = routeData.argsAs<DetailArgs>();
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i2.DetailView(key: args.key, story: args.story));
    },
    FileManager.name: (routeData) {
      final args = routeData.argsAs<FileManagerArgs>();
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.FileManagerView(
              key: args.key,
              directory: args.directory,
              fileManagerFlow: args.fileManagerFlow));
    },
    LicensePage.name: (routeData) {
      final args = routeData.argsAs<LicensePageArgs>(
          orElse: () => const LicensePageArgs());
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i4.LicensePage(
              key: args.key,
              applicationName: args.applicationName,
              applicationVersion: args.applicationVersion,
              applicationIcon: args.applicationIcon,
              applicationLegalese: args.applicationLegalese));
    },
    Main.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.MainView());
    },
    Home.name: (routeData) {
      final args = routeData.argsAs<HomeArgs>();
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i6.HomeView(
              key: args.key,
              onTabChange: args.onTabChange,
              onYearChange: args.onYearChange,
              onListReloaderReady: args.onListReloaderReady));
    },
    Explore.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i7.ExploreView());
    },
    Setting.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i8.SettingView());
    }
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(FileViewer.name, path: '/file-viewer-view'),
        _i9.RouteConfig(Detail.name, path: '/detail-view'),
        _i9.RouteConfig(FileManager.name, path: '/file-manager-view'),
        _i9.RouteConfig(LicensePage.name, path: '/license-page'),
        _i9.RouteConfig(Main.name, path: '/', children: [
          _i9.RouteConfig(Home.name, path: 'home-view', parent: Main.name),
          _i9.RouteConfig(Explore.name,
              path: 'explore-view', parent: Main.name),
          _i9.RouteConfig(Setting.name, path: 'setting-view', parent: Main.name)
        ])
      ];
}

/// generated route for
/// [_i1.FileViewerView]
class FileViewer extends _i9.PageRouteInfo<FileViewerArgs> {
  FileViewer({_i4.Key? key, required _i10.File file})
      : super(FileViewer.name,
            path: '/file-viewer-view',
            args: FileViewerArgs(key: key, file: file));

  static const String name = 'FileViewer';
}

class FileViewerArgs {
  const FileViewerArgs({this.key, required this.file});

  final _i4.Key? key;

  final _i10.File file;

  @override
  String toString() {
    return 'FileViewerArgs{key: $key, file: $file}';
  }
}

/// generated route for
/// [_i2.DetailView]
class Detail extends _i9.PageRouteInfo<DetailArgs> {
  Detail({_i4.Key? key, required _i11.StoryModel story})
      : super(Detail.name,
            path: '/detail-view', args: DetailArgs(key: key, story: story));

  static const String name = 'Detail';
}

class DetailArgs {
  const DetailArgs({this.key, required this.story});

  final _i4.Key? key;

  final _i11.StoryModel story;

  @override
  String toString() {
    return 'DetailArgs{key: $key, story: $story}';
  }
}

/// generated route for
/// [_i3.FileManagerView]
class FileManager extends _i9.PageRouteInfo<FileManagerArgs> {
  FileManager(
      {_i4.Key? key,
      required _i10.Directory directory,
      _i3.FileManagerFlow fileManagerFlow = _i3.FileManagerFlow.explore})
      : super(FileManager.name,
            path: '/file-manager-view',
            args: FileManagerArgs(
                key: key,
                directory: directory,
                fileManagerFlow: fileManagerFlow));

  static const String name = 'FileManager';
}

class FileManagerArgs {
  const FileManagerArgs(
      {this.key,
      required this.directory,
      this.fileManagerFlow = _i3.FileManagerFlow.explore});

  final _i4.Key? key;

  final _i10.Directory directory;

  final _i3.FileManagerFlow fileManagerFlow;

  @override
  String toString() {
    return 'FileManagerArgs{key: $key, directory: $directory, fileManagerFlow: $fileManagerFlow}';
  }
}

/// generated route for
/// [_i4.LicensePage]
class LicensePage extends _i9.PageRouteInfo<LicensePageArgs> {
  LicensePage(
      {_i4.Key? key,
      String? applicationName,
      String? applicationVersion,
      _i4.Widget? applicationIcon,
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

  final _i4.Key? key;

  final String? applicationName;

  final String? applicationVersion;

  final _i4.Widget? applicationIcon;

  final String? applicationLegalese;

  @override
  String toString() {
    return 'LicensePageArgs{key: $key, applicationName: $applicationName, applicationVersion: $applicationVersion, applicationIcon: $applicationIcon, applicationLegalese: $applicationLegalese}';
  }
}

/// generated route for
/// [_i5.MainView]
class Main extends _i9.PageRouteInfo<void> {
  const Main({List<_i9.PageRouteInfo>? children})
      : super(Main.name, path: '/', initialChildren: children);

  static const String name = 'Main';
}

/// generated route for
/// [_i6.HomeView]
class Home extends _i9.PageRouteInfo<HomeArgs> {
  Home(
      {_i4.Key? key,
      required void Function(int) onTabChange,
      required void Function(int) onYearChange,
      required void Function(void Function()) onListReloaderReady})
      : super(Home.name,
            path: 'home-view',
            args: HomeArgs(
                key: key,
                onTabChange: onTabChange,
                onYearChange: onYearChange,
                onListReloaderReady: onListReloaderReady));

  static const String name = 'Home';
}

class HomeArgs {
  const HomeArgs(
      {this.key,
      required this.onTabChange,
      required this.onYearChange,
      required this.onListReloaderReady});

  final _i4.Key? key;

  final void Function(int) onTabChange;

  final void Function(int) onYearChange;

  final void Function(void Function()) onListReloaderReady;

  @override
  String toString() {
    return 'HomeArgs{key: $key, onTabChange: $onTabChange, onYearChange: $onYearChange, onListReloaderReady: $onListReloaderReady}';
  }
}

/// generated route for
/// [_i7.ExploreView]
class Explore extends _i9.PageRouteInfo<void> {
  const Explore() : super(Explore.name, path: 'explore-view');

  static const String name = 'Explore';
}

/// generated route for
/// [_i8.SettingView]
class Setting extends _i9.PageRouteInfo<void> {
  const Setting() : super(Setting.name, path: 'setting-view');

  static const String name = 'Setting';
}
