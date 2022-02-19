import 'package:flutter/scheduler.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/storages/theme_mode_storage.dart';
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

  bool toggleThemeMode() {
    if (mode == ThemeMode.system) {
      Brightness? brightness = SchedulerBinding.instance?.window.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
      return !isDarkMode;
    } else {
      bool isDarkMode = mode == ThemeMode.dark;
      setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
      return !isDarkMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: mode,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: buildThemeData(ThemeConstant.colorScheme(Brightness.light)),
      darkTheme: buildThemeData(ThemeConstant.colorScheme(Brightness.dark)),
      home: App(themeMode: mode),
    );
  }

  ThemeData buildThemeData(ColorScheme colors) {
    return ThemeData(
      dialogBackgroundColor: colors.background,
      backgroundColor: colors.background,
      primaryColor: colors.primary,
      colorScheme: colors,
    );
  }
}
