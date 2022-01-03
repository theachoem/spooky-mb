import 'package:auto_route/annotations.dart';
import '../../ui/views/home/home_view.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(
      name: 'home',
      page: HomeView,
      initial: true,
    ),
  ],
)
class $Router {}
