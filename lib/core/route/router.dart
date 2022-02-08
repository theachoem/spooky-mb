import 'package:auto_route/annotations.dart';
import 'package:spooky/ui/views/app_starter/app_starter_view.dart';
import 'package:spooky/ui/views/archive/archive_view.dart';
import 'package:spooky/ui/views/changes_history/changes_history_view.dart';
import 'package:spooky/ui/views/content_reader/content_reader_view.dart';
import 'package:spooky/ui/views/detail/detail_view.dart';
import 'package:spooky/ui/views/explore/explore_view.dart';
import 'package:spooky/ui/views/home/home_view.dart';
import 'package:spooky/ui/views/init_pick_color/init_pick_color_view.dart';
import 'package:spooky/ui/views/main/main_view.dart';
import 'package:spooky/ui/views/manage_pages/manage_pages_view.dart';
import 'package:spooky/ui/views/nickname_creator/nickname_creator_view.dart';
import 'package:spooky/ui/views/setting/setting_view.dart';
import 'package:spooky/ui/views/theme_setting/theme_setting_view.dart';

/// Use for generator route params only. use normal `Navigator.of(context)`
@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(
      page: InitPickColorView,
    ),
    MaterialRoute(
      page: NicknameCreatorView,
    ),
    MaterialRoute(
      page: AppStarterView,
    ),
    MaterialRoute(
      page: ThemeSettingView,
      name: 'ThemeSetting',
      path: '/theme-setting',
    ),
    MaterialRoute(
      page: ManagePagesView,
      name: 'ManagePages',
      path: '/manage-pages',
      fullscreenDialog: true,
    ),
    MaterialRoute(
      page: ArchiveView,
      name: 'Archive',
      path: '/archive',
    ),
    MaterialRoute(
      page: ContentReaderView,
      name: 'ContentReader',
      path: '/content-reader',
      fullscreenDialog: true,
    ),
    MaterialRoute(
      page: ChangesHistoryView,
      name: 'ChangesHistory',
      path: '/changes-sistory',
    ),
    MaterialRoute(
      name: 'Detail',
      page: DetailView,
      path: '/detail',
    ),
    MaterialRoute(
      name: 'Main',
      page: MainView,
      path: '/',
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
