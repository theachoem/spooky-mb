import 'package:flutter/material.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/routes/setting/animated_route_setting.dart';
import 'package:spooky/core/routes/setting/base_route_setting.dart';
import 'package:spooky/core/routes/setting/default_route_setting.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/views/account_deletion/account_deletion_view.dart';
import 'package:spooky/views/add_ons/add_ons_view.dart';
import 'package:spooky/views/app_starter/app_starter_view.dart';
import 'package:spooky/views/archive/archive_view.dart';
import 'package:spooky/views/authentication/sign_up_view.dart';
import 'package:spooky/views/backup_histories_manager/backup_histories_manager_view.dart';
import 'package:spooky/views/backups_details/backups_details_view.dart';
import 'package:spooky/views/bottom_nav_setting/bottom_nav_setting_view.dart';
import 'package:spooky/views/budgets/budgets_view.dart';
import 'package:spooky/views/changes_history/changes_history_view.dart';
import 'package:spooky/views/cloud_storages/cloud_storages_view.dart';
import 'package:spooky/views/content_reader/content_reader_view.dart';
import 'package:spooky/views/detail/detail_view.dart';
import 'package:spooky/views/developer_mode/developer_mode_view.dart';
import 'package:spooky/views/explore/explore_view.dart';
import 'package:spooky/views/font_manager/font_manager_view.dart';
import 'package:spooky/views/home/home_view.dart';
import 'package:spooky/views/init_pick_color/init_pick_color_view.dart';
import 'package:spooky/views/lock/lock_view.dart';
import 'package:spooky/views/main/main_view.dart';
import 'package:spooky/views/manage_pages/manage_pages_view.dart';
import 'package:spooky/views/nickname_creator/nickname_creator_view.dart';
import 'package:spooky/views/not_found/not_found_view.dart';
import 'package:spooky/views/search/search_view.dart';
import 'package:spooky/views/security/security_view.dart';
import 'package:spooky/views/setting/setting_view.dart';
import 'package:spooky/views/sound_list/sound_list_view.dart';
import 'package:spooky/views/story_pad_restore/story_pad_restore_view.dart';
import 'package:spooky/views/theme_setting/theme_setting_view.dart';
import 'package:spooky/views/user/user_view.dart';

class SpRouteConfig {
  final RouteSettings? settings;
  final BuildContext context;

  Map<SpRouter, BaseRouteSetting> routes = {};
  SpRouteConfig({
    required this.context,
    this.settings,
  }) {
    _setup();
  }

  Route<dynamic> generate() {
    SpRouter router = SpRouter.notFound;
    for (SpRouter element in SpRouter.values) {
      if (settings?.name == element.path) {
        router = element;
        break;
      }
    }
    BaseRouteSetting? setting = routes[router];
    return setting!.toRoute(context, settings);
  }

  void _setup() {
    routes.clear();
    for (SpRouter path in SpRouter.values) {
      routes[path] = buildRoute(path);
    }
  }

