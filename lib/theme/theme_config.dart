import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:spooky/theme/m3/m3_color.dart';

class ThemeConfig {
  final bool isDarkMode;
  ThemeConfig(this.isDarkMode);

  ThemeConfig.dark() : isDarkMode = true;
  ThemeConfig.light() : isDarkMode = false;

  ThemeData get themeData {
    final scheme = isDarkMode ? ThemeConstant.darkM3Color : ThemeConstant.lightM3Color;
    return ThemeData(
      primaryColor: scheme.primary,
      backgroundColor: scheme.background,
      scaffoldBackgroundColor: scheme.background,
      colorScheme: scheme.toColorScheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.readOnly.surface2,
        centerTitle: false,
        elevation: 0.0,
        foregroundColor: scheme.onSurface,
        iconTheme: IconThemeData(color: scheme.onSurface),
        titleTextStyle: ThemeConstant.textThemeM3.toTextTheme().headline6?.copyWith(color: scheme.onSurface),
      ),
      tabBarTheme: TabBarTheme(),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.readOnly.surface2,
      ),
      splashColor: Colors.transparent,
      // splashFactory:
      // InkRipple.splashFactory, //
      // InkSplash.splashFactory,
      indicatorColor: scheme.onPrimary,
      textTheme: buildTextTheme(scheme),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: scheme.primary,
          onSurface: scheme.onSurface,
          primary: scheme.onPrimary,
        ),
      ),
      cupertinoOverrideTheme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(),
      ),
    );
  }

  TextTheme buildTextTheme(M3Color scheme) {
    final TextTheme theme = ThemeConstant.textThemeM3.toTextTheme();
    return theme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface.withOpacity(0.54),
      decorationColor: scheme.onSurface.withOpacity(0.54),
    );
  }
}
