import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_route_config.dart';

class MainTabBarItem {
  final GlobalKey<NavigatorState> navigatorKey;
  final String routeName;

  final IconData inactiveIcon;
  final IconData activeIcon;
  final String label;

  MainTabBarItem({
    required this.navigatorKey,
    required this.routeName,
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
        routeName: SpRouteConfig.home,
        inactiveIcon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: "Home",
      ),
      MainTabBarItem(
        navigatorKey: GlobalKey<NavigatorState>(),
        routeName: SpRouteConfig.explore,
        inactiveIcon: Icons.explore_outlined,
        activeIcon: Icons.explore,
        label: "Explore",
      ),
      MainTabBarItem(
        navigatorKey: GlobalKey<NavigatorState>(),
        routeName: SpRouteConfig.setting,
        inactiveIcon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        label: "Setting",
      ),
    ];
  }
}
