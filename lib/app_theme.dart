import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
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
          final theme = getTheme(ThemeData.light(), lightDynamic);
          final darkTheme = getTheme(ThemeData.dark(), darkDynamic);
          return builder(theme, darkTheme, provider.themeMode);
        },
      );
    });
  }

  ThemeData getTheme(ThemeData theme, ColorScheme? colorScheme) {
    return theme.copyWith(
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(centerTitle: false),
      drawerTheme: const DrawerThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        endShape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
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
}
