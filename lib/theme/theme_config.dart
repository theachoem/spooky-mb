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
      splashColor: Colors.transparent,
      // splashFactory:
      // InkRipple.splashFactory, //
      // InkSplash.splashFactory,
      indicatorColor: m3Color.onPrimary,
      textTheme: m3TextTheme.toTextTheme(),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: m3Color.primary,
          onSurface: m3Color.onSurface,
          primary: m3Color.onPrimary,
        ),
      ),
      cupertinoOverrideTheme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(),
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
