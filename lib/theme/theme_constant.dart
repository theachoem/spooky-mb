import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/gen/fonts.gen.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:material_color_utilities/material_color_utilities.dart' as m3;

class ThemeConstant {
  static m3.Scheme? m3DarkScheme;
  static m3.Scheme? m3LightScheme;

  static Future<void> initialize() async {
    m3DarkScheme = await getScheme(true, Color(0xFF6750A4));
    m3LightScheme = await getScheme(false, Color(0xFF6750A4));
  }

  static const List<String> fontFamilyFallback = [
    FontFamily.quicksand,
  ];

  static Future<m3.Scheme> getScheme(bool isDarkMode, Color color) async {
    return compute(
      isDarkMode ? m3.Scheme.dark : m3.Scheme.light,
      color.value,
    );
  }

  static M3Color m3Color(Brightness brightness) {
    m3.Scheme color = brightness == Brightness.dark ? m3DarkScheme! : m3LightScheme!;
    return M3Color(
      brightness: brightness,
      primary: Color(color.primary),
      onPrimary: Color(color.onPrimary),
      primaryContainer: Color(color.primaryContainer),
      onPrimaryContainer: Color(color.onPrimaryContainer),
      secondary: Color(color.secondary),
      onSecondary: Color(color.onSecondary),
      secondaryContainer: Color(color.secondaryContainer),
      onSecondaryContainer: Color(color.onSecondaryContainer),
      tertiary: Color(color.tertiary),
      onTertiary: Color(color.onTertiary),
      tertiaryContainer: Color(color.tertiaryContainer),
      onTertiaryContainer: Color(color.onTertiaryContainer),
      error: Color(color.error),
      onError: Color(color.onError),
      errorContainer: Color(color.errorContainer),
      onErrorContainer: Color(color.onErrorContainer),
      background: Color(color.background),
      onBackground: Color(color.onBackground),
      surface: Color(color.surface),
      onSurface: Color(color.onSurface),
      surfaceVariant: Color(color.surfaceVariant),
      onSurfaceVariant: Color(color.onSurfaceVariant),
      outline: Color(color.outline),
    );
  }

  static const M3TextTheme textThemeM3 = M3TextTheme(
    fontFamilyFallback: fontFamilyFallback,
    displayLarge: TextStyle(
      fontFamilyFallback: fontFamilyFallback,
      fontWeight: FontWeight.w400,
      fontSize: 57,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      fontFamilyFallback: fontFamilyFallback,
      fontWeight: FontWeight.w400,
      fontSize: 45,
    ),
    displaySmall: TextStyle(
      fontFamilyFallback: fontFamilyFallback,
      fontWeight: FontWeight.w400,
      fontSize: 36,
      letterSpacing: 0.5,
    ),
    headlineLarge: TextStyle(
      fontFamilyFallback: fontFamilyFallback,
      fontWeight: FontWeight.w400,
      fontSize: 32,
    ),
    headlineMedium: TextStyle(
      fontFamilyFallback: fontFamilyFallback,
      fontWeight: FontWeight.w400,
      fontSize: 28,
    ),
    headlineSmall: TextStyle(
      fontFamilyFallback: fontFamilyFallback,
      fontWeight: FontWeight.w400,
      fontSize: 24,
    ),
    titleLarge: TextStyle(
      fontFamilyFallback: fontFamilyFallback,
      fontWeight: FontWeight.w400,
      fontSize: 22,
    ),
    titleMedium: TextStyle(
      fontFamilyFallback: fontFamilyFallback,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      letterSpacing: 0.1,
    ),
    titleSmall: TextStyle(
      fontFamilyFallback: fontFamilyFallback,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 0.1,
    ),
    labelLarge: TextStyle(
      fontFamilyFallback: fontFamilyFallback,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontFamilyFallback: fontFamilyFallback,
      fontWeight: FontWeight.w500,
      fontSize: 12,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontFamilyFallback: fontFamilyFallback,
      fontWeight: FontWeight.w500,
      fontSize: 11,
      letterSpacing: 0.5,
    ),
    bodyLarge: TextStyle(
      fontFamilyFallback: fontFamilyFallback,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontFamilyFallback: fontFamilyFallback,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontFamilyFallback: fontFamilyFallback,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      letterSpacing: 0.4,
    ),
  );
}
