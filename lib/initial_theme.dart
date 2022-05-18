import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/providers/theme_provider.dart';

// InitialTheme is used to minimal theme as much as possible
// which will be use in eg. dialog.
class InitialTheme extends StatelessWidget {
  const InitialTheme({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      child: child,
      builder: (context, provider, child) {
        return MaterialApp(
          themeMode: provider.themeMode,
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          theme: buildThemeData(provider.lightTheme.colorScheme),
          darkTheme: buildThemeData(provider.darkTheme.colorScheme),
          home: child,
        );
      },
    );
  }

  ThemeData buildThemeData(ColorScheme colors) {
    return ThemeData(
      dialogBackgroundColor: colors.background,
      backgroundColor: colors.background,
      primaryColor: colors.primary,
      colorScheme: colors,
      cupertinoOverrideTheme: const CupertinoThemeData(textTheme: CupertinoTextThemeData()),
    );
  }
}
