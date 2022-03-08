import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:spooky/core/models/theme_model.dart';
import 'package:spooky/core/storages/local_storages/theme_storage.dart';
import 'package:spooky/theme/theme_config.dart';
import 'package:spooky/theme/theme_constant.dart';

class ThemeProvider extends ChangeNotifier {
  // initializer
  static ThemeModel? theme;
  static final ThemeStorage storage = ThemeStorage();

  static Future<void> initialize() async {
    theme = await storage.readObject();
  }

  // states
  String get fontFamily => theme?.fontFamily ?? ThemeConstant.defaultFontFamily;
  FontWeight get fontWeight => theme?.fontWeight ?? ThemeConstant.defaultFontWeight;
  ThemeMode get themeMode => theme?.themeMode ?? ThemeMode.system;
  Color get colorSeed => theme?.colorSeed ?? ThemeConstant.fallbackColor;

  ThemeData get lightTheme => ThemeConfig(false, fontFamily, fontWeight).themeData;
  ThemeData get darkTheme => ThemeConfig(true, fontFamily, fontWeight).themeData;

  Future<void> load() async {
    theme = await storage.readObject();
    notifyListeners();
  }

  Future<void> updateTheme(ThemeModel _theme) async {
    await storage.writeObject(_theme);
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
      Brightness? brightness = SchedulerBinding.instance?.window.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
      return !isDarkMode;
    } else {
      bool isDarkMode = themeMode == ThemeMode.dark;
      setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
      return !isDarkMode;
    }
  }
}
