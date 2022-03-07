import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/cloud_service_provider.dart';
import 'package:spooky/providers/color_seed_provider.dart';
import 'package:spooky/providers/developer_mode_provider.dart';
import 'package:spooky/providers/nickname_provider.dart';
import 'package:spooky/providers/show_chips_provider.dart';
import 'package:spooky/providers/theme_mode_provider.dart';
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
        ListenableProvider<ShowChipsProvider>(
          create: (context) => ShowChipsProvider(),
        ),
        ListenableProvider<ThemeModeProvider>(
          create: (context) => ThemeModeProvider(),
        ),
        ListenableProvider<NicknameProvider>(
          create: (context) => NicknameProvider(),
        ),
        ListenableProvider<DeveloperModeProvider>(
          create: (context) => DeveloperModeProvider(),
        ),
        ListenableProvider<ColorSeedProvider>(
          create: (context) => ColorSeedProvider(),
        ),
        ListenableProvider<CloudServiceProvider>(
          create: (context) => CloudServiceProvider(),
        ),
        ListenableProvider<TileMaxLineProvider>(
          create: (context) => TileMaxLineProvider(),
        ),
      ],
      child: child,
    );
  }
}
