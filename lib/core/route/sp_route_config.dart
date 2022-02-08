import 'package:flutter/material.dart';
import 'package:spooky/core/route/router.gr.dart';
import 'package:spooky/core/route/setting/animated_route_setting.dart';
import 'package:spooky/core/route/setting/base_route_setting.dart';
import 'package:spooky/core/route/setting/default_route_setting.dart';
import 'package:spooky/core/route/sp_page_route.dart';
import 'package:spooky/ui/views/archive/archive_view.dart';
import 'package:spooky/ui/views/changes_history/changes_history_view.dart';
import 'package:spooky/ui/views/content_reader/content_reader_view.dart';
import 'package:spooky/ui/views/detail/detail_view.dart';
import 'package:spooky/ui/views/explore/explore_view.dart';
import 'package:spooky/ui/views/home/home_view.dart';
import 'package:spooky/ui/views/main/main_view.dart';
import 'package:spooky/ui/views/manage_pages/manage_pages_view.dart';
import 'package:spooky/ui/views/setting/setting_view.dart';
import 'package:spooky/ui/views/theme_setting/theme_setting_view.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

export 'router.gr.dart';

class SpRouteConfig {
  final RouteSettings? settings;
  final BuildContext context;

  SpRouteConfig({
    required this.context,
    this.settings,
  });

  static const String themeSetting = ThemeSetting.name;
  static const String managePages = ManagePages.name;
  static const String archive = Archive.name;
  static const String contentReader = ContentReader.name;
  static const String changesHistory = ChangesHistory.name;
  static const String detail = Detail.name;
  static const String main = Main.name;
  static const String home = Home.name;
  static const String explore = Explore.name;
  static const String setting = Setting.name;
  static const String notFound = '/not-found';

  bool hasRoute(String name) => routes.containsKey(name);

  Route<dynamic> generate() {
    String? name = settings?.name;
    if (name == null || !hasRoute(name)) name = notFound;

    BaseRouteSetting? setting = routes[name];
    if (setting is DefaultRouteSetting) {
      switch (Theme.of(context).platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          return MaterialPageRoute(
            builder: setting.route,
            settings: settings?.copyWith(arguments: setting),
            fullscreenDialog: setting.fullscreenDialog,
          );
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          return SwipeablePageRoute(
            canSwipe: setting.canSwap,
            builder: setting.route,
            settings: settings?.copyWith(arguments: setting),
            fullscreenDialog: setting.fullscreenDialog,
          );
      }
    } else if (setting is AnimatedRouteSetting) {
      return SpPageRoute.sharedAxis(
        builder: setting.route,
        settings: settings?.copyWith(arguments: setting),
        fillColor: setting.fillColor,
        fullscreenDialog: setting.fullscreenDialog,
      );
    }

    return MaterialPageRoute(
      fullscreenDialog: true,
      settings: settings?.copyWith(arguments: routes[name]!),
      builder: (context) {
        return buildNotFound();
      },
    );
  }

  Map<String, BaseRouteSetting> get routes {
    return {
      themeSetting: DefaultRouteSetting(
        title: "Theme Setting",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) => ThemeSettingView(),
      ),
      managePages: DefaultRouteSetting(
        title: "Manage Pages",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is ManagePagesArgs) return ManagePagesView(content: arguments.content);
          return buildNotFound();
        },
      ),
      archive: DefaultRouteSetting(
        title: "Archive",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) => ArchiveView(),
      ),
      contentReader: DefaultRouteSetting(
        title: "Content Reader",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is ContentReaderArgs) return ContentReaderView(content: arguments.content);
          return buildNotFound();
        },
      ),
      changesHistory: DefaultRouteSetting(
        title: "Changes History",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is ChangesHistoryArgs) {
            return ChangesHistoryView(
              story: arguments.story,
              onRestorePressed: arguments.onRestorePressed,
              onDeletePressed: arguments.onDeletePressed,
            );
          }
          return buildNotFound();
        },
      ),
      detail: DefaultRouteSetting(
        title: "Detail",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is DetailArgs) {
            return DetailView(initialStory: arguments.initialStory, intialFlow: arguments.intialFlow);
          }
          return buildNotFound();
        },
      ),
      main: DefaultRouteSetting(
        title: "Main",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) => MainView(),
      ),
      home: DefaultRouteSetting(
        title: "Home",
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
          return buildNotFound();
        },
      ),
      explore: DefaultRouteSetting(
        title: "Explore",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) => ExploreView(),
      ),
      setting: DefaultRouteSetting(
        title: "Setting",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) => SettingView(),
      ),
      notFound: DefaultRouteSetting(
        title: "Not Found",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) => buildNotFound(),
      ),
    };
  }

  static Widget buildNotFound() {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Not found"),
      ),
    );
  }
}
