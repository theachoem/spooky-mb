import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/providers/base_cloud_provider.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/views/add_ons/add_ons_view.dart';
import 'package:spooky/views/app_starter/app_starter_view.dart';
import 'package:spooky/views/archive/archive_view.dart';
import 'package:spooky/views/backups_details/backups_details_view.dart';
import 'package:spooky/views/bottom_nav_setting/bottom_nav_setting_view.dart';
import 'package:spooky/views/changes_history/changes_history_view.dart';
import 'package:spooky/views/cloud_storage/cloud_storage_view.dart';
import 'package:spooky/views/cloud_storages/cloud_storages_view.dart';
import 'package:spooky/views/content_reader/content_reader_view.dart';
import 'package:spooky/views/detail/detail_view.dart';
import 'package:spooky/views/developer_mode/developer_mode_view.dart';
import 'package:spooky/views/explore/explore_view.dart';
import 'package:spooky/views/font_manager/font_manager_view.dart';
import 'package:spooky/views/home/home_view.dart';
import 'package:spooky/views/init_pick_color/init_pick_color_view.dart';
import 'package:spooky/views/lock/lock_view.dart';
import 'package:spooky/views/lock/types/lock_flow_type.dart';
import 'package:spooky/views/main/main_view.dart';
import 'package:spooky/views/manage_pages/manage_pages_view.dart';
import 'package:spooky/views/nickname_creator/nickname_creator_view.dart';
import 'package:spooky/views/not_found/not_found_view.dart';
import 'package:spooky/views/restore/restore_view.dart';
import 'package:spooky/views/restores/restores_view.dart';
import 'package:spooky/views/security/security_view.dart';
import 'package:spooky/views/setting/setting_view.dart';
import 'package:spooky/views/sound_list/sound_list_view.dart';
import 'package:spooky/views/story_pad_restore/story_pad_restore_view.dart';
import 'package:spooky/views/theme_setting/theme_setting_view.dart';
import 'package:spooky/views/user/user_view.dart';

part 'app_router.gr.dart';

// @CupertinoAutoRouter
// @AdaptiveAutoRouter
// @CustomAutoRouter
@AdaptiveAutoRouter(
  replaceInRouteName: 'View',
  routes: <AutoRoute>[
    AutoRoute(
      path: 'app-starter',
      page: AppStarterView,
      name: 'AppStarter',
    ),
    AutoRoute(
      path: 'pick-color',
      page: InitPickColorView,
      name: 'InitPickColor',
    ),
    AutoRoute(
      path: 'lock-view',
      page: LockView,
      name: 'Lock',
    ),
    AutoRoute(
      path: '/',
      page: MainView,
      name: 'Main',
      initial: true,
      children: [
        AutoRoute(
          path: 'add-ons',
          page: AddOnsView,
          name: 'AddOns',
        ),
        AutoRoute(
          path: 'archive',
          page: ArchiveView,
          name: 'Archive',
        ),
        AutoRoute(
          path: 'backups-detail',
          page: BackupsDetailsView,
          name: 'BackupsDetail',
        ),
        AutoRoute(
          path: 'bottom-nav-setting',
          page: BottomNavSettingView,
          name: 'BottomNavSetting',
        ),
        AutoRoute(
          path: 'changes-history',
          page: ChangesHistoryView,
          name: 'ChangesHistory',
        ),
        AutoRoute(
          path: 'cloud-storage',
          page: CloudStorageView,
          name: 'CloudStorage',
        ),
        AutoRoute(
          path: 'cloud-storages',
          page: CloudStoragesView,
          name: 'CloudStorages',
        ),
        AutoRoute(
          path: 'content-reader',
          page: ContentReaderView,
          name: 'ContentReader',
        ),
        AutoRoute(
          path: 'detail',
          page: DetailView,
          name: 'Detail',
        ),
        AutoRoute(
          path: 'developer-mode',
          page: DeveloperModeView,
          name: 'DeveloperMode',
        ),
        AutoRoute(
          path: 'explore',
          page: ExploreView,
          name: 'Explore',
        ),
        AutoRoute(
          path: 'font-manager',
          page: FontManagerView,
          name: 'FontManager',
        ),
        AutoRoute(
          path: '',
          page: HomeView,
          name: 'Home',
          initial: true,
        ),
        AutoRoute(
          path: 'manage-pages',
          page: ManagePagesView,
          name: 'ManagePages',
        ),
        AutoRoute(
          path: 'nickname-creator',
          page: NicknameCreatorView,
          name: 'NicknameCreator',
        ),
        AutoRoute(
          path: 'not-found',
          page: NotFoundView,
          name: 'NotFound',
        ),
        AutoRoute(
          path: 'restore',
          page: RestoreView,
          name: 'Restore',
        ),
        AutoRoute(
          path: 'restores',
          page: RestoresView,
          name: 'Restores',
        ),
        AutoRoute(
          path: 'security',
          page: SecurityView,
          name: 'Security',
        ),
        AutoRoute(
          path: 'setting',
          page: SettingView,
          name: 'Setting',
        ),
        AutoRoute(
          path: 'sounds',
          page: SoundListView,
          name: 'SoundList',
        ),
        AutoRoute(
          path: 'storypad-restore',
          page: StoryPadRestoreView,
          name: 'StoryPadRestore',
        ),
        AutoRoute(
          path: 'theme-setting',
          page: ThemeSettingView,
          name: 'ThemeSetting',
        ),
        AutoRoute(
          path: 'user',
          page: UserView,
          name: 'User',
        ),
      ],
    ),
  ],
)
class AppRouter extends _$AppRouter {}

class EmptyRouterView extends AutoRouter {
  const EmptyRouterView({
    Key? key,
  }) : super(key: key);
}
