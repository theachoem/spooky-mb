import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky_mb/providers/theme_provider.dart';
import 'package:spooky_mb/routes/router.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp.router(
          routerConfig: $router,
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          scrollBehavior: Platform.isIOS ? null : const ScrollBehavior().copyWith(overscroll: false),
          theme: theme(ThemeData.light(), lightDynamic),
          darkTheme: theme(ThemeData.dark(), darkDynamic),
        );
      },
    );
  }

  ThemeData theme(ThemeData theme, ColorScheme? colorScheme) {
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
}
