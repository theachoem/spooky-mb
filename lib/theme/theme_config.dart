import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class ThemeConfig {
  final bool isDarkMode;
  ThemeConfig(this.isDarkMode);

  ThemeConfig.dark() : isDarkMode = true;
  ThemeConfig.light() : isDarkMode = false;

  ColorScheme get _light => colorScheme(Brightness.light);
  ColorScheme get _dark => colorScheme(Brightness.dark);

  final Color splashColor = Colors.transparent;

  ThemeData get themeData {
    ColorScheme colorScheme = isDarkMode ? _dark : _light;
    TextTheme textTheme = buildTextTheme();
    return ThemeData(
      // platform: TargetPlatform.android,
      useMaterial3: true,
      primaryColor: colorScheme.primary,
      backgroundColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      colorScheme: colorScheme,
      canvasColor: colorScheme.readOnly.surface2,
      toggleableActiveColor: colorScheme.primary,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.readOnly.surface2,
        centerTitle: false,
        elevation: 0.0,
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        extendedTextStyle: textTheme.labelLarge,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface,
        labelStyle: textTheme.titleSmall,
        unselectedLabelStyle: textTheme.titleSmall,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: colorScheme.onPrimaryContainer,
            width: 1,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF323232),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: _light.background),
        actionTextColor: _dark.primary,
        shape: RoundedRectangleBorder(
          borderRadius: ConfigConstant.circlarRadius1,
        ),
      ),
      splashColor: splashColor,
      // splashFactory:
      // InkRipple.splashFactory, //
      // InkSplash.splashFactory,
      indicatorColor: colorScheme.onPrimary,
      textTheme: textTheme,
      textButtonTheme: buildTextButtonStyle(colorScheme),
      cupertinoOverrideTheme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(),
      ),
    );
  }

  TextButtonThemeData buildTextButtonStyle(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        onSurface: colorScheme.onSurface,
        primary: colorScheme.onPrimary,
      ).copyWith(
        overlayColor: MaterialStateProperty.all(splashColor),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.isNotEmpty) {
              switch (states.last) {
                case MaterialState.hovered:
                  return colorScheme.onPrimary.withOpacity(0.1);
                case MaterialState.focused:
                  return colorScheme.onPrimary.withOpacity(0.1);
                case MaterialState.pressed:
                  return colorScheme.onPrimary.withOpacity(0.1);
                case MaterialState.dragged:
                  return colorScheme.onPrimary.withOpacity(0.1);
                case MaterialState.selected:
                  return colorScheme.onPrimary.withOpacity(0.1);
                case MaterialState.scrolledUnder:
                  return colorScheme.onPrimary.withOpacity(0.1);
                case MaterialState.disabled:
                  return colorScheme.onPrimary.withOpacity(0.1);
                case MaterialState.error:
                  return colorScheme.onPrimary.withOpacity(0.1);
              }
            }
            return colorScheme.primary;
          },
        ),
      ),
    );
  }

  static String fontFamily = ThemeConstant.defaultFontFamily;
  static FontWeight fontWeight = ThemeConstant.defaultFontWeight;
  static TextTheme buildTextTheme() {
    return GoogleFonts.getTextTheme(
      fontFamily,
      defaultTextTheme,
    );
  }

  static ColorScheme colorScheme(Brightness brightness) {
    return brightness == Brightness.dark ? M3Color.darkScheme! : M3Color.lightScheme!;
  }

  static FontWeight fontWeightGetter(FontWeight defaultWeight) {
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
    if (defaultWeight == FontWeight.w400) {
      return fontWeight;
    } else {
      int index = fontWeight.index + 1;
      if (fontWeights.containsKey(index)) {
        return fontWeights[index]!;
      } else {
        return fontWeight;
      }
    }
  }

  static TextTheme get defaultTextTheme {
    return TextTheme(
      displayLarge: TextStyle(
        fontWeight: fontWeightGetter(FontWeight.w400),
        fontSize: 57,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        fontWeight: fontWeightGetter(FontWeight.w400),
        fontSize: 45,
      ),
      displaySmall: TextStyle(
        fontWeight: fontWeightGetter(FontWeight.w400),
        fontSize: 36,
        letterSpacing: 0.5,
      ),
      headlineLarge: TextStyle(
        fontWeight: fontWeightGetter(FontWeight.w400),
        fontSize: 32,
      ),
      headlineMedium: TextStyle(
        fontWeight: fontWeightGetter(FontWeight.w400),
        fontSize: 28,
      ),
      headlineSmall: TextStyle(
        fontWeight: fontWeightGetter(FontWeight.w400),
        fontSize: 24,
      ),
      titleLarge: TextStyle(
        fontWeight: fontWeightGetter(FontWeight.w400),
        fontSize: 22,
      ),
      titleMedium: TextStyle(
        fontWeight: fontWeightGetter(FontWeight.w400),
        fontSize: 16,
        letterSpacing: 0.1,
      ),
      titleSmall: TextStyle(
        fontWeight: fontWeightGetter(FontWeight.w500),
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      labelLarge: TextStyle(
        fontWeight: fontWeightGetter(FontWeight.w500),
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontWeight: fontWeightGetter(FontWeight.w500),
        fontSize: 12,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontWeight: fontWeightGetter(FontWeight.w500),
        fontSize: 11,
        letterSpacing: 0.5,
      ),
      bodyLarge: TextStyle(
        fontWeight: fontWeightGetter(FontWeight.w400),
        fontSize: 16,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontWeight: fontWeightGetter(FontWeight.w400),
        fontSize: 14,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontWeight: fontWeightGetter(FontWeight.w400),
        fontSize: 12,
        letterSpacing: 0.4,
      ),
    );
  }
}
