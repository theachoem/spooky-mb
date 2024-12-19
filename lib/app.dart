import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky_mb/providers/theme_provider.dart';
import 'package:spooky_mb/views/home/home_view.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
          theme: theme(ThemeData.light(), lightDynamic),
          darkTheme: theme(ThemeData.dark(), darkDynamic),
          home: const HomeView(),
        );
      },
    );
  }

  ThemeData theme(ThemeData theme, ColorScheme? colorScheme) {
    return theme.copyWith(
      colorScheme: colorScheme,
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
        ),
      ),
    );
  }
}
