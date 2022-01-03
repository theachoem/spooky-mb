import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spooky/theme/theme_constant.dart';

class ThemeConfig {
  final bool isDarkMode;
  ThemeConfig(this.isDarkMode);

  ThemeConfig.dark() : isDarkMode = true;
  ThemeConfig.light() : isDarkMode = false;

  ThemeData get themeData {
    final scheme = isDarkMode ? ThemeConstant.darkScheme : ThemeConstant.lightScheme;
    return ThemeData(
      primaryColor: scheme.primary,
      backgroundColor: scheme.background,
      scaffoldBackgroundColor: scheme.background,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        centerTitle: false,
        elevation: 0.0,
        iconTheme: IconThemeData(color: scheme.onSurface),
        titleTextStyle: ThemeConstant.textTheme.headline6?.copyWith(color: scheme.onSurface),
        foregroundColor: scheme.onSurface,
      ),
      splashColor: Colors.transparent,
      // splashFactory:
      // InkRipple.splashFactory, //
      // InkSplash.splashFactory,
      indicatorColor: scheme.onPrimary,
      textTheme: ThemeConstant.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface.withOpacity(0.54),
        decorationColor: scheme.onSurface.withOpacity(0.54),
      ),
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
}
