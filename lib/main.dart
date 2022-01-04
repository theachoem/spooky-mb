import 'package:spooky/theme/theme_config.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:spooky/core/locator.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/route/router.gr.dart' as r;

void main() {
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  App({
    Key? key,
  }) : super(key: key);

  final r.Router _appRouter = r.Router(
    StackedService.navigatorKey,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeConfig.light().themeData,
      darkTheme: ThemeConfig.dark().themeData,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
