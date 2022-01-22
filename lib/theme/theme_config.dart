import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class ThemeConfig {
  final bool isDarkMode;
  ThemeConfig(this.isDarkMode);

  ThemeConfig.dark() : isDarkMode = true;
  ThemeConfig.light() : isDarkMode = false;

  M3Color get _light => ThemeConstant.lightM3Color;
  M3Color get _dark => ThemeConstant.darkM3Color;

  final Color splashColor = Colors.transparent;
  ThemeData get themeData {
    M3Color m3Color = isDarkMode ? _dark : _light;
    M3TextTheme m3TextTheme = buildTextTheme(m3Color);
    return ThemeData(
      // platform: TargetPlatform.android,
      primaryColor: m3Color.primary,
      backgroundColor: m3Color.background,
      scaffoldBackgroundColor: m3Color.background,
      colorScheme: m3Color.toColorScheme(),
      canvasColor: m3Color.readOnly.surface2,
      toggleableActiveColor: m3Color.primary,
      appBarTheme: AppBarTheme(
        backgroundColor: m3Color.readOnly.surface2,
        centerTitle: false,
        elevation: 0.0,
        foregroundColor: m3Color.onSurface,
        iconTheme: IconThemeData(color: m3Color.onSurface),
        titleTextStyle: m3TextTheme.titleLarge.copyWith(color: m3Color.onSurface),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(extendedTextStyle: ThemeConstant.textThemeM3.labelLarge),
      tabBarTheme: TabBarTheme(
        labelColor: m3Color.primary,
        unselectedLabelColor: m3Color.onSurface,
        labelStyle: m3TextTheme.titleSmall,
        unselectedLabelStyle: m3TextTheme.titleSmall,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: m3Color.onPrimaryContainer,
            width: 1,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF323232),
        contentTextStyle: m3TextTheme.bodyMedium.copyWith(color: _light.background),
        actionTextColor: _dark.primary,
        shape: RoundedRectangleBorder(
          borderRadius: ConfigConstant.circlarRadius1,
        ),
      ),
      splashColor: splashColor,
      // splashFactory:
      // InkRipple.splashFactory, //
      // InkSplash.splashFactory,
      indicatorColor: m3Color.onPrimary,
      textTheme: m3TextTheme.toTextTheme(),
      textButtonTheme: buildTextButtonStyle(m3Color),
      cupertinoOverrideTheme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(),
      ),
    );
  }

  TextButtonThemeData buildTextButtonStyle(M3Color m3Color) {
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

  M3TextTheme buildTextTheme(M3Color m3Color) {
    return ThemeConstant.textThemeM3.apply(
      bodyColor: m3Color.onSurface,
      displayColor: m3Color.onSurface,
      decorationColor: m3Color.onSurface,
    );
  }
}
