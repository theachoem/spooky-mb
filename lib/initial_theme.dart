import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/providers/theme_provider.dart';
import 'package:spooky/theme/theme_config.dart';

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
        ThemeConfig.dark();
        return MaterialApp(
          themeMode: provider.themeMode,
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          theme: buildThemeData(provider.lightTheme.colorScheme, false),
          darkTheme: buildThemeData(provider.darkTheme.colorScheme, true),
          home: child,
        );
      },
    );
  }

  ThemeData buildThemeData(ColorScheme colors, bool isDarkMode) {
    ThemeConfig maxThemeConfig = isDarkMode ? ThemeConfig.dark() : ThemeConfig.light();
    return ThemeConfig.withDefault(ThemeData(
      useMaterial3: true,
      dialogBackgroundColor: colors.background,
      backgroundColor: colors.background,
      primaryColor: colors.primary,
      colorScheme: colors,
      toggleableActiveColor: colors.primary,
      textTheme: maxThemeConfig.buildTextTheme(),
      cupertinoOverrideTheme: const CupertinoThemeData(textTheme: CupertinoTextThemeData()),
    ));
  }
}
