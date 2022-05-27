import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/app_helper.dart';

class ThemeConfig {
  final bool isDarkMode;
  final String fontFamily;
  final FontWeight fontWeight;
  final ColorScheme? colorScheme;

  ThemeConfig(
    this.isDarkMode,
    this.fontFamily,
    this.fontWeight,
    this.colorScheme,
  );

  factory ThemeConfig.light() {
    return ThemeConfig.fromDarkMode(false);
  }

  factory ThemeConfig.dark() {
    return ThemeConfig.fromDarkMode(true);
  }

  ThemeConfig.fromDarkMode(this.isDarkMode)
      : fontFamily = ThemeConstant.defaultFontFamily,
        fontWeight = ThemeConstant.defaultFontWeight,
        colorScheme = null;

  ColorScheme get _light => M3Color.colorScheme(Brightness.light);
  ColorScheme get _dark => M3Color.colorScheme(Brightness.dark);

  ThemeData get themeData {
    ColorScheme colorScheme = this.colorScheme ?? (isDarkMode ? _dark : _light);
    TextTheme textTheme = buildTextTheme();

    final themeData = ThemeData(
      // platform: TargetPlatform.android,
      useMaterial3: true,
      applyElevationOverlayColor: true,
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
        enableFeedback: true,
        backgroundColor: colorScheme.secondaryContainer,
        foregroundColor: colorScheme.onSecondaryContainer,
        extendedPadding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2 + 4),
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(overflow: TextOverflow.ellipsis),
        ),
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
      // splashColor: ThemeConstant.splashColor,
      indicatorColor: colorScheme.onPrimary,
      textTheme: textTheme,
      textButtonTheme: buildTextButtonStyle(colorScheme),
      cupertinoOverrideTheme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(),
      ),
    );

    return themeData.copyWith(
      splashFactory: isApple(themeData.platform) ? NoSplash.splashFactory : InkSparkle.splashFactory,
      // InkSparkle.splashFactory,
      // InkRipple.splashFactory,
      // InkSplash.splashFactory,
      // NoSplash.splashFactory
    );
  }

  bool isApple(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
    }
  }

  TextButtonThemeData buildTextButtonStyle(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        onSurface: colorScheme.onSurface,
        primary: colorScheme.onPrimary,
      ).copyWith(
        overlayColor: MaterialStateProperty.all(ThemeConstant.splashColor),
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

  TextTheme buildTextTheme() {
    return GoogleFonts.getTextTheme(
      fontFamily,
      _defaultTextTheme,
    );
  }

  TextTheme get _defaultTextTheme {
    return TextTheme(
      displayLarge: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 57,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 45,
      ),
      displaySmall: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 36,
        letterSpacing: 0.5,
      ),
      headlineLarge: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 32,
      ),
      headlineMedium: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 28,
      ),
      headlineSmall: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 24,
      ),
      titleLarge: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 22,
      ),
      titleMedium: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 16,
        letterSpacing: 0.1,
      ),
      titleSmall: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w500, fontWeight),
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      labelLarge: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w500, fontWeight),
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w500, fontWeight),
        fontSize: 12,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w500, fontWeight),
        fontSize: 11,
        letterSpacing: 0.5,
      ),
      bodyLarge: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 16,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 14,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 12,
        letterSpacing: 0.4,
      ),
    );
  }
}
