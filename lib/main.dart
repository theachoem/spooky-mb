import 'package:easy_localization/easy_localization.dart';
import 'package:spooky/theme/theme_config.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:spooky/core/locator.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/route/router.gr.dart' as r;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  setupLocator();
  runApp(
    EasyLocalization(
      supportedLocales: AppConstant.supportedLocales,
      fallbackLocale: AppConstant.fallbackLocale,
      path: 'assets/translations',
      child: App(),
    ),
  );
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
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeConfig.light().themeData,
      darkTheme: ThemeConfig.dark().themeData,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
