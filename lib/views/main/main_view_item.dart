import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';

class MainTabBarItem {
  final GlobalKey<NavigatorState> navigatorKey;
  final SpRouter router;
  final IconData inactiveIcon;
  final IconData activeIcon;
  final bool optinal;

  MainTabBarItem({
    required this.navigatorKey,
    required this.router,
    required this.inactiveIcon,
    required this.activeIcon,
    this.optinal = true,
  });
}

class MainTabBar {
  Map<SpRouter, MainTabBarItem> availableTabs = {
    SpRouter.home: MainTabBarItem(
      navigatorKey: GlobalKey<NavigatorState>(),
      router: SpRouter.home,
      inactiveIcon: Icons.home_outlined,
      activeIcon: Icons.home,
      optinal: false,
    ),
    SpRouter.soundList: MainTabBarItem(
      navigatorKey: GlobalKey<NavigatorState>(),
      router: SpRouter.soundList,
      inactiveIcon: Icons.music_note_outlined,
      activeIcon: Icons.music_note,
    ),
    SpRouter.cloudStorage: MainTabBarItem(
      navigatorKey: GlobalKey<NavigatorState>(),
      router: SpRouter.cloudStorage,
      inactiveIcon: Icons.cloud_outlined,
      activeIcon: Icons.cloud,
    ),
    SpRouter.setting: MainTabBarItem(
      navigatorKey: GlobalKey<NavigatorState>(),
      router: SpRouter.setting,
      inactiveIcon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      optinal: false,
    ),
  };
}
