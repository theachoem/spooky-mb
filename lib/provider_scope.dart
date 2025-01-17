import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/backup_provider.dart';
import 'package:spooky/providers/local_auth_provider.dart';
import 'package:spooky/providers/theme_provider.dart';

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
        ListenableProvider<LocalAuthProvider>(
          create: (context) => LocalAuthProvider(),
        ),
        ListenableProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ListenableProvider<BackupProvider>(
          lazy: false,
          create: (context) => BackupProvider(),
        ),
      ],
      child: child,
    );
  }
}
