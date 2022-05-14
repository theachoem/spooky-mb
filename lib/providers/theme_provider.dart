import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:spooky/core/models/theme_model.dart';
import 'package:spooky/core/storages/local_storages/theme_storage.dart';
import 'package:spooky/theme/theme_config.dart';
import 'package:spooky/theme/theme_constant.dart';
// ignore: depend_on_referenced_packages
import 'package:material_color_utilities/palettes/core_palette.dart';

class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  // initializer
  static ThemeModel? theme;
  static final ThemeStorage storage = ThemeStorage();

  static ColorScheme? lightDynamic;
  static ColorScheme? darkDynamic;

  static Future<void> initialize() async {
    theme = await storage.readObject();
    CorePalette? result = await DynamicColorPlugin.getCorePalette();
    lightDynamic ??= result?.toColorScheme();
    darkDynamic ??= result?.toColorScheme(brightness: Brightness.dark);
  }

  ThemeProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  // states
  String get fontFamily => theme?.fontFamily ?? ThemeConstant.defaultFontFamily;
  FontWeight get fontWeight => theme?.fontWeight ?? ThemeConstant.defaultFontWeight;
  ThemeMode get themeMode => theme?.themeMode ?? ThemeMode.system;
  Color get colorSeed => theme?.colorSeed ?? ThemeConstant.fallbackColor;

  ThemeData get lightTheme {
    if (themeMode == ThemeMode.system) {
      return ThemeConfig(false, fontFamily, fontWeight, lightDynamic).themeData;
    } else {
      return ThemeConfig(false, fontFamily, fontWeight, null).themeData;
    }
  }

  ThemeData get darkTheme {
    if (themeMode == ThemeMode.system) {
      return ThemeConfig(true, fontFamily, fontWeight, darkDynamic).themeData;
    } else {
      return ThemeConfig(true, fontFamily, fontWeight, null).themeData;
    }
  }

  Future<void> load() async {
    theme = await storage.readObject();
    notifyListeners();
  }

  Future<void> updateTheme(ThemeModel theme) async {
    await storage.writeObject(theme);
    return load();
  }

  Future<void> updateColor(Color? color) async {
    return updateTheme(
      theme!.copyWith(
        colorSeed: color,
      ),
    );
  }

  Future<void> updateFont(String fontFamily) async {
    return updateTheme(theme!.copyWith(
      fontFamily: fontFamily,
    ));
  }

  Future<void> updateFontWeight(FontWeight fontWeight) async {
    return updateTheme(theme!.copyWith(
      fontWeight: fontWeight,
    ));
  }

  Future<void> resetFontStyle() {
    return updateTheme(theme!.copyWith(
      fontFamily: ThemeConstant.defaultFontFamily,
      fontWeight: ThemeConstant.defaultFontWeight,
    ));
  }

  // theme mode
  Future<void> setThemeMode(ThemeMode? value) async {
    if (value != null && value != themeMode) {
      return updateTheme(theme!.copyWith(
        themeMode: value,
      ));
    }
  }

  bool toggleThemeMode() {
    if (themeMode == ThemeMode.system) {
      Brightness? brightness = SchedulerBinding.instance.window.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
      return !isDarkMode;
    } else {
      bool isDarkMode = themeMode == ThemeMode.dark;
      setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
      return !isDarkMode;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    DynamicColorPlugin.getCorePalette().then((result) {
      final light = result?.toColorScheme();
      final dark = result?.toColorScheme(brightness: Brightness.dark);
      if (light == lightDynamic || dark == darkDynamic) {
      } else {
        lightDynamic = result?.toColorScheme();
        darkDynamic = result?.toColorScheme(brightness: Brightness.dark);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
