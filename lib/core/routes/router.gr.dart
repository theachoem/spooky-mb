// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'dart:async' as _i24;

import 'package:auto_route/auto_route.dart' as _i19;
import 'package:flutter/material.dart' as _i20;

import '../../views/app_starter/app_starter_view.dart' as _i8;
import '../../views/archive/archive_view.dart' as _i11;
import '../../views/changes_history/changes_history_view.dart' as _i13;
import '../../views/content_reader/content_reader_view.dart' as _i12;
import '../../views/detail/detail_view.dart' as _i14;
import '../../views/developer_mode/developer_mode_view.dart' as _i5;
import '../../views/explore/explore_view.dart' as _i17;
import '../../views/font_manager/font_manager_view.dart' as _i2;
import '../../views/home/home_view.dart' as _i16;
import '../../views/init_pick_color/init_pick_color_view.dart' as _i7;
import '../../views/lock/lock_view.dart' as _i3;
import '../../views/lock/types/lock_flow_type.dart' as _i21;
import '../../views/main/main_view.dart' as _i15;
import '../../views/manage_pages/manage_pages_view.dart' as _i10;
import '../../views/nickname_creator/nickname_creator_view.dart' as _i6;
import '../../views/restore/restore_view.dart' as _i1;
import '../../views/security/security_view.dart' as _i4;
import '../../views/setting/setting_view.dart' as _i18;
import '../../views/theme_setting/theme_setting_view.dart' as _i9;
import '../db/models/story_content_db_model.dart' as _i22;
import '../db/models/story_db_model.dart' as _i23;
import '../types/detail_view_flow_type.dart' as _i25;

class AppRouter extends _i19.RootStackRouter {
  AppRouter([_i20.GlobalKey<_i20.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i19.PageFactory> pagesMap = {
    Restore.name: (routeData) {
      final args = routeData.argsAs<RestoreArgs>();
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i1.RestoreView(
              key: args.key, showSkipButton: args.showSkipButton));
    },
    FontManager.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.FontManagerView());
    },
    Lock.name: (routeData) {
      final args = routeData.argsAs<LockArgs>();
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.LockView(key: args.key, flowType: args.flowType));
    },
    Security.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.SecurityView());
    },
    DeveloperMode.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.DeveloperModeView());
    },
    NicknameCreator.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.NicknameCreatorView());
    },
    InitPickColor.name: (routeData) {
      final args = routeData.argsAs<InitPickColorArgs>();
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i7.InitPickColorView(
              key: args.key, showNextButton: args.showNextButton));
    },
    AppStarter.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i8.AppStarterView());
    },
    ThemeSetting.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i9.ThemeSettingView());
    },
    ManagePages.name: (routeData) {
      final args = routeData.argsAs<ManagePagesArgs>();
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i10.ManagePagesView(key: args.key, content: args.content),
          fullscreenDialog: true);
    },
    Archive.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i11.ArchiveView());
    },
    ContentReader.name: (routeData) {
      final args = routeData.argsAs<ContentReaderArgs>();
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i12.ContentReaderView(key: args.key, content: args.content),
          fullscreenDialog: true);
    },
    ChangesHistory.name: (routeData) {
      final args = routeData.argsAs<ChangesHistoryArgs>();
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i13.ChangesHistoryView(
              key: args.key,
              story: args.story,
              onRestorePressed: args.onRestorePressed,
              onDeletePressed: args.onDeletePressed));
    },
    Detail.name: (routeData) {
      final args = routeData.argsAs<DetailArgs>();
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i14.DetailView(
              key: args.key,
              initialStory: args.initialStory,
              intialFlow: args.intialFlow));
    },
    Main.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i15.MainView());
    },
    Home.name: (routeData) {
      final args = routeData.argsAs<HomeArgs>();
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i16.HomeView(
              key: args.key,
              onTabChange: args.onTabChange,
              onYearChange: args.onYearChange,
              onScrollControllerReady: args.onScrollControllerReady));
    },
    Explore.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i17.ExploreView());
    },
    Setting.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i18.SettingView());
    }
  };

  @override
  List<_i19.RouteConfig> get routes => [
        _i19.RouteConfig(Restore.name, path: '/restore-view'),
        _i19.RouteConfig(FontManager.name, path: '/font-manager-view'),
        _i19.RouteConfig(Lock.name, path: '/lock-view'),
        _i19.RouteConfig(Security.name, path: '/security-view'),
        _i19.RouteConfig(DeveloperMode.name, path: '/developer-mode-view'),
        _i19.RouteConfig(NicknameCreator.name, path: '/nickname-creator-view'),
        _i19.RouteConfig(InitPickColor.name, path: '/init-pick-color-view'),
        _i19.RouteConfig(AppStarter.name, path: '/app-starter-view'),
        _i19.RouteConfig(ThemeSetting.name, path: '/theme-setting-view'),
        _i19.RouteConfig(ManagePages.name, path: '/manage-pages-view'),
        _i19.RouteConfig(Archive.name, path: '/archive-view'),
        _i19.RouteConfig(ContentReader.name, path: '/content-reader-view'),
        _i19.RouteConfig(ChangesHistory.name, path: '/changes-history-view'),
        _i19.RouteConfig(Detail.name, path: '/detail-view'),
        _i19.RouteConfig(Main.name, path: '/', children: [
          _i19.RouteConfig(Home.name, path: 'home', parent: Main.name),
          _i19.RouteConfig(Explore.name, path: 'explore', parent: Main.name),
          _i19.RouteConfig(Setting.name, path: 'setting', parent: Main.name)
        ])
      ];
}

