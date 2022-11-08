import 'package:easy_localization/easy_localization.dart';
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
          title: tr("page.backups_details.title"),
          subtitle: tr("page.backups_details.subtitle"),
          tab: null,
        );
      case SpRouter.cloudStorages:
        return SpRouterDatas(
          title: tr("page.cloud_storages.title"),
          shortTitle: tr("page.cloud_storages.title_short"),
          subtitle: tr("page.cloud_storages.subtitle"),
          tab: MainTabBarItem(
            navigatorKey: GlobalKey<NavigatorState>(),
            router: SpRouter.cloudStorages,
            inactiveIcon: Icons.cloud_outlined,
            activeIcon: Icons.cloud,
          ),
        );
      case SpRouter.fontManager:
        return SpRouterDatas(
          title: tr("page.font_manager.title"),
          subtitle: tr("page.font_manager.subtitle"),
          tab: null,
        );
      case SpRouter.lock:
        return SpRouterDatas(
          title: tr("page.lock.title"),
          subtitle: ("page.lock.subtitle"),
          tab: null,
        );
      case SpRouter.security:
        return SpRouterDatas(
          title: tr("page.security.title"),
          subtitle: tr("page.security.subtitle"),
          tab: MainTabBarItem(
            navigatorKey: GlobalKey<NavigatorState>(),
            router: SpRouter.security,
            inactiveIcon: Icons.security_outlined,
            activeIcon: Icons.security,
          ),
        );
      case SpRouter.themeSetting:
        return SpRouterDatas(
          title: tr("page.theme_setting.title"),
          subtitle: tr("page.theme_setting.subtitle"),
          tab: MainTabBarItem(
            navigatorKey: GlobalKey<NavigatorState>(),
            router: SpRouter.themeSetting,
            inactiveIcon: Icons.color_lens_outlined,
            activeIcon: Icons.color_lens,
          ),
        );
      case SpRouter.managePages:
        return SpRouterDatas(
          title: tr("page.manage_pages.title"),
          subtitle: tr("page.manage_pages.subtitle"),
          tab: null,
        );
      case SpRouter.archive:
        return SpRouterDatas(
          title: tr("page.archive.title"),
          subtitle: tr("page.archive.subtitle"),
          tab: MainTabBarItem(
            navigatorKey: GlobalKey<NavigatorState>(),
            router: SpRouter.archive,
            inactiveIcon: Icons.archive_outlined,
            activeIcon: Icons.archive,
          ),
        );
      case SpRouter.contentReader:
        return SpRouterDatas(
          title: tr("page.content_reader.title"),
          subtitle: tr("page.content_reader.subtitle"),
          tab: null,
        );
      case SpRouter.changesHistory:
        return SpRouterDatas(
          title: tr("page.changes_history.title"),
          subtitle: tr("page.changes_history.subtitle"),
          tab: null,
        );
      case SpRouter.detail:
        return SpRouterDatas(
          title: tr("page.detail.title"),
          subtitle: tr("page.detail.subtitle"),
          tab: null,
        );
      case SpRouter.main:
        return SpRouterDatas(
          title: tr("page.main.title"),
          subtitle: tr("page.main.subtitle"),
          tab: null,
        );
      case SpRouter.home:
        return SpRouterDatas(
          title: tr("page.home.title"),
          subtitle: tr("page.home.subtitle"),
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
          title: tr("page.explore.title"),
          subtitle: tr("page.explore.subtitle"),
          tab: null,
        );
      case SpRouter.setting:
        return SpRouterDatas(
          title: tr("page.setting.title"),
          subtitle: tr("page.setting.subtitle"),
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
          title: tr("page.app_starter.title"),
          subtitle: tr("page.app_starter.subtitle"),
          tab: null,
        );
      case SpRouter.initPickColor:
        return SpRouterDatas(
          title: tr("page.init_color_picker.title"),
          subtitle: tr("page.init_color_picker.subtitle"),
          tab: null,
        );
      case SpRouter.nicknameCreator:
        return SpRouterDatas(
          title: tr("page.nickname_creator.title"),
          subtitle: tr("page.nickname_creator.subtitle"),
          tab: null,
        );
      case SpRouter.developerMode:
        return SpRouterDatas(
          title: tr("page.developer_mode.title"),
          subtitle: tr("page.developer_mode.subtitle"),
          tab: null,
        );
      case SpRouter.notFound:
        return SpRouterDatas(
          title: tr("page.not_found.title"),
          subtitle: tr("page.not_found.subtitle"),
          tab: null,
        );
      case SpRouter.addOn:
        return SpRouterDatas(
          title: tr("page.add_on.title"),
          subtitle: tr("page.add_on.subtitle"),
          tab: MainTabBarItem(
            navigatorKey: GlobalKey<NavigatorState>(),
            router: SpRouter.addOn,
            inactiveIcon: Icons.extension_outlined,
            activeIcon: Icons.extension,
          ),
        );
      case SpRouter.soundList:
        return SpRouterDatas(
          title: tr("page.sounds.title"),
          subtitle: tr("page.sounds.title"),
          tab: MainTabBarItem(
            navigatorKey: GlobalKey<NavigatorState>(),
            router: SpRouter.soundList,
            inactiveIcon: Icons.music_note_outlined,
            activeIcon: Icons.music_note,
          ),
        );
      case SpRouter.bottomNavSetting:
        return SpRouterDatas(
          title: tr("page.bottom_nav_setting.title"),
          subtitle: tr("page.bottom_nav_setting.subtitle"),
          tab: null,
        );
      case SpRouter.storyPadRestore:
        return SpRouterDatas(
          title: tr("page.storypad_restore.title"),
          subtitle: tr("page.storypad_restore.subtitle"),
          tab: null,
        );
      case SpRouter.user:
        return SpRouterDatas(
          title: tr("page.user.title"),
          subtitle: tr("page.user.subtitle"),
          tab: null,
        );
      case SpRouter.signUp:
        return SpRouterDatas(
          title: tr("page.sign_up.title"),
          subtitle: tr("page.sign_up.subtitle"),
          tab: null,
        );
      case SpRouter.search:
        return SpRouterDatas(
          title: tr("page.search.title"),
          subtitle: tr("page.search.subtitle"),
          tab: null,
        );
      case SpRouter.backupHistoriesManager:
        return SpRouterDatas(
          title: tr("page.backup_histories_manager.title"),
          subtitle: tr("page.backup_histories_manager.subtitle"),
          tab: null,
        );
      case SpRouter.accountDeletion:
        return SpRouterDatas(
          title: tr("page.account_deletion.title"),
          subtitle: tr("page.account_deletion.title"),
          tab: null,
        );
      case SpRouter.budgets:
        return SpRouterDatas(
          title: tr("page.budgets.title"),
          subtitle: tr("page.budgets.subtitle"),
          tab: MainTabBarItem(
            navigatorKey: GlobalKey<NavigatorState>(),
            router: SpRouter.budgets,
            inactiveIcon: Icons.wallet_outlined,
            activeIcon: Icons.wallet,
          ),
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
        return '/';
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
      case SpRouter.budgets:
        return '/budgets';
    }
  }
}
