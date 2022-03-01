import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/theme_mode_provider.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:flutter/material.dart';

// InitialTheme is used to minimal theme as much as possible
// which will be use in eg. dialog.
class InitialTheme extends StatelessWidget {
  const InitialTheme({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(ThemeMode mode) builder;

  @override
  Widget build(BuildContext context) {
    ThemeModeProvider provider = Provider.of<ThemeModeProvider>(context, listen: true);
    return MaterialApp(
      themeMode: provider.mode,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: buildThemeData(ThemeConstant.colorScheme(Brightness.light)),
      darkTheme: buildThemeData(ThemeConstant.colorScheme(Brightness.dark)),
      home: builder(provider.mode),
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
