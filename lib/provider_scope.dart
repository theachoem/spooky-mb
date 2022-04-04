import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/bottom_nav_items_provider.dart';
import 'package:spooky/providers/cloud_service_provider.dart';
import 'package:spooky/providers/in_app_purchase_provider.dart';
import 'package:spooky/providers/mini_sound_player_provider.dart';
import 'package:spooky/providers/priority_starred_provider.dart';
import 'package:spooky/providers/theme_provider.dart';
import 'package:spooky/providers/developer_mode_provider.dart';
import 'package:spooky/providers/nickname_provider.dart';
import 'package:spooky/providers/show_chips_provider.dart';
import 'package:spooky/providers/tile_max_line_provider.dart';
import 'package:spooky/providers/user_provider.dart';

// global providers
class ProviderScope extends StatelessWidget {
  const ProviderScope({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<ShowChipsProvider>(
          create: (context) => ShowChipsProvider(),
        ),
        ListenableProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ListenableProvider<NicknameProvider>(
          create: (context) => NicknameProvider(),
        ),
        ListenableProvider<DeveloperModeProvider>(
          create: (context) => DeveloperModeProvider(),
        ),
        ListenableProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ListenableProvider<CloudServiceProvider>(
          create: (context) => CloudServiceProvider(),
        ),
        ListenableProvider<TileMaxLineProvider>(
          create: (context) => TileMaxLineProvider(),
        ),
        ListenableProvider<InAppPurchaseProvider>(
          create: (context) => InAppPurchaseProvider(),
        ),
        ListenableProvider<MiniSoundPlayerProvider>(
          create: (context) => MiniSoundPlayerProvider(),
        ),
        ListenableProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ListenableProvider<BottomNavItemsProvider>(
          create: (context) => BottomNavItemsProvider(),
        ),
        ListenableProvider<PriorityStarredProvider>(
          create: (context) => PriorityStarredProvider(),
        ),
      ],
      child: child,
    );
  }
}