/// generated route for
/// [_i1.RestoreView]
class Restore extends _i19.PageRouteInfo<RestoreArgs> {
  Restore({_i20.Key? key, required bool showSkipButton})
      : super(Restore.name,
            path: '/restore-view',
            args: RestoreArgs(key: key, showSkipButton: showSkipButton));

  static const String name = 'Restore';
}

class RestoreArgs {
  const RestoreArgs({this.key, required this.showSkipButton});

  final _i20.Key? key;

  final bool showSkipButton;

  @override
  String toString() {
    return 'RestoreArgs{key: $key, showSkipButton: $showSkipButton}';
  }
}

/// generated route for
/// [_i2.FontManagerView]
class FontManager extends _i19.PageRouteInfo<void> {
  const FontManager() : super(FontManager.name, path: '/font-manager-view');

  static const String name = 'FontManager';
}

/// generated route for
/// [_i3.LockView]
class Lock extends _i19.PageRouteInfo<LockArgs> {
  Lock({_i20.Key? key, required _i21.LockFlowType flowType})
      : super(Lock.name,
            path: '/lock-view', args: LockArgs(key: key, flowType: flowType));

  static const String name = 'Lock';
}

class LockArgs {
  const LockArgs({this.key, required this.flowType});

  final _i20.Key? key;

  final _i21.LockFlowType flowType;

  @override
  String toString() {
    return 'LockArgs{key: $key, flowType: $flowType}';
  }
}

/// generated route for
/// [_i4.SecurityView]
class Security extends _i19.PageRouteInfo<void> {
  const Security() : super(Security.name, path: '/security-view');

  static const String name = 'Security';
}

/// generated route for
/// [_i5.DeveloperModeView]
class DeveloperMode extends _i19.PageRouteInfo<void> {
  const DeveloperMode()
      : super(DeveloperMode.name, path: '/developer-mode-view');

  static const String name = 'DeveloperMode';
}

/// generated route for
/// [_i6.NicknameCreatorView]
class NicknameCreator extends _i19.PageRouteInfo<void> {
  const NicknameCreator()
      : super(NicknameCreator.name, path: '/nickname-creator-view');

  static const String name = 'NicknameCreator';
}

/// generated route for
/// [_i7.InitPickColorView]
class InitPickColor extends _i19.PageRouteInfo<InitPickColorArgs> {
  InitPickColor({_i20.Key? key, required bool showNextButton})
      : super(InitPickColor.name,
            path: '/init-pick-color-view',
            args: InitPickColorArgs(key: key, showNextButton: showNextButton));

  static const String name = 'InitPickColor';
}

class InitPickColorArgs {
  const InitPickColorArgs({this.key, required this.showNextButton});

  final _i20.Key? key;

  final bool showNextButton;

  @override
  String toString() {
    return 'InitPickColorArgs{key: $key, showNextButton: $showNextButton}';
  }
}

/// generated route for
/// [_i8.AppStarterView]
class AppStarter extends _i19.PageRouteInfo<void> {
  const AppStarter() : super(AppStarter.name, path: '/app-starter-view');

  static const String name = 'AppStarter';
}

/// generated route for
/// [_i9.ThemeSettingView]
class ThemeSetting extends _i19.PageRouteInfo<void> {
  const ThemeSetting() : super(ThemeSetting.name, path: '/theme-setting-view');

  static const String name = 'ThemeSetting';
}

/// generated route for
/// [_i10.ManagePagesView]
class ManagePages extends _i19.PageRouteInfo<ManagePagesArgs> {
  ManagePages({_i20.Key? key, required _i22.StoryContentDbModel content})
      : super(ManagePages.name,
            path: '/manage-pages-view',
            args: ManagePagesArgs(key: key, content: content));

  static const String name = 'ManagePages';
}

