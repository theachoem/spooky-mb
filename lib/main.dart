import 'package:easy_localization/easy_localization.dart';
import 'package:spooky/app.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/core/locator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  setupLocator();
  runApp(
    EasyLocalization(
      supportedLocales: AppConstant.supportedLocales,
      fallbackLocale: AppConstant.fallbackLocale,
      path: 'assets/translations',
      child: InitialTheme(),
    ),
  );
}

class InitialTheme extends StatelessWidget {
  const InitialTheme({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(colorScheme: ThemeConstant.lightM3Color.toColorScheme()),
      darkTheme: ThemeData(colorScheme: ThemeConstant.darkM3Color.toColorScheme()),
      home: App(),
    );
  }
}
