import 'package:auto_route/annotations.dart';
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
      name: 'detail',
      page: DetailView,
    ),
    MaterialRoute(
      name: 'main',
      page: MainView,
      children: [
        MaterialRoute(
          name: 'home',
          page: HomeView,
        ),
        MaterialRoute(
          name: 'explore',
          page: ExploreView,
        ),
        MaterialRoute(
          name: 'setting',
          page: SettingView,
        ),
      ],
      initial: true,
    ),
  ],
)
class $AppRouter {}
