import 'package:flutter/material.dart';
import 'package:spooky/gen/fonts.gen.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';

class ThemeConstant {
  static const List<String> fontFamilyFallback = [
    FontFamily.quicksand,
  ];

  static const lightM3Color = M3Color(
    brightness: Brightness.light,
    primary: Color(0xFF6750A4),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFEADDFF),
    onPrimaryContainer: Color(0xFF21005D),
    secondary: Color(0xFF625B71),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE8DEF8),
    onSecondaryContainer: Color(0xFF1D192B),
    tertiary: Color(0xFF7D5260),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFD8E4),
    onTertiaryContainer: Color(0xFF31111D),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
    background: Color(0xFFFFFBFE),
    onBackground: Color(0xFF1C1B1F),
    surface: Color(0xFFFFFBFE),
    onSurface: Color(0xFF1C1B1F),
    surfaceVariant: Color(0xFFFFFBFE),
    onSurfaceVariant: Color(0xFF49454F),
    outline: Color(0xFF79747E),
  );

  static const darkM3Color = M3Color(
    brightness: Brightness.dark,
    primary: Color(0xFFD0BCFF),
    onPrimary: Color(0xFF381E72),
    primaryContainer: Color(0xFF4F378B),
    onPrimaryContainer: Color(0xFFEADDFF),
    secondary: Color(0xFFCCC2DC),
    onSecondary: Color(0xFF332D41),
    secondaryContainer: Color(0xFF4A4458),
    onSecondaryContainer: Color(0xFFE8DEF8),
    tertiary: Color(0xFFEFB8C8),
    onTertiary: Color(0xFF492532),
    tertiaryContainer: Color(0xFF633B48),
    onTertiaryContainer: Color(0xFFFFD8E4),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
    background: Color(0xFF1C1B1F),
    onBackground: Color(0xFFE6E1E5),
    surface: Color(0xFF1C1B1F),
    onSurface: Color(0xFFE6E1E5),
    surfaceVariant: Color(0xFF49454F),
    onSurfaceVariant: Color(0xFFCAC4D0),
    outline: Color(0xFF938F99),
  );

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
