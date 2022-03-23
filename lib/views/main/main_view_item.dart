import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';

class MainTabBarItem {
  final GlobalKey<NavigatorState> navigatorKey;
  final SpRouter router;
  final IconData inactiveIcon;
  final IconData activeIcon;

  MainTabBarItem({
    required this.navigatorKey,
    required this.router,
    required this.inactiveIcon,
    required this.activeIcon,
  });
}

class MainTabBar {
  List<MainTabBarItem> get items {
    return [
      MainTabBarItem(
        navigatorKey: GlobalKey<NavigatorState>(),
        router: SpRouter.home,
        inactiveIcon: Icons.home_outlined,
        activeIcon: Icons.home,
      ),
      // MainTabBarItem(
      //   navigatorKey: GlobalKey<NavigatorState>(),
      //   router: SpRouter.explore,
      //   inactiveIcon: Icons.explore_outlined,
      //   activeIcon: Icons.explore,
      // ),
      // MainTabBarItem(
      //   navigatorKey: GlobalKey<NavigatorState>(),
      //   router: SpRouter.soundList,
      //   inactiveIcon: Icons.music_note_outlined,
      //   activeIcon: Icons.music_note,
      // ),
      MainTabBarItem(
        navigatorKey: GlobalKey<NavigatorState>(),
        router: SpRouter.setting,
        inactiveIcon: Icons.settings_outlined,
        activeIcon: Icons.settings,
      ),
    ];
  }
}
