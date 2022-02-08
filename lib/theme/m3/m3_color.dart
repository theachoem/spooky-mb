import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/storages/color_storage.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:spooky/utils/constants/util_colors_constant.dart';
export '../../utils/extensions/color_extension.dart';
export '../../utils/extensions/color_scheme_extension.dart';

class M3Color {
  /// Use `M3Color.of(context)` instead of `Theme.of(context).colorScheme`
  static ColorScheme of(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  static Color currentPrimaryColor = ThemeConstant.fallbackColor;
  static ColorScheme? darkScheme;
  static ColorScheme? lightScheme;

  static Future<void> initialize() async {
    int? color = await ColorStorage().read();
    if (color != null) currentPrimaryColor = Color(color);
    darkScheme = await M3Color.getScheme(true, currentPrimaryColor);
    lightScheme = await M3Color.getScheme(false, currentPrimaryColor);
  }

  static Map<int, Color> dayColorsOf(BuildContext context) {
    bool isDarkMode = Theme.of(context).colorScheme.brightness == Brightness.dark;
    return isDarkMode ? colorsByDayDark : colorsByDayLight;
  }

  static Brightness keyboardAppearance(BuildContext context) {
    return Theme.of(context).colorScheme.brightness;
  }

  static ColorScheme darkSchemeFromSeed(Color seedColor) {
    return ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark);
  }

  static ColorScheme lightSchemeFromSeed(Color seedColor) {
    return ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.light);
  }

  static Future<ColorScheme> getScheme(bool isDarkMode, Color color) async {
    return compute(isDarkMode ? darkSchemeFromSeed : lightSchemeFromSeed, color);
  }
}
