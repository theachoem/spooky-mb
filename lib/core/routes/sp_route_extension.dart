import 'package:spooky/core/routes/sp_router.dart';

extension SpRouterExtension on SpRouter {
  String get path {
    switch (this) {
      case SpRouter.restore:
        return '/restore';
      case SpRouter.cloudStorage:
        return '/cloud-storage';
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
        return "Bottom Navigation Setting";
    }
  }

  String get title {
    switch (this) {
      case SpRouter.restore:
        return 'Restore';
      case SpRouter.cloudStorage:
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
        return 'Init Pick Color';
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
    }
  }

  String get subtitle {
    switch (this) {
      case SpRouter.restore:
        return 'Connect with a Cloud Storage to restore your stories.';
      case SpRouter.cloudStorage:
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
        return 'Init Pick Color';
      case SpRouter.nicknameCreator:
        return 'Nickname Creator';
      case SpRouter.developerMode:
        return 'Developer';
      case SpRouter.notFound:
        return 'Not Found';
      case SpRouter.addOn:
        return 'Add more functionality';
      case SpRouter.soundList:
        return "Sounds";
      case SpRouter.bottomNavSetting:
        return "Manage bottom navigation";
    }
  }
}
