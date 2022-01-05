import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/scheduler.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/storages/theme_mode_storage.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/core/locator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  setupLocator();
  runApp(
    EasyLocalization(
      supportedLocales: AppConstant.supportedLocales,
      fallbackLocale: AppConstant.fallbackLocale,
      path: 'assets/translations',
      child: InitialTheme(),
    ),
  );
}

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
      theme: ThemeData(colorScheme: ThemeConstant.lightM3Color.toColorScheme()),
      darkTheme: ThemeData(colorScheme: ThemeConstant.darkM3Color.toColorScheme()),
      home: App(themeMode: mode),
    );
  }
}
