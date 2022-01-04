import 'package:flutter/material.dart';
import 'package:spooky/main.dart';

class M3TextTheme {
  static M3TextTheme? of(BuildContext context) {
    return App.of(context)?.textTheme;
  }

  final List<String> fontFamilyFallback;

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;

  // Android + Web
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;

  // Android + Web
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  // Android + Web
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;

  const M3TextTheme({
    required this.fontFamilyFallback,
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
  });

  TextTheme toTextTheme() {
    return TextTheme(
      headline1: TextStyle(
        fontSize: 98,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
        fontFamilyFallback: fontFamilyFallback,
      ),
      headline2: TextStyle(
        fontSize: 61,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
        fontFamilyFallback: fontFamilyFallback,
      ),
      headline3: TextStyle(
        fontSize: 49,
        fontWeight: FontWeight.w400,
        fontFamilyFallback: fontFamilyFallback,
      ),
      headline4: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        fontFamilyFallback: fontFamilyFallback,
      ),
      headline5: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        fontFamilyFallback: fontFamilyFallback,
      ),
      headline6: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        fontFamilyFallback: fontFamilyFallback,
      ),
      subtitle1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        fontFamilyFallback: fontFamilyFallback,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        fontFamilyFallback: fontFamilyFallback,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        fontFamilyFallback: fontFamilyFallback,
      ),
      bodyText2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        fontFamilyFallback: fontFamilyFallback,
      ),
      button: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
        fontFamilyFallback: fontFamilyFallback,
      ),
      caption: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        fontFamilyFallback: fontFamilyFallback,
      ),
      overline: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
        fontFamilyFallback: fontFamilyFallback,
      ),
    );
  }
}
