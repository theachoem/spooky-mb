import 'package:stacked_services/stacked_services.dart';

import 'core/locator.dart';
import 'package:flutter/material.dart';
import 'core/route/router.gr.dart' as r;

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
  }) : super(key: key);

  final r.Router _appRouter = r.Router(
    locator<NavigationService>().navigatorKey,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
