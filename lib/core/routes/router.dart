import 'package:auto_route/annotations.dart';
import 'package:spooky/views/app_starter/app_starter_view.dart';
import 'package:spooky/views/archive/archive_view.dart';
import 'package:spooky/views/changes_history/changes_history_view.dart';
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
import 'package:spooky/views/restore/restore_view.dart';
import 'package:spooky/views/security/security_view.dart';
import 'package:spooky/views/setting/setting_view.dart';
import 'package:spooky/views/theme_setting/theme_setting_view.dart';

/// Use for generator route params only.
/// To navigate, use normal `Navigator.of(context)` instead.
@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(
      page: RestoreView,
      name: 'Restore',
    ),
    MaterialRoute(
      page: FontManagerView,
      name: 'FontManager',
    ),
    MaterialRoute(
      page: LockView,
      name: 'Lock',
    ),
    MaterialRoute(
      page: SecurityView,
      name: 'Security',
    ),
    MaterialRoute(
      page: DeveloperModeView,
      name: 'DeveloperMode',
    ),
    MaterialRoute(
      page: NicknameCreatorView,
      name: 'NicknameCreator',
    ),
    MaterialRoute(
      page: InitPickColorView,
      name: 'InitPickColor',
    ),
    MaterialRoute(
      page: AppStarterView,
      name: 'AppStarter',
    ),
    MaterialRoute(
      page: ThemeSettingView,
      name: 'ThemeSetting',
    ),
    MaterialRoute(
      page: ManagePagesView,
      name: 'ManagePages',
      fullscreenDialog: true,
    ),
    MaterialRoute(
      page: ArchiveView,
      name: 'Archive',
    ),
    MaterialRoute(
      page: ContentReaderView,
      name: 'ContentReader',
      fullscreenDialog: true,
    ),
    MaterialRoute(
      page: ChangesHistoryView,
      name: 'ChangesHistory',
    ),
    MaterialRoute(
      name: 'Detail',
      page: DetailView,
    ),
    MaterialRoute(
      name: 'Main',
      page: MainView,
      children: [
        MaterialRoute(
          name: 'Home',
          page: HomeView,
          path: 'home',
        ),
        MaterialRoute(
          name: 'Explore',
          page: ExploreView,
          path: 'explore',
        ),
        MaterialRoute(
          name: 'Setting',
          page: SettingView,
          path: 'setting',
        ),
      ],
      initial: true,
    ),
  ],
)
class $AppRouter {}
