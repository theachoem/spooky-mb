import 'package:flutter/material.dart';
import 'package:spooky/gen/fonts.gen.dart';
import 'package:spooky/theme/m3/m3_color.dart';

class ThemeConstant {
  static const Color fallbackColor = Color(0xFF6750A4);

  static const List<String> fontFamilyFallback = [FontFamily.quicksand];
  static ColorScheme colorScheme(Brightness brightness) {
    return brightness == Brightness.dark ? M3Color.m3DarkScheme! : M3Color.m3LightScheme!;
  }

  static const TextTheme defaultTextTheme = TextTheme(
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
