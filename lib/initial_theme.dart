import 'package:flutter/scheduler.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/storages/theme_mode_storage.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:flutter/material.dart';

// InitialTheme is uesed to minimal theme as much as possible
// which will be use in eg. dialog.
class InitialTheme extends StatefulWidget {
  const InitialTheme({
    Key? key,
  }) : super(key: key);

  static _InitialThemeState? of(BuildContext context) {
    return context.findAncestorStateOfType<_InitialThemeState>();
  }

  @override
  State<InitialTheme> createState() => _InitialThemeState();
}

class _InitialThemeState extends State<InitialTheme> {
  ThemeMode mode = ThemeMode.system;
  ThemeModeStorage storage = ThemeModeStorage();

  @override
  void initState() {
    super.initState();
    storage.readEnum().then(setThemeMode);
  }

  void setThemeMode(ThemeMode? value) {
    if (value != null && value != mode) {
      setState(() {
        mode = value;
        storage.writeEnum(mode);
      });
      setState(() {});
    }
  }

  void toggleThemeMode() {
    if (mode == ThemeMode.system) {
      Brightness? brightness = SchedulerBinding.instance?.window.platformBrightness;
      bool _isDarkMode = brightness == Brightness.dark;
      setThemeMode(_isDarkMode ? ThemeMode.light : ThemeMode.dark);
    } else {
      setThemeMode(mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: mode,
      theme: buildThemeData(ThemeConstant.lightM3Color),
      darkTheme: buildThemeData(ThemeConstant.darkM3Color),
      home: App(themeMode: mode),
    );
  }

  ThemeData buildThemeData(M3Color colors) {
    return ThemeData(
      dialogBackgroundColor: colors.background,
      backgroundColor: colors.background,
      primaryColor: colors.primary,
      // ignore: deprecated_member_use
      accentColor: colors.primary,
      colorScheme: colors.toColorScheme(),
    );
  }
}
