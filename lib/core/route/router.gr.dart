// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;

import '../../ui/views/changes_history/changes_history_view.dart' as _i2;
import '../../ui/views/content_reader/content_reader_view.dart' as _i1;
import '../../ui/views/detail/detail_view.dart' as _i3;
import '../../ui/views/detail/detail_view_model.dart' as _i12;
import '../../ui/views/explore/explore_view.dart' as _i6;
import '../../ui/views/home/home_view.dart' as _i5;
import '../../ui/views/main/main_view.dart' as _i4;
import '../../ui/views/setting/setting_view.dart' as _i7;
import '../models/story_content_model.dart' as _i10;
import '../models/story_model.dart' as _i11;

class AppRouter extends _i8.RootStackRouter {
  AppRouter([_i9.GlobalKey<_i9.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    ContentReader.name: (routeData) {
      final args = routeData.argsAs<ContentReaderArgs>();
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i1.ContentReaderView(key: args.key, content: args.content));
    },
    ChangeHistory.name: (routeData) {
      final args = routeData.argsAs<ChangeHistoryArgs>();
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i2.ChangesHistoryView(key: args.key, story: args.story));
    },
    Detail.name: (routeData) {
      final args = routeData.argsAs<DetailArgs>();
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.DetailView(
              key: args.key,
              initialStory: args.initialStory,
              intialFlow: args.intialFlow));
    },
    Main.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.MainView());
    },
    Home.name: (routeData) {
      final args = routeData.argsAs<HomeArgs>();
      return _i8.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.HomeView(
              key: args.key,
              onTabChange: args.onTabChange,
              onYearChange: args.onYearChange,
              onListReloaderReady: args.onListReloaderReady));
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
        _i8.RouteConfig(ContentReader.name, path: '/content-reader-view'),
        _i8.RouteConfig(ChangeHistory.name, path: '/changes-history-view'),
        _i8.RouteConfig(Detail.name, path: '/detail-view'),
        _i8.RouteConfig(Main.name, path: '/', children: [
          _i8.RouteConfig(Home.name, path: 'home-view', parent: Main.name),
          _i8.RouteConfig(Explore.name,
              path: 'explore-view', parent: Main.name),
          _i8.RouteConfig(Setting.name, path: 'setting-view', parent: Main.name)
        ])
      ];
}

/// generated route for
/// [_i1.ContentReaderView]
class ContentReader extends _i8.PageRouteInfo<ContentReaderArgs> {
  ContentReader({_i9.Key? key, required _i10.StoryContentModel content})
      : super(ContentReader.name,
            path: '/content-reader-view',
            args: ContentReaderArgs(key: key, content: content));

  static const String name = 'ContentReader';
}

class ContentReaderArgs {
  const ContentReaderArgs({this.key, required this.content});

  final _i9.Key? key;

  final _i10.StoryContentModel content;

  @override
  String toString() {
    return 'ContentReaderArgs{key: $key, content: $content}';
  }
}

/// generated route for
/// [_i2.ChangesHistoryView]
class ChangeHistory extends _i8.PageRouteInfo<ChangeHistoryArgs> {
  ChangeHistory({_i9.Key? key, required _i11.StoryModel story})
      : super(ChangeHistory.name,
            path: '/changes-history-view',
            args: ChangeHistoryArgs(key: key, story: story));

  static const String name = 'ChangeHistory';
}

class ChangeHistoryArgs {
  const ChangeHistoryArgs({this.key, required this.story});

  final _i9.Key? key;

  final _i11.StoryModel story;

  @override
  String toString() {
    return 'ChangeHistoryArgs{key: $key, story: $story}';
  }
}

/// generated route for
/// [_i3.DetailView]
class Detail extends _i8.PageRouteInfo<DetailArgs> {
  Detail(
      {_i9.Key? key,
      required _i11.StoryModel initialStory,
      required _i12.DetailViewFlow intialFlow})
      : super(Detail.name,
            path: '/detail-view',
            args: DetailArgs(
                key: key, initialStory: initialStory, intialFlow: intialFlow));

  static const String name = 'Detail';
}

class DetailArgs {
  const DetailArgs(
      {this.key, required this.initialStory, required this.intialFlow});

  final _i9.Key? key;

  final _i11.StoryModel initialStory;

  final _i12.DetailViewFlow intialFlow;

  @override
  String toString() {
    return 'DetailArgs{key: $key, initialStory: $initialStory, intialFlow: $intialFlow}';
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
  Home(
      {_i9.Key? key,
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

  final _i9.Key? key;

  final void Function(int) onTabChange;

  final void Function(int) onYearChange;

  final void Function(void Function()) onListReloaderReady;

  @override
  String toString() {
    return 'HomeArgs{key: $key, onTabChange: $onTabChange, onYearChange: $onYearChange, onListReloaderReady: $onListReloaderReady}';
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
