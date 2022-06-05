import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/theme_provider.dart';
import 'package:spooky/utils/util_widgets/app_builder.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/main.dart';
import 'package:spooky/views/app_starter/app_starter_view.dart';
import 'package:spooky/views/main/main_view.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final RouteObserver<ModalRoute> storyQueryListObserver = RouteObserver<ModalRoute>();

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context, listen: true);
    return MaterialApp(
      navigatorKey: App.navigatorKey,
      themeMode: provider.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: spAppIntiailized ? const MainView() : const AppStarterView(),
      theme: provider.lightTheme,
      darkTheme: provider.darkTheme,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      builder: (context, child) => AppBuilder(child: child),
      onGenerateRoute: (settings) => SpRouteConfig(context: context, settings: settings).generate(),
      navigatorObservers: [
        storyQueryListObserver,
      ],
    );
  }
}
