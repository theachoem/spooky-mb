import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spooky/utils/constants/util_colors_constant.dart';
export '../../utils/extensions/color_extension.dart';
export '../../utils/extensions/color_scheme_extension.dart';

class M3Color {
  /// Use `M3Color.of(context)` instead of `Theme.of(context).colorScheme`
  static ColorScheme of(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  static ColorScheme? darkScheme;
  static ColorScheme? lightScheme;

  static ColorScheme colorScheme(Brightness brightness) {
    return brightness == Brightness.dark ? darkScheme! : lightScheme!;
  }

  // call on read & write from theme storage
  static Future<void> setSchemes(Color seedColor) async {
    darkScheme = await M3Color.getScheme(true, seedColor);
    lightScheme = await M3Color.getScheme(false, seedColor);
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

  @Deprecated("Shouldn't be used")
  static SystemUiOverlayStyle systemOverlayStyleFromBg(Color color) {
    Brightness brightness = ThemeData.estimateBrightnessForColor(color);
    return brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
  }
}
