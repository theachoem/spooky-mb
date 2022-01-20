// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;

import '../../ui/views/archive/archive_view.dart' as _i1;
import '../../ui/views/changes_history/changes_history_view.dart' as _i3;
import '../../ui/views/content_reader/content_reader_view.dart' as _i2;
import '../../ui/views/detail/detail_view.dart' as _i4;
import '../../ui/views/detail/detail_view_model.dart' as _i13;
import '../../ui/views/explore/explore_view.dart' as _i7;
import '../../ui/views/home/home_view.dart' as _i6;
import '../../ui/views/main/main_view.dart' as _i5;
import '../../ui/views/setting/setting_view.dart' as _i8;
import '../models/story_content_model.dart' as _i11;
import '../models/story_model.dart' as _i12;

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    Archive.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.ArchiveView());
    },
    ContentReader.name: (routeData) {
      final args = routeData.argsAs<ContentReaderArgs>();
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i2.ContentReaderView(key: args.key, content: args.content),
          fullscreenDialog: true);
    },
    ChangesHistory.name: (routeData) {
      final args = routeData.argsAs<ChangesHistoryArgs>();
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.ChangesHistoryView(
              key: args.key,
              story: args.story,
              onRestorePressed: args.onRestorePressed,
              onDeletePressed: args.onDeletePressed));
    },
    Detail.name: (routeData) {
      final args = routeData.argsAs<DetailArgs>();
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i4.DetailView(
              key: args.key,
              initialStory: args.initialStory,
              intialFlow: args.intialFlow));
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
        _i9.RouteConfig(Archive.name, path: '/archive'),
        _i9.RouteConfig(ContentReader.name, path: '/content-reader'),
        _i9.RouteConfig(ChangesHistory.name, path: '/changes-sistory'),
        _i9.RouteConfig(Detail.name, path: '/detail'),
        _i9.RouteConfig(Main.name, path: '/', children: [
          _i9.RouteConfig(Home.name, path: 'home', parent: Main.name),
          _i9.RouteConfig(Explore.name, path: 'explore', parent: Main.name),
          _i9.RouteConfig(Setting.name, path: 'setting', parent: Main.name)
        ])
      ];
}

/// generated route for
/// [_i1.ArchiveView]
class Archive extends _i9.PageRouteInfo<void> {
  const Archive() : super(Archive.name, path: '/archive');

  static const String name = 'Archive';
}

/// generated route for
/// [_i2.ContentReaderView]
class ContentReader extends _i9.PageRouteInfo<ContentReaderArgs> {
  ContentReader({_i10.Key? key, required _i11.StoryContentModel content})
      : super(ContentReader.name,
            path: '/content-reader',
            args: ContentReaderArgs(key: key, content: content));

  static const String name = 'ContentReader';
}

class ContentReaderArgs {
  const ContentReaderArgs({this.key, required this.content});

  final _i10.Key? key;

  final _i11.StoryContentModel content;

  @override
  String toString() {
    return 'ContentReaderArgs{key: $key, content: $content}';
  }
}

/// generated route for
/// [_i3.ChangesHistoryView]
class ChangesHistory extends _i9.PageRouteInfo<ChangesHistoryArgs> {
  ChangesHistory(
      {_i10.Key? key,
      required _i12.StoryModel story,
      required void Function(_i11.StoryContentModel) onRestorePressed,
      required void Function(List<String>) onDeletePressed})
      : super(ChangesHistory.name,
            path: '/changes-sistory',
            args: ChangesHistoryArgs(
                key: key,
                story: story,
                onRestorePressed: onRestorePressed,
                onDeletePressed: onDeletePressed));

  static const String name = 'ChangesHistory';
}

class ChangesHistoryArgs {
  const ChangesHistoryArgs(
      {this.key,
      required this.story,
      required this.onRestorePressed,
      required this.onDeletePressed});

  final _i10.Key? key;

  final _i12.StoryModel story;

  final void Function(_i11.StoryContentModel) onRestorePressed;

  final void Function(List<String>) onDeletePressed;

  @override
  String toString() {
    return 'ChangesHistoryArgs{key: $key, story: $story, onRestorePressed: $onRestorePressed, onDeletePressed: $onDeletePressed}';
  }
}

/// generated route for
/// [_i4.DetailView]
class Detail extends _i9.PageRouteInfo<DetailArgs> {
  Detail(
      {_i10.Key? key,
      required _i12.StoryModel initialStory,
      required _i13.DetailViewFlow intialFlow})
      : super(Detail.name,
            path: '/detail',
            args: DetailArgs(
                key: key, initialStory: initialStory, intialFlow: intialFlow));

  static const String name = 'Detail';
}

class DetailArgs {
  const DetailArgs(
      {this.key, required this.initialStory, required this.intialFlow});

  final _i10.Key? key;

  final _i12.StoryModel initialStory;

  final _i13.DetailViewFlow intialFlow;

  @override
  String toString() {
    return 'DetailArgs{key: $key, initialStory: $initialStory, intialFlow: $intialFlow}';
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
      {_i10.Key? key,
      required void Function(int) onTabChange,
      required void Function(int) onYearChange,
      required void Function(void Function()) onListReloaderReady})
      : super(Home.name,
            path: 'home',
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

  final _i10.Key? key;

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
  const Explore() : super(Explore.name, path: 'explore');

  static const String name = 'Explore';
}

/// generated route for
/// [_i8.SettingView]
class Setting extends _i9.PageRouteInfo<void> {
  const Setting() : super(Setting.name, path: 'setting');

  static const String name = 'Setting';
}
