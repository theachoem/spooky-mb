import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:spooky/core/models/theme_model.dart';
import 'package:spooky/core/storages/local_storages/theme_storage.dart';
import 'package:spooky/theme/theme_config.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:material_color_utilities/palettes/core_palette.dart';

// import 'package:flutter/services.dart';
// import 'package:spooky/theme/m3/m3_color.dart';

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
    setNavigationBarColor();
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
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    setNavigationBarColor();
  }

  bool isDarkMode() {
    if (themeMode == ThemeMode.system) {
      Brightness? brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void setNavigationBarColor() {
    // ColorScheme scheme = isDarkMode() ? darkTheme.colorScheme : lightTheme.colorScheme;
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: scheme.readOnly.surface2,
    //     systemStatusBarContrastEnforced: true,
    //     systemNavigationBarColor: scheme.readOnly.surface2,
    //   ),
    // );
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
    setNavigationBarColor();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