class ManagePagesArgs {
  const ManagePagesArgs({this.key, required this.content});

  final _i20.Key? key;

  final _i22.StoryContentDbModel content;

  @override
  String toString() {
    return 'ManagePagesArgs{key: $key, content: $content}';
  }
}

/// generated route for
/// [_i11.ArchiveView]
class Archive extends _i19.PageRouteInfo<void> {
  const Archive() : super(Archive.name, path: '/archive-view');

  static const String name = 'Archive';
}

/// generated route for
/// [_i12.ContentReaderView]
class ContentReader extends _i19.PageRouteInfo<ContentReaderArgs> {
  ContentReader({_i20.Key? key, required _i22.StoryContentDbModel content})
      : super(ContentReader.name,
            path: '/content-reader-view',
            args: ContentReaderArgs(key: key, content: content));

  static const String name = 'ContentReader';
}

class ContentReaderArgs {
  const ContentReaderArgs({this.key, required this.content});

  final _i20.Key? key;

  final _i22.StoryContentDbModel content;

  @override
  String toString() {
    return 'ContentReaderArgs{key: $key, content: $content}';
  }
}

/// generated route for
/// [_i13.ChangesHistoryView]
class ChangesHistory extends _i19.PageRouteInfo<ChangesHistoryArgs> {
  ChangesHistory(
      {_i20.Key? key,
      required _i23.StoryDbModel story,
      required void Function(_i22.StoryContentDbModel) onRestorePressed,
      required _i24.Future<_i23.StoryDbModel> Function(List<int>)
          onDeletePressed})
      : super(ChangesHistory.name,
            path: '/changes-history-view',
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

  final _i20.Key? key;

  final _i23.StoryDbModel story;

  final void Function(_i22.StoryContentDbModel) onRestorePressed;

  final _i24.Future<_i23.StoryDbModel> Function(List<int>) onDeletePressed;

  @override
  String toString() {
    return 'ChangesHistoryArgs{key: $key, story: $story, onRestorePressed: $onRestorePressed, onDeletePressed: $onDeletePressed}';
  }
}

/// generated route for
/// [_i14.DetailView]
class Detail extends _i19.PageRouteInfo<DetailArgs> {
  Detail(
      {_i20.Key? key,
      required _i23.StoryDbModel initialStory,
      required _i25.DetailViewFlowType intialFlow})
      : super(Detail.name,
            path: '/detail-view',
            args: DetailArgs(
                key: key, initialStory: initialStory, intialFlow: intialFlow));

  static const String name = 'Detail';
}

class DetailArgs {
  const DetailArgs(
      {this.key, required this.initialStory, required this.intialFlow});

  final _i20.Key? key;

  final _i23.StoryDbModel initialStory;

  final _i25.DetailViewFlowType intialFlow;

  @override
  String toString() {
    return 'DetailArgs{key: $key, initialStory: $initialStory, intialFlow: $intialFlow}';
  }
}

/// generated route for
/// [_i15.MainView]
class Main extends _i19.PageRouteInfo<void> {
  const Main({List<_i19.PageRouteInfo>? children})
      : super(Main.name, path: '/', initialChildren: children);

  static const String name = 'Main';
}

/// generated route for
/// [_i16.HomeView]
class Home extends _i19.PageRouteInfo<HomeArgs> {
  Home(
      {_i20.Key? key,
      required void Function(int) onTabChange,
      required void Function(int) onYearChange,
      required void Function(_i20.ScrollController) onScrollControllerReady})
      : super(Home.name,
            path: 'home',
            args: HomeArgs(
                key: key,
                onTabChange: onTabChange,
                onYearChange: onYearChange,
                onScrollControllerReady: onScrollControllerReady));

  static const String name = 'Home';
}

class HomeArgs {
  const HomeArgs(
      {this.key,
      required this.onTabChange,
      required this.onYearChange,
      required this.onScrollControllerReady});

  final _i20.Key? key;

  final void Function(int) onTabChange;

  final void Function(int) onYearChange;

  final void Function(_i20.ScrollController) onScrollControllerReady;

  @override
  String toString() {
    return 'HomeArgs{key: $key, onTabChange: $onTabChange, onYearChange: $onYearChange, onScrollControllerReady: $onScrollControllerReady}';
  }
}

/// generated route for
/// [_i17.ExploreView]
class Explore extends _i19.PageRouteInfo<void> {
  const Explore() : super(Explore.name, path: 'explore');

  static const String name = 'Explore';
}

/// generated route for
/// [_i18.SettingView]
class Setting extends _i19.PageRouteInfo<void> {
  const Setting() : super(Setting.name, path: 'setting');

  static const String name = 'Setting';
}
