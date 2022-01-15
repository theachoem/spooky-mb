import 'package:auto_route/annotations.dart';
import 'package:spooky/ui/views/changes_history/changes_history_view.dart';
import 'package:spooky/ui/views/content_reader/content_reader_view.dart';
import 'package:spooky/ui/views/detail/detail_view.dart';
import 'package:spooky/ui/views/explore/explore_view.dart';
import 'package:spooky/ui/views/home/home_view.dart';
import 'package:spooky/ui/views/main/main_view.dart';
import 'package:spooky/ui/views/setting/setting_view.dart';

export 'router.gr.dart';
export 'package:auto_route/auto_route.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(
      page: ContentReaderView,
      name: 'ContentReader',
      path: '/content-reader',
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
