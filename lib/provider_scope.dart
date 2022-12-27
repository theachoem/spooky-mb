import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/backups/providers/dropbox_cloud_provider.dart';
import 'package:spooky/core/backups/providers/google_cloud_provider.dart';
import 'package:spooky/providers/bottom_nav_items_provider.dart';
import 'package:spooky/providers/in_app_purchase_provider.dart';
import 'package:spooky/providers/in_app_update_provider.dart';
import 'package:spooky/providers/mini_sound_player_provider.dart';
import 'package:spooky/providers/notification_provider.dart';
import 'package:spooky/providers/story_list_configuration_provider.dart';
import 'package:spooky/providers/tab_notice_provider.dart';
import 'package:spooky/providers/theme_provider.dart';
import 'package:spooky/providers/developer_mode_provider.dart';
import 'package:spooky/providers/nickname_provider.dart';
import 'package:spooky/providers/tile_max_line_provider.dart';

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
        ListenableProvider<StoryListConfigurationProvider>(
          create: (context) => StoryListConfigurationProvider(),
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
        ListenableProvider<GoogleCloudProvider>(
          create: (context) => GoogleCloudProvider.instance,
        ),
        ListenableProvider<DropboxCloudProvider>(
          create: (context) => DropboxCloudProvider.instance,
        ),
        ListenableProvider<TileMaxLineProvider>(
          create: (context) => TileMaxLineProvider(),
        ),
        ListenableProvider<InAppPurchaseProvider>(
          create: (context) => InAppPurchaseProvider(),
        ),
        ListenableProvider<MiniSoundPlayerProvider>(
          create: (context) => MiniSoundPlayerProvider.instance,
        ),
        ListenableProvider<BottomNavItemsProvider>(
          create: (context) => BottomNavItemsProvider(),
        ),
        ListenableProvider<InAppUpdateProvider>(
          create: (context) => InAppUpdateProvider.instance,
        ),
        ListenableProvider<NotificationProvider>(
          create: (context) => NotificationProvider(),
        ),
        ListenableProvider<TabNoticeProvider>(
          create: (context) => TabNoticeProvider.instance,
        ),
      ],
      child: child,
    );
  }
}