  BaseRouteSetting buildRoute(SpRouter router) {
    switch (router) {
      case SpRouter.backupsDetails:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) {
            Object? arguments = settings?.arguments;
            if (arguments is BackupsDetailArgs) {
              return BackupsDetailsView(
                destination: arguments.destination,
                initialCloudFile: arguments.initialCloudFile,
                cloudFiles: arguments.cloudFiles,
              );
            } else {
              return const NotFoundView();
            }
          },
        );
      case SpRouter.cloudStorages:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const CloudStoragesView(),
        );
      case SpRouter.fontManager:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const FontManagerView(),
        );
      case SpRouter.lock:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) {
            Object? arguments = settings?.arguments;
            if (arguments is LockArgs) {
              return LockView(flowType: arguments.flowType);
            }
            return const NotFoundView();
          },
        );
      case SpRouter.security:
        return DefaultRouteSetting(
          fullscreenDialog: true,
          route: (context) => const SecurityView(),
        );
      case SpRouter.themeSetting:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const ThemeSettingView(),
        );
      case SpRouter.managePages:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) {
            Object? arguments = settings?.arguments;
            if (arguments is ManagePagesArgs) {
              return ManagePagesView(content: arguments.content);
            }
            return const NotFoundView();
          },
        );
      case SpRouter.archive:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const ArchiveView(),
        );
      case SpRouter.contentReader:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) {
            Object? arguments = settings?.arguments;
            if (arguments is ContentReaderArgs) {
              return ContentReaderView(content: arguments.content);
            }
            return const NotFoundView();
          },
        );
      case SpRouter.changesHistory:
        return DefaultRouteSetting(
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
            return const NotFoundView();
          },
        );
      case SpRouter.detail:
        return DefaultRouteSetting<StoryDbModel>(
          fullscreenDialog: false,
          route: (context) {
            Object? arguments = settings?.arguments;
            if (arguments is DetailArgs) {
              return DetailView(
                initialStory: arguments.initialStory,
                intialFlow: arguments.intialFlow,
              );
            }
            return const NotFoundView();
          },
        );
      case SpRouter.main:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const MainView(),
        );
      case SpRouter.home:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) {
            Object? arguments = settings?.arguments;
            if (arguments is HomeArgs) {
              return HomeView(
                onMonthChange: arguments.onMonthChange,
                onYearChange: arguments.onYearChange,
                onScrollControllerReady: arguments.onScrollControllerReady,
                onTagChange: arguments.onTagChange,
              );
            }
            return const NotFoundView();
          },
        );
      case SpRouter.explore:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const ExploreView(),
        );
      case SpRouter.setting:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const SettingView(),
        );
      case SpRouter.appStarter:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const AppStarterView(),
        );
      case SpRouter.initPickColor:
        return AnimatedRouteSetting(
          fullscreenDialog: false,
          fillColor: M3Color.of(context).background,
          route: (context) {
            Object? arguments = settings?.arguments;
            if (arguments is InitPickColorArgs) {
              return InitPickColorView(showNextButton: arguments.showNextButton);
            } else {
              return const InitPickColorView(showNextButton: false);
            }
          },
        );
      case SpRouter.nicknameCreator:
        return AnimatedRouteSetting(
          fullscreenDialog: false,
          fillColor: M3Color.of(context).background,
          route: (context) => const NicknameCreatorView(),
        );
      case SpRouter.developerMode:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const DeveloperModeView(),
        );
      case SpRouter.notFound:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const NotFoundView(),
        );
      case SpRouter.addOn:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const AddOnsView(),
        );
      case SpRouter.soundList:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const SoundListView(),
        );
      case SpRouter.bottomNavSetting:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const BottomNavSettingView(),
        );
      case SpRouter.storyPadRestore:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const StoryPadRestoreView(),
        );
      case SpRouter.user:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const UserView(),
        );
      case SpRouter.signUp:
        return DefaultRouteSetting(
          fullscreenDialog: true,
          route: (context) => const SignUpView(),
        );
      case SpRouter.accountDeletion:
        return DefaultRouteSetting(
          fullscreenDialog: true,
          route: (context) => const AccountDeletionView(),
        );
      case SpRouter.backupHistoriesManager:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) {
            Object? arguments = settings?.arguments;
            if (arguments is BackupHistoriesManagerArgs) {
              return BackupHistoriesManagerView(
                destination: arguments.destination,
              );
            }
            return const NotFoundView();
          },
        );
      case SpRouter.search:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) {
            Object? arguments = settings?.arguments;
            if (arguments is SearchArgs) {
              return SearchView(
                initialQuery: arguments.initialQuery,
                displayTag: arguments.displayTag,
              );
            } else {
              return const SearchView(initialQuery: null);
            }
          },
        );
      case SpRouter.budgets:
        return DefaultRouteSetting(
          fullscreenDialog: false,
          route: (context) => const BudgetsView(),
        );
    }
  }
}
