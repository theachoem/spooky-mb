import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/extensions/color_scheme_extension.dart';

class ThemeConfig {
  final bool isDarkMode;
  ThemeConfig(this.isDarkMode);

  ThemeConfig.dark() : isDarkMode = true;
  ThemeConfig.light() : isDarkMode = false;

  ColorScheme get _light => ThemeConstant.colorScheme(Brightness.light);
  ColorScheme get _dark => ThemeConstant.colorScheme(Brightness.dark);

  final Color splashColor = Colors.transparent;

  ThemeData get themeData {
    ColorScheme colorScheme = isDarkMode ? _dark : _light;
    TextTheme textTheme = buildTextTheme(colorScheme);
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
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(extendedTextStyle: ThemeConstant.defaultTextTheme.labelLarge),
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

  TextButtonThemeData buildTextButtonStyle(ColorScheme m3Color) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        onSurface: m3Color.onSurface,
        primary: m3Color.onPrimary,
      ).copyWith(
        overlayColor: MaterialStateProperty.all(splashColor),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.isNotEmpty) {
              switch (states.last) {
                case MaterialState.hovered:
                  return m3Color.onPrimary.withOpacity(0.1);
                case MaterialState.focused:
                  return m3Color.onPrimary.withOpacity(0.1);
                case MaterialState.pressed:
                  return m3Color.onPrimary.withOpacity(0.1);
                case MaterialState.dragged:
                  return m3Color.onPrimary.withOpacity(0.1);
                case MaterialState.selected:
                  return m3Color.onPrimary.withOpacity(0.1);
                case MaterialState.scrolledUnder:
                  return m3Color.onPrimary.withOpacity(0.1);
                case MaterialState.disabled:
                  return m3Color.onPrimary.withOpacity(0.1);
                case MaterialState.error:
                  return m3Color.onPrimary.withOpacity(0.1);
              }
            }
            return m3Color.primary;
          },
        ),
      ),
    );
  }

  TextTheme buildTextTheme(ColorScheme colorScheme) {
    return ThemeConstant.defaultTextTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
      decorationColor: colorScheme.onSurface,
    );
  }
}
