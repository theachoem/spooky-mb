import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/views/main/main_view_item.dart';

extension SpRouterExtension on SpRouter {
  String get path {
    switch (this) {
      case SpRouter.cloudStorages:
        return '/cloud-storages';
      case SpRouter.backupsDetails:
        return '/backups-detail';
      case SpRouter.fontManager:
        return '/font-manager';
      case SpRouter.lock:
        return '/lock';
      case SpRouter.security:
        return '/security';
      case SpRouter.themeSetting:
        return '/theme-setting';
      case SpRouter.managePages:
        return '/manage-pages';
      case SpRouter.archive:
        return '/archive';
      case SpRouter.contentReader:
        return '/content-reader';
      case SpRouter.changesHistory:
        return '/changes-history';
      case SpRouter.detail:
        return '/detail';
      case SpRouter.main:
        return '/main';
      case SpRouter.home:
        return '/home';
      case SpRouter.explore:
        return '/explore';
      case SpRouter.setting:
        return '/setting';
      case SpRouter.appStarter:
        return '/landing/app-starter';
      case SpRouter.initPickColor:
        return '/landing/init-pick-color';
      case SpRouter.nicknameCreator:
        return '/landing/nickname-creator';
      case SpRouter.developerMode:
        return '/developer-mode';
      case SpRouter.notFound:
        return '/not-found';
      case SpRouter.addOn:
        return "/add-ons";
      case SpRouter.soundList:
        return "/sounds";
      case SpRouter.bottomNavSetting:
        return "/bottom-nav-setting";
      case SpRouter.storyPadRestore:
        return '/storypad-restore';
      case SpRouter.user:
        return '/user';
      case SpRouter.signUp:
        return '/sign-up';
      case SpRouter.search:
        return '/search';
    }
  }

  String get title {
    switch (this) {
      case SpRouter.backupsDetails:
        return 'Backups';
      case SpRouter.cloudStorages:
        return 'Cloud Storage';
      case SpRouter.fontManager:
        return 'Font Book';
      case SpRouter.lock:
        return 'Lock';
      case SpRouter.security:
        return 'Security';
      case SpRouter.themeSetting:
        return 'Theme';
      case SpRouter.managePages:
        return 'Manage pages';
      case SpRouter.archive:
        return 'Archive';
      case SpRouter.contentReader:
        return 'Content Reader';
      case SpRouter.changesHistory:
        return 'Changes History';
      case SpRouter.detail:
        return 'Detail';
      case SpRouter.main:
        return 'Main';
      case SpRouter.home:
        return 'Home';
      case SpRouter.explore:
        return 'Explore';
      case SpRouter.setting:
        return 'Setting';
      case SpRouter.appStarter:
        return 'App Starter';
      case SpRouter.initPickColor:
        return 'Favorite color';
      case SpRouter.nicknameCreator:
        return 'Nickname Creator';
      case SpRouter.developerMode:
        return 'Developer';
      case SpRouter.notFound:
        return 'Not Found';
      case SpRouter.addOn:
        return 'Add-ons';
      case SpRouter.soundList:
        return "Sounds";
      case SpRouter.bottomNavSetting:
        return "Bottom Navigation";
      case SpRouter.storyPadRestore:
        return "StoryPad";
      case SpRouter.user:
        return "User";
      case SpRouter.signUp:
        return 'Sign up';
      case SpRouter.search:
        return 'Search';
    }
  }

  String get subtitle {
    switch (this) {
      case SpRouter.cloudStorages:
        return 'Backup & Restore with cloud storages';
      case SpRouter.backupsDetails:
        return 'Backups Details';
      case SpRouter.fontManager:
        return 'Font Book';
      case SpRouter.lock:
        return 'Lock';
      case SpRouter.security:
        return 'Security';
      case SpRouter.themeSetting:
        return 'Theme';
      case SpRouter.managePages:
        return 'Manage pages';
      case SpRouter.archive:
        return 'Archive';
      case SpRouter.contentReader:
        return 'Content Reader';
      case SpRouter.changesHistory:
        return 'Changes History';
      case SpRouter.detail:
        return 'Detail';
      case SpRouter.main:
        return 'Main';
      case SpRouter.home:
        return 'Home';
      case SpRouter.explore:
        return 'Explore';
      case SpRouter.setting:
        return 'Setting';
      case SpRouter.appStarter:
        return 'App Starter';
      case SpRouter.initPickColor:
        return 'Pick one of your favorite color';
      case SpRouter.nicknameCreator:
        return 'Nickname Creator';
      case SpRouter.developerMode:
        return 'Developer';
      case SpRouter.notFound:
        return 'Not Found';
      case SpRouter.addOn:
        return 'Add more lifetime access functionalities';
      case SpRouter.soundList:
        return "Sounds";
      case SpRouter.bottomNavSetting:
        return "Manage bottom navigation";
      case SpRouter.storyPadRestore:
        return "StoryPad";
      case SpRouter.user:
        return "Account is mainly used to store purchased histories.";
      case SpRouter.signUp:
        return 'Sign up';
      case SpRouter.search:
        return 'Search';
    }
  }

