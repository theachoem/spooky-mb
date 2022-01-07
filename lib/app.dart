import 'package:easy_localization/easy_localization.dart';
import 'package:spooky/app_builder.dart';
import 'package:spooky/theme/theme_config.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/mixins/scaffold_messenger_mixin.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/route/router.dart' as route;

class App extends StatefulWidget {
  const App({
    Key? key,
    required this.themeMode,
  }) : super(key: key);

  final ThemeMode themeMode;

  static _AppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AppState>();
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with ScaffoldMessengerMixin {
  late route.AppRouter _appRouter;
  late M3TextTheme textTheme;

  @override
  void initState() {
    _appRouter = route.AppRouter(StackedService.navigatorKey);
    textTheme = ThemeConstant.textThemeM3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeConfig.light().themeData,
      darkTheme: ThemeConfig.dark().themeData,
      themeMode: widget.themeMode,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      builder: (context, child) => AppBuilder(child: child),
    );
  }
}
