// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i15;
import 'package:flutter/material.dart' as _i16;

import '../../ui/views/app_starter/app_starter_view.dart' as _i4;
import '../../ui/views/archive/archive_view.dart' as _i7;
import '../../ui/views/changes_history/changes_history_view.dart' as _i9;
import '../../ui/views/content_reader/content_reader_view.dart' as _i8;
import '../../ui/views/detail/detail_view.dart' as _i10;
import '../../ui/views/detail/detail_view_model.dart' as _i19;
import '../../ui/views/developer_mode/developer_mode_view.dart' as _i1;
import '../../ui/views/explore/explore_view.dart' as _i13;
import '../../ui/views/home/home_view.dart' as _i12;
import '../../ui/views/init_pick_color/init_pick_color_view.dart' as _i3;
import '../../ui/views/main/main_view.dart' as _i11;
import '../../ui/views/manage_pages/manage_pages_view.dart' as _i6;
import '../../ui/views/nickname_creator/nickname_creator_view.dart' as _i2;
import '../../ui/views/setting/setting_view.dart' as _i14;
import '../../ui/views/theme_setting/theme_setting_view.dart' as _i5;
import '../models/story_content_model.dart' as _i17;
import '../models/story_model.dart' as _i18;

class AppRouter extends _i15.RootStackRouter {
  AppRouter([_i16.GlobalKey<_i16.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i15.PageFactory> pagesMap = {
    DeveloperMode.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.DeveloperModeView());
    },
    NicknameCreator.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.NicknameCreatorView());
    },
    InitPickColor.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.InitPickColorView());
    },
    AppStarter.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.AppStarterView());
    },
    ThemeSetting.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.ThemeSettingView());
    },
    ManagePages.name: (routeData) {
      final args = routeData.argsAs<ManagePagesArgs>();
      return _i15.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i6.ManagePagesView(key: args.key, content: args.content),
          fullscreenDialog: true);
    },
    Archive.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i7.ArchiveView());
    },
    ContentReader.name: (routeData) {
      final args = routeData.argsAs<ContentReaderArgs>();
      return _i15.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i8.ContentReaderView(key: args.key, content: args.content),
          fullscreenDialog: true);
    },
    ChangesHistory.name: (routeData) {
      final args = routeData.argsAs<ChangesHistoryArgs>();
      return _i15.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i9.ChangesHistoryView(
              key: args.key,
              story: args.story,
              onRestorePressed: args.onRestorePressed,
              onDeletePressed: args.onDeletePressed));
    },
    Detail.name: (routeData) {
      final args = routeData.argsAs<DetailArgs>();
      return _i15.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i10.DetailView(
              key: args.key,
              initialStory: args.initialStory,
              intialFlow: args.intialFlow));
    },
    Main.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i11.MainView());
    },
    Home.name: (routeData) {
      final args = routeData.argsAs<HomeArgs>();
      return _i15.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i12.HomeView(
              key: args.key,
              onTabChange: args.onTabChange,
              onYearChange: args.onYearChange,
              onListReloaderReady: args.onListReloaderReady));
    },
    Explore.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i13.ExploreView());
    },
    Setting.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i14.SettingView());
    }
  };

  @override
  List<_i15.RouteConfig> get routes => [
        _i15.RouteConfig('/#redirect',
            path: '/', redirectTo: '/main', fullMatch: true),
        _i15.RouteConfig(DeveloperMode.name, path: '/developer-mode-view'),
        _i15.RouteConfig(NicknameCreator.name,
            path: '/landing/nickname-creator'),
        _i15.RouteConfig(InitPickColor.name, path: '/landing/init-pick-color'),
        _i15.RouteConfig(AppStarter.name, path: 'landing/app-starter'),
        _i15.RouteConfig(ThemeSetting.name, path: '/theme-setting'),
        _i15.RouteConfig(ManagePages.name, path: '/manage-pages'),
        _i15.RouteConfig(Archive.name, path: '/archive'),
        _i15.RouteConfig(ContentReader.name, path: '/content-reader'),
        _i15.RouteConfig(ChangesHistory.name, path: '/changes-history'),
        _i15.RouteConfig(Detail.name, path: '/detail'),
        _i15.RouteConfig(Main.name, path: '/main', children: [
          _i15.RouteConfig(Home.name, path: 'home', parent: Main.name),
          _i15.RouteConfig(Explore.name, path: 'explore', parent: Main.name),
          _i15.RouteConfig(Setting.name, path: 'setting', parent: Main.name)
        ])
      ];
}

/// generated route for
/// [_i1.DeveloperModeView]
class DeveloperMode extends _i15.PageRouteInfo<void> {
  const DeveloperMode()
      : super(DeveloperMode.name, path: '/developer-mode-view');

  static const String name = 'DeveloperMode';
}

/// generated route for
/// [_i2.NicknameCreatorView]
class NicknameCreator extends _i15.PageRouteInfo<void> {
  const NicknameCreator()
      : super(NicknameCreator.name, path: '/landing/nickname-creator');

  static const String name = 'NicknameCreator';
}

