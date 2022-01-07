import 'package:auto_route/annotations.dart';
import 'package:spooky/ui/views/detail/detail_view.dart';
import 'package:spooky/ui/views/explore/explore_view.dart';
import 'package:spooky/ui/views/file_manager/file_manager_view.dart';
import 'package:spooky/ui/views/home/home_view.dart';
import 'package:spooky/ui/views/main/main_view.dart';
import 'package:spooky/ui/views/setting/setting_view.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
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
        ),
        MaterialRoute(
          name: 'Explore',
          page: ExploreView,
        ),
        MaterialRoute(
          name: 'Setting',
          page: SettingView,
        ),
        MaterialRoute(
          name: "FileManager",
          page: FileManagerView,
        ),
      ],
      initial: true,
    ),
  ],
)
class $Router {}
