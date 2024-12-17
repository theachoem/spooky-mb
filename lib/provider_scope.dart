import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky_mb/providers/theme_provider.dart';

// global providers
class ProviderScope extends StatelessWidget {
  const ProviderScope({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: child,
    );
  }
}
