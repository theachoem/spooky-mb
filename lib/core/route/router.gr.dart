// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'dart:io' as _i11;

import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i5;

import '../../ui/views/archive/archive_view.dart' as _i1;
import '../../ui/views/detail/detail_view.dart' as _i3;
import '../../ui/views/explore/explore_view.dart' as _i8;
import '../../ui/views/file_manager/file_manager_view.dart' as _i4;
import '../../ui/views/file_viewer/file_viewer_view.dart' as _i2;
import '../../ui/views/home/home_view.dart' as _i7;
import '../../ui/views/main/main_view.dart' as _i6;
import '../../ui/views/setting/setting_view.dart' as _i9;
import '../models/story_model.dart' as _i12;

class AppRouter extends _i10.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    Archive.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.ArchiveView());
    },
    FileViewer.name: (routeData) {
      final args = routeData.argsAs<FileViewerArgs>();
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i2.FileViewerView(key: args.key, file: args.file));
    },
    Detail.name: (routeData) {
      final args = routeData.argsAs<DetailArgs>();
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.DetailView(key: args.key, story: args.story));
    },
    FileManager.name: (routeData) {
      final args = routeData.argsAs<FileManagerArgs>();
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i4.FileManagerView(
              key: args.key,
              directory: args.directory,
              fileManagerFlow: args.fileManagerFlow));
    },
    LicensePage.name: (routeData) {
      final args = routeData.argsAs<LicensePageArgs>(
          orElse: () => const LicensePageArgs());
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.LicensePage(
              key: args.key,
              applicationName: args.applicationName,
              applicationVersion: args.applicationVersion,
              applicationIcon: args.applicationIcon,
              applicationLegalese: args.applicationLegalese));
    },
    Main.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.MainView());
    },
    Home.name: (routeData) {
      final args = routeData.argsAs<HomeArgs>();
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i7.HomeView(
              key: args.key,
              onTabChange: args.onTabChange,
              onYearChange: args.onYearChange,
              onListReloaderReady: args.onListReloaderReady));
    },
    Explore.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i8.ExploreView());
    },
    Setting.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i9.SettingView());
    }
  };

  @override
  List<_i10.RouteConfig> get routes => [
        _i10.RouteConfig(Archive.name, path: '/archive-view'),
        _i10.RouteConfig(FileViewer.name, path: '/file-viewer-view'),
        _i10.RouteConfig(Detail.name, path: '/detail-view'),
        _i10.RouteConfig(FileManager.name, path: '/file-manager-view'),
        _i10.RouteConfig(LicensePage.name, path: '/license-page'),
        _i10.RouteConfig(Main.name, path: '/', children: [
          _i10.RouteConfig(Home.name, path: 'home-view', parent: Main.name),
          _i10.RouteConfig(Explore.name,
              path: 'explore-view', parent: Main.name),
          _i10.RouteConfig(Setting.name,
              path: 'setting-view', parent: Main.name)
        ])
      ];
}

/// generated route for
/// [_i1.ArchiveView]
class Archive extends _i10.PageRouteInfo<void> {
  const Archive() : super(Archive.name, path: '/archive-view');

  static const String name = 'Archive';
}

/// generated route for
/// [_i2.FileViewerView]
class FileViewer extends _i10.PageRouteInfo<FileViewerArgs> {
  FileViewer({_i5.Key? key, required _i11.File file})
      : super(FileViewer.name,
            path: '/file-viewer-view',
            args: FileViewerArgs(key: key, file: file));

  static const String name = 'FileViewer';
}

class FileViewerArgs {
  const FileViewerArgs({this.key, required this.file});

  final _i5.Key? key;

  final _i11.File file;

  @override
  String toString() {
    return 'FileViewerArgs{key: $key, file: $file}';
  }
}

/// generated route for
/// [_i3.DetailView]
class Detail extends _i10.PageRouteInfo<DetailArgs> {
  Detail({_i5.Key? key, required _i12.StoryModel story})
      : super(Detail.name,
            path: '/detail-view', args: DetailArgs(key: key, story: story));

  static const String name = 'Detail';
}

class DetailArgs {
  const DetailArgs({this.key, required this.story});

  final _i5.Key? key;

  final _i12.StoryModel story;

  @override
  String toString() {
    return 'DetailArgs{key: $key, story: $story}';
  }
}

/// generated route for
/// [_i4.FileManagerView]
class FileManager extends _i10.PageRouteInfo<FileManagerArgs> {
  FileManager(
      {_i5.Key? key,
      required _i11.Directory directory,
      _i4.FileManagerFlow fileManagerFlow = _i4.FileManagerFlow.explore})
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
      this.fileManagerFlow = _i4.FileManagerFlow.explore});

  final _i5.Key? key;

  final _i11.Directory directory;

  final _i4.FileManagerFlow fileManagerFlow;

  @override
  String toString() {
    return 'FileManagerArgs{key: $key, directory: $directory, fileManagerFlow: $fileManagerFlow}';
  }
}

/// generated route for
/// [_i5.LicensePage]
class LicensePage extends _i10.PageRouteInfo<LicensePageArgs> {
  LicensePage(
      {_i5.Key? key,
      String? applicationName,
      String? applicationVersion,
      _i5.Widget? applicationIcon,
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

  final _i5.Key? key;

  final String? applicationName;

  final String? applicationVersion;

  final _i5.Widget? applicationIcon;

  final String? applicationLegalese;

  @override
  String toString() {
    return 'LicensePageArgs{key: $key, applicationName: $applicationName, applicationVersion: $applicationVersion, applicationIcon: $applicationIcon, applicationLegalese: $applicationLegalese}';
  }
}

/// generated route for
/// [_i6.MainView]
class Main extends _i10.PageRouteInfo<void> {
  const Main({List<_i10.PageRouteInfo>? children})
      : super(Main.name, path: '/', initialChildren: children);

  static const String name = 'Main';
}

/// generated route for
/// [_i7.HomeView]
class Home extends _i10.PageRouteInfo<HomeArgs> {
  Home(
      {_i5.Key? key,
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

  final _i5.Key? key;

  final void Function(int) onTabChange;

  final void Function(int) onYearChange;

  final void Function(void Function()) onListReloaderReady;

  @override
  String toString() {
    return 'HomeArgs{key: $key, onTabChange: $onTabChange, onYearChange: $onYearChange, onListReloaderReady: $onListReloaderReady}';
  }
}

/// generated route for
/// [_i8.ExploreView]
class Explore extends _i10.PageRouteInfo<void> {
  const Explore() : super(Explore.name, path: 'explore-view');

  static const String name = 'Explore';
}

/// generated route for
/// [_i9.SettingView]
class Setting extends _i10.PageRouteInfo<void> {
  const Setting() : super(Setting.name, path: 'setting-view');

  static const String name = 'Setting';
}