  MainTabBarItem? get tab {
    switch (this) {
      case SpRouter.managePages:
      case SpRouter.contentReader:
      case SpRouter.changesHistory:
      case SpRouter.detail:
      case SpRouter.main:
      case SpRouter.lock:
      case SpRouter.appStarter:
      case SpRouter.initPickColor:
      case SpRouter.nicknameCreator:
      case SpRouter.developerMode:
      case SpRouter.notFound:
      case SpRouter.bottomNavSetting:
      case SpRouter.storyPadRestore:
      case SpRouter.backupsDetails:
      case SpRouter.signUp:
      case SpRouter.search:
        return null;
      case SpRouter.home:
        return MainTabBarItem(
          navigatorKey: GlobalKey<NavigatorState>(),
          router: SpRouter.home,
          inactiveIcon: Icons.home_outlined,
          activeIcon: Icons.home,
          optinal: false,
        );
      case SpRouter.setting:
        return MainTabBarItem(
          navigatorKey: GlobalKey<NavigatorState>(),
          router: SpRouter.setting,
          inactiveIcon: Icons.settings_outlined,
          activeIcon: Icons.settings,
          optinal: false,
        );
      case SpRouter.cloudStorages:
        return MainTabBarItem(
          navigatorKey: GlobalKey<NavigatorState>(),
          router: SpRouter.cloudStorages,
          inactiveIcon: Icons.cloud_outlined,
          activeIcon: Icons.cloud,
        );
      case SpRouter.user:
        return null;
      // return MainTabBarItem(
      //   navigatorKey: GlobalKey<NavigatorState>(),
      //   router: SpRouter.user,
      //   inactiveIcon: Icons.person_outline,
      //   activeIcon: Icons.person,
      // );
      case SpRouter.fontManager:
        return null;
      // return MainTabBarItem(
      //   navigatorKey: GlobalKey<NavigatorState>(),
      //   router: SpRouter.fontManager,
      //   inactiveIcon: Icons.font_download_outlined,
      //   activeIcon: Icons.font_download,
      // );
      case SpRouter.security:
        return MainTabBarItem(
          navigatorKey: GlobalKey<NavigatorState>(),
          router: SpRouter.security,
          inactiveIcon: Icons.security_outlined,
          activeIcon: Icons.security,
        );
      case SpRouter.themeSetting:
        return MainTabBarItem(
          navigatorKey: GlobalKey<NavigatorState>(),
          router: SpRouter.themeSetting,
          inactiveIcon: Icons.color_lens_outlined,
          activeIcon: Icons.color_lens,
        );
      case SpRouter.archive:
        return MainTabBarItem(
          navigatorKey: GlobalKey<NavigatorState>(),
          router: SpRouter.archive,
          inactiveIcon: Icons.archive_outlined,
          activeIcon: Icons.archive,
        );
      case SpRouter.explore:
        return null;
      // return MainTabBarItem(
      //   navigatorKey: GlobalKey<NavigatorState>(),
      //   router: SpRouter.explore,
      //   inactiveIcon: Icons.explore_outlined,
      //   activeIcon: Icons.explore,
      // );
      case SpRouter.addOn:
        return MainTabBarItem(
          navigatorKey: GlobalKey<NavigatorState>(),
          router: SpRouter.addOn,
          inactiveIcon: Icons.extension_outlined,
          activeIcon: Icons.extension,
        );
      case SpRouter.soundList:
        return MainTabBarItem(
          navigatorKey: GlobalKey<NavigatorState>(),
          router: SpRouter.soundList,
          inactiveIcon: Icons.music_note_outlined,
          activeIcon: Icons.music_note,
        );
    }
  }
}