/// generated route for
/// [_i3.InitPickColorView]
class InitPickColor extends _i15.PageRouteInfo<void> {
  const InitPickColor()
      : super(InitPickColor.name, path: '/landing/init-pick-color');

  static const String name = 'InitPickColor';
}

/// generated route for
/// [_i4.AppStarterView]
class AppStarter extends _i15.PageRouteInfo<void> {
  const AppStarter() : super(AppStarter.name, path: 'landing/app-starter');

  static const String name = 'AppStarter';
}

/// generated route for
/// [_i5.ThemeSettingView]
class ThemeSetting extends _i15.PageRouteInfo<void> {
  const ThemeSetting() : super(ThemeSetting.name, path: '/theme-setting');

  static const String name = 'ThemeSetting';
}

/// generated route for
/// [_i6.ManagePagesView]
class ManagePages extends _i15.PageRouteInfo<ManagePagesArgs> {
  ManagePages({_i16.Key? key, required _i17.StoryContentModel content})
      : super(ManagePages.name,
            path: '/manage-pages',
            args: ManagePagesArgs(key: key, content: content));

  static const String name = 'ManagePages';
}

class ManagePagesArgs {
  const ManagePagesArgs({this.key, required this.content});

  final _i16.Key? key;

  final _i17.StoryContentModel content;

  @override
  String toString() {
    return 'ManagePagesArgs{key: $key, content: $content}';
  }
}

/// generated route for
/// [_i7.ArchiveView]
class Archive extends _i15.PageRouteInfo<void> {
  const Archive() : super(Archive.name, path: '/archive');

  static const String name = 'Archive';
}

/// generated route for
/// [_i8.ContentReaderView]
class ContentReader extends _i15.PageRouteInfo<ContentReaderArgs> {
  ContentReader({_i16.Key? key, required _i17.StoryContentModel content})
      : super(ContentReader.name,
            path: '/content-reader',
            args: ContentReaderArgs(key: key, content: content));

  static const String name = 'ContentReader';
}

class ContentReaderArgs {
  const ContentReaderArgs({this.key, required this.content});

  final _i16.Key? key;

  final _i17.StoryContentModel content;

  @override
  String toString() {
    return 'ContentReaderArgs{key: $key, content: $content}';
  }
}

/// generated route for
/// [_i9.ChangesHistoryView]
class ChangesHistory extends _i15.PageRouteInfo<ChangesHistoryArgs> {
  ChangesHistory(
      {_i16.Key? key,
      required _i18.StoryModel story,
      required void Function(_i17.StoryContentModel) onRestorePressed,
      required void Function(List<String>) onDeletePressed})
      : super(ChangesHistory.name,
            path: '/changes-history',
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

  final _i16.Key? key;

  final _i18.StoryModel story;

  final void Function(_i17.StoryContentModel) onRestorePressed;

  final void Function(List<String>) onDeletePressed;

  @override
  String toString() {
    return 'ChangesHistoryArgs{key: $key, story: $story, onRestorePressed: $onRestorePressed, onDeletePressed: $onDeletePressed}';
  }
}

/// generated route for
/// [_i10.DetailView]
class Detail extends _i15.PageRouteInfo<DetailArgs> {
  Detail(
      {_i16.Key? key,
      required _i18.StoryModel initialStory,
      required _i19.DetailViewFlow intialFlow})
      : super(Detail.name,
            path: '/detail',
            args: DetailArgs(
                key: key, initialStory: initialStory, intialFlow: intialFlow));

  static const String name = 'Detail';
}

class DetailArgs {
  const DetailArgs(
      {this.key, required this.initialStory, required this.intialFlow});

  final _i16.Key? key;

  final _i18.StoryModel initialStory;

  final _i19.DetailViewFlow intialFlow;

  @override
  String toString() {
    return 'DetailArgs{key: $key, initialStory: $initialStory, intialFlow: $intialFlow}';
  }
}

/// generated route for
/// [_i11.MainView]
class Main extends _i15.PageRouteInfo<void> {
  const Main({List<_i15.PageRouteInfo>? children})
      : super(Main.name, path: '/main', initialChildren: children);

  static const String name = 'Main';
}

/// generated route for
/// [_i12.HomeView]
class Home extends _i15.PageRouteInfo<HomeArgs> {
  Home(
      {_i16.Key? key,
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

  final _i16.Key? key;

  final void Function(int) onTabChange;

  final void Function(int) onYearChange;

  final void Function(void Function()) onListReloaderReady;

  @override
  String toString() {
    return 'HomeArgs{key: $key, onTabChange: $onTabChange, onYearChange: $onYearChange, onListReloaderReady: $onListReloaderReady}';
  }
}

/// generated route for
/// [_i13.ExploreView]
class Explore extends _i15.PageRouteInfo<void> {
  const Explore() : super(Explore.name, path: 'explore');

  static const String name = 'Explore';
}

/// generated route for
/// [_i14.SettingView]
class Setting extends _i15.PageRouteInfo<void> {
  const Setting() : super(Setting.name, path: 'setting');

  static const String name = 'Setting';
}
