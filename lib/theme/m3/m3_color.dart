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
    if (seedColor == Colors.black || seedColor == Colors.white) {
      darkScheme = ColorScheme.dark(
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: Colors.white,
        onSecondary: Colors.black,
        error: Colors.red[200]!,
        onError: Colors.white,
        background: Colors.black,
        onBackground: Colors.white,
        surface: Colors.black,
        onSurface: Colors.white,
        surfaceVariant: Colors.white,
        secondaryContainer: Color.alphaBlend(Colors.white.withOpacity(0.14), Colors.black),
        onSecondaryContainer: Colors.white,
      );

      lightScheme = ColorScheme.light(
        primary: Colors.black87,
        onPrimary: Colors.white,
        secondary: Colors.black,
        onSecondary: Colors.white,
        error: Colors.red[600]!,
        onError: Colors.black,
        background: Colors.white,
        onBackground: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
        surfaceVariant: Colors.white,
        secondaryContainer: Color.alphaBlend(Colors.white.withOpacity(0.14), Colors.white),
        onSecondaryContainer: Colors.black,
      );
    } else {
      darkScheme = await M3Color.getScheme(true, seedColor);
      lightScheme = await M3Color.getScheme(false, seedColor);
    }
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
