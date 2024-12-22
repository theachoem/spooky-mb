import 'dart:math' as math;
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/theme_provider.dart';

class AppTheme extends StatelessWidget {
  const AppTheme({
    super.key,
    required this.builder,
  });

  final Widget Function(ThemeData theme, ThemeData darkTheme, ThemeMode themeMode) builder;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return buildColorScheme(
        provider: provider,
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          final theme = getTheme(ThemeData.light(), lightDynamic, provider);
          final darkTheme = getTheme(ThemeData.dark(), darkDynamic, provider);
          return builder(theme, darkTheme, provider.themeMode);
        },
      );
    });
  }

  ThemeData getTheme(ThemeData theme, ColorScheme? colorScheme, ThemeProvider provider) {
    TextStyle calculateTextStyle(TextStyle textStyle, FontWeight defaultFontWeight) {
      return textStyle.copyWith(fontWeight: calculateFontWeight(defaultFontWeight, provider.theme.fontWeight));
    }

    return theme.copyWith(
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(centerTitle: false),
      drawerTheme: const DrawerThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        endShape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      textTheme: GoogleFonts.getTextTheme(
        provider.theme.fontFamily,
        TextTheme(
          displayLarge: calculateTextStyle(theme.textTheme.displayLarge!, FontWeight.w400),
          displayMedium: calculateTextStyle(theme.textTheme.displayMedium!, FontWeight.w400),
          displaySmall: calculateTextStyle(theme.textTheme.displaySmall!, FontWeight.w400),
          headlineLarge: calculateTextStyle(theme.textTheme.headlineLarge!, FontWeight.w400),
          headlineMedium: calculateTextStyle(theme.textTheme.headlineMedium!, FontWeight.w400),
          headlineSmall: calculateTextStyle(theme.textTheme.headlineSmall!, FontWeight.w400),
          titleLarge: calculateTextStyle(theme.textTheme.titleLarge!, FontWeight.w400),
          titleMedium: calculateTextStyle(theme.textTheme.titleMedium!, FontWeight.w400),
          titleSmall: calculateTextStyle(theme.textTheme.titleSmall!, FontWeight.w500),
          bodyLarge: calculateTextStyle(theme.textTheme.bodyLarge!, FontWeight.w400),
          bodyMedium: calculateTextStyle(theme.textTheme.bodyMedium!, FontWeight.w400),
          bodySmall: calculateTextStyle(theme.textTheme.bodySmall!, FontWeight.w400),
          labelLarge: calculateTextStyle(theme.textTheme.labelLarge!, FontWeight.w500),
          labelMedium: calculateTextStyle(theme.textTheme.labelMedium!, FontWeight.w500),
          labelSmall: calculateTextStyle(theme.textTheme.labelSmall!, FontWeight.w500),
        ),
      ),
    );
  }

  Widget buildColorScheme({
    required ThemeProvider provider,
    required Widget Function(ColorScheme? lightDynamic, ColorScheme? darkDynamic) builder,
  }) {
    if (provider.theme.colorSeed == Colors.black || provider.theme.colorSeed == Colors.white) {
      final darkScheme = ColorScheme.dark(
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: Colors.white,
        onSecondary: Colors.black,
        error: Colors.red[200]!,
        onError: Colors.white,
        surface: Colors.black,
        onSurface: Colors.white,
        surfaceContainerHighest: Colors.white,
        secondaryContainer: Color.alphaBlend(Colors.white.withValues(alpha: 0.14), Colors.black),
        onSecondaryContainer: Colors.white,
      );

      final lightScheme = ColorScheme.light(
        primary: Colors.black87,
        onPrimary: Colors.white,
        secondary: Colors.black,
        onSecondary: Colors.white,
        error: Colors.red[600]!,
        onError: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
        surfaceContainerHighest: Colors.white,
        secondaryContainer: Color.alphaBlend(Colors.white.withValues(alpha: 0.14), Colors.white),
        onSecondaryContainer: Colors.black,
      );

      return builder(lightScheme, darkScheme);
    } else if (provider.theme.colorSeed != null) {
      final lightScheme = ColorScheme.fromSeed(seedColor: provider.theme.colorSeed!, brightness: Brightness.light);
      final darkScheme = ColorScheme.fromSeed(seedColor: provider.theme.colorSeed!, brightness: Brightness.dark);
      return builder(lightScheme, darkScheme);
    } else {
      return DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return builder(lightDynamic, darkDynamic);
      });
    }
  }

  FontWeight calculateFontWeight(FontWeight defaultWeight, FontWeight currentWeight) {
    int changeBy = defaultWeight == FontWeight.w400 ? 0 : 1;
    Map<int, FontWeight> fontWeights = {
      0: FontWeight.w100,
      1: FontWeight.w200,
      2: FontWeight.w300,
      3: FontWeight.w400,
      4: FontWeight.w500,
      5: FontWeight.w600,
      6: FontWeight.w700,
      7: FontWeight.w800,
      8: FontWeight.w900,
    };
    int index = currentWeight.index + changeBy;
    return fontWeights[math.max(math.min(8, index), 0)]!;
  }
}