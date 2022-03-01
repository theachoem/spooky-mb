import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/color_seed_provider.dart';
import 'package:spooky/utils/util_widgets/app_builder.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/main.dart';
import 'package:spooky/views/app_starter/app_starter_view.dart';
import 'package:spooky/views/main/main_view.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.themeMode,
  }) : super(key: key);

  final ThemeMode themeMode;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    ColorSeedProvider provider = Provider.of<ColorSeedProvider>(context, listen: true);
    return MaterialApp(
      navigatorKey: App.navigatorKey,
      themeMode: themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: spAppIntiailized ? MainView() : AppStarterView(),
      theme: provider.lightTheme,
      darkTheme: provider.darkTheme,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      builder: (context, child) => AppBuilder(child: child),
      onGenerateRoute: (settings) => SpRouteConfig(context: context, settings: settings).generate(),
    );
  }
}
