import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_read_only_color.dart';
import 'package:spooky/theme/theme_constant.dart';
export '../../utils/extension/color_extension.dart';

class M3Color {
  static M3Color? of(BuildContext context) {
    bool isDarkMode = Theme.of(context).colorScheme.brightness == Brightness.dark;
    return isDarkMode ? ThemeConstant.darkM3Color : ThemeConstant.lightM3Color;
  }

  M3ReadOnlyColor get readOnly => M3ReadOnlyColor(this);

  final Brightness brightness;

  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;

  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;

  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;

  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;

  final Color background;
  final Color onBackground;

  final Color surface;
  final Color onSurface;

  final Color surfaceVariant;
  final Color onSurfaceVariant;

  final Color outline;

  const M3Color({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
  });

  ColorScheme toColorScheme() {
    return ColorScheme(
      primary: primary,
      primaryVariant: primary,
      secondary: secondary,
      secondaryVariant: secondary,
      surface: surface,
      background: background,
      error: error,
      onPrimary: onPrimary,
      onSecondary: onSecondary,
      onSurface: onSurface,
      onBackground: onBackground,
      onError: onError,
      brightness: brightness,
    );
  }
}
