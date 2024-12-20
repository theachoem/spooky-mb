import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spooky/app_theme.dart';
import 'package:spooky/routes/router.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppTheme(builder: (theme, darkTheme, themeMode) {
      return MaterialApp.router(
        routerConfig: $router,
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        scrollBehavior: Platform.isIOS ? null : const ScrollBehavior().copyWith(overscroll: false),
        theme: theme,
        darkTheme: darkTheme,
      );
    });
  }
}
