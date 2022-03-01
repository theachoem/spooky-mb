import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/show_chips_provider.dart';
import 'package:spooky/providers/theme_mode_provider.dart';

// global provider
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
      ],
      child: child,
    );
  }
}
