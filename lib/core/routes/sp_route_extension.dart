import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/views/main/main_view_item.dart';

class SpRouterDatas {
  final String title;
  final String? shortTitle;
  final String subtitle;
  final MainTabBarItem? tab;

  SpRouterDatas({
    required this.title,
    required this.subtitle,
    required this.tab,
    this.shortTitle,
  });
}

extension SpRouterExtension on SpRouter {
  SpRouterDatas get datas {
    switch (this) {
      case SpRouter.backupsDetails:
        return SpRouterDatas(
          title: 'Backups',
          subtitle: 'Backup & Restore with cloud storages',
          tab: null,
        );
      case SpRouter.cloudStorages:
        return SpRouterDatas(
          title: 'Cloud Storage',
          shortTitle: 'Cloud',
          subtitle: 'Cloud Storage',
          tab: MainTabBarItem(
            navigatorKey: GlobalKey<NavigatorState>(),
            router: SpRouter.cloudStorages,
            inactiveIcon: Icons.cloud_outlined,
            activeIcon: Icons.cloud,
          ),
        );
      case SpRouter.fontManager:
        return SpRouterDatas(
          title: 'Font Book',
          subtitle: 'Font Book',
          tab: null,
        );
      case SpRouter.lock:
        return SpRouterDatas(
          title: 'Lock',
          subtitle: 'Lock',
          tab: null,
        );
      case SpRouter.security:
        return SpRouterDatas(
          title: 'Security',
          subtitle: 'Security',
          tab: MainTabBarItem(
            navigatorKey: GlobalKey<NavigatorState>(),
            router: SpRouter.security,
            inactiveIcon: Icons.security_outlined,
            activeIcon: Icons.security,
          ),
        );
      case SpRouter.themeSetting:
        return SpRouterDatas(
          title: 'Theme',
          subtitle: 'Theme',
          tab: MainTabBarItem(
            navigatorKey: GlobalKey<NavigatorState>(),
            router: SpRouter.themeSetting,
            inactiveIcon: Icons.color_lens_outlined,
            activeIcon: Icons.color_lens,
          ),
        );
      case SpRouter.managePages:
        return SpRouterDatas(
          title: 'Manage pages',
          subtitle: 'Manage pages',
          tab: null,
        );
      case SpRouter.archive:
        return SpRouterDatas(
          title: 'Archive',
          subtitle: 'Archive',
          tab: MainTabBarItem(
            navigatorKey: GlobalKey<NavigatorState>(),
            router: SpRouter.archive,
            inactiveIcon: Icons.archive_outlined,
            activeIcon: Icons.archive,
          ),
        );
      case SpRouter.contentReader:
        return SpRouterDatas(
          title: 'Content Reader',
          subtitle: 'Content Reader',
          tab: null,
        );
      case SpRouter.changesHistory:
        return SpRouterDatas(
          title: 'Changes history',
          subtitle: 'Changes history',
          tab: null,
        );
      case SpRouter.detail:
        return SpRouterDatas(
          title: 'Detail',
          subtitle: 'Detail',
          tab: null,
        );
      case SpRouter.main:
        return SpRouterDatas(
          title: 'Main',
          subtitle: 'Main',
          tab: null,
        );
      case SpRouter.home:
        return SpRouterDatas(
          title: 'Home',
          subtitle: 'Home',
          tab: MainTabBarItem(
            navigatorKey: GlobalKey<NavigatorState>(),
            router: SpRouter.home,
            inactiveIcon: Icons.home_outlined,
            activeIcon: Icons.home,
            optinal: false,
          ),
        );
      case SpRouter.explore:
        return SpRouterDatas(
          title: 'Explore',
          subtitle: 'Explore',
          tab: null,
        );
      case SpRouter.setting:
        return SpRouterDatas(
          title: 'Setting',
          subtitle: 'Setting',
          tab: MainTabBarItem(
            navigatorKey: GlobalKey<NavigatorState>(),
            router: SpRouter.setting,
            inactiveIcon: Icons.settings_outlined,
            activeIcon: Icons.settings,
            optinal: false,
          ),
        );
      case SpRouter.appStarter:
        return SpRouterDatas(
          title: 'App Starter',
          subtitle: 'App Starter',
          tab: null,
        );
      case SpRouter.initPickColor:
        return SpRouterDatas(
          title: 'Favorite color',
          subtitle: 'Pick one of your favorite color',
          tab: null,
        );
      case SpRouter.nicknameCreator:
        return SpRouterDatas(
          title: 'Nickname Creator',
          subtitle: 'Nickname Creator',
          tab: null,
        );
      case SpRouter.developerMode:
        return SpRouterDatas(
          title: 'Developer',
          subtitle: 'Developer',
          tab: null,
        );
      case SpRouter.notFound:
        return SpRouterDatas(
          title: 'Not Found',
          subtitle: 'Not Found',
          tab: null,
        );
      case SpRouter.addOn:
        return SpRouterDatas(
          title: 'Add-ons',
          subtitle: 'Add more lifetime access functionalities',
          tab: MainTabBarItem(
            navigatorKey: GlobalKey<NavigatorState>(),
            router: SpRouter.addOn,
            inactiveIcon: Icons.extension_outlined,
            activeIcon: Icons.extension,
          ),
        );
      case SpRouter.soundList:
        return SpRouterDatas(
          title: "Sounds",
          subtitle: "Sounds",
          tab: MainTabBarItem(
            navigatorKey: GlobalKey<NavigatorState>(),
            router: SpRouter.soundList,
            inactiveIcon: Icons.music_note_outlined,
            activeIcon: Icons.music_note,
          ),
        );
      case SpRouter.bottomNavSetting:
        return SpRouterDatas(
          title: "Bottom Navigation",
          subtitle: "Manage bottom navigation",
          tab: null,
        );
      case SpRouter.storyPadRestore:
        return SpRouterDatas(
          title: "StoryPad",
          subtitle: "StoryPad",
          tab: null,
        );
      case SpRouter.user:
        return SpRouterDatas(
          title: "User",
          subtitle: "Account is mainly used to store purchased histories.",
          tab: null,
        );
      case SpRouter.signUp:
        return SpRouterDatas(
          title: 'Sign up',
          subtitle: 'Sign up',
          tab: null,
        );
      case SpRouter.search:
        return SpRouterDatas(
          title: 'Search',
          subtitle: 'Search',
          tab: null,
        );
      case SpRouter.backupHistoriesManager:
        return SpRouterDatas(
          title: 'Backup Histories',
          subtitle: 'Backup Histories',
          tab: null,
        );
      case SpRouter.accountDeletion:
        return SpRouterDatas(
          title: 'Delete Account',
          subtitle: 'Account Deletion',
          tab: null,
        );
    }
  }

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
      case SpRouter.backupHistoriesManager:
        return '/backup-histories-manager';
      case SpRouter.accountDeletion:
        return '/account-deletion';
    }
  }
}
