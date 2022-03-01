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

  static String fontFamily = "Quicksand";
  static TextTheme buildTextTheme() {
    return GoogleFonts.getTextTheme(
      fontFamily,
      ThemeConstant.defaultTextTheme,
    );
  }

  static ColorScheme colorScheme(Brightness brightness) {
    return brightness == Brightness.dark ? M3Color.darkScheme! : M3Color.lightScheme!;
  }
}
