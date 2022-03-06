import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';

class MainTabBarItem {
  final GlobalKey<NavigatorState> navigatorKey;
  final SpRouter router;

  final IconData inactiveIcon;
  final IconData activeIcon;
  final String label;

  MainTabBarItem({
    required this.navigatorKey,
    required this.router,
    required this.inactiveIcon,
    required this.activeIcon,
    required this.label,
  });
}

class MainTabBar {
  static List<MainTabBarItem> get items {
    return [
      MainTabBarItem(
        navigatorKey: GlobalKey<NavigatorState>(),
        router: SpRouter.home,
        inactiveIcon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: "Home",
      ),
      MainTabBarItem(
        navigatorKey: GlobalKey<NavigatorState>(),
        router: SpRouter.explore,
        inactiveIcon: Icons.explore_outlined,
        activeIcon: Icons.explore,
        label: "Explore",
      ),
      MainTabBarItem(
        navigatorKey: GlobalKey<NavigatorState>(),
        router: SpRouter.setting,
        inactiveIcon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        label: "Setting",
      ),
    ];
  }
}
