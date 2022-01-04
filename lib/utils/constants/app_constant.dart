import 'dart:ui';

class AppConstant {
  AppConstant._internal();
  static const String appName = 'Spooky';

  static const supportedLocales = [
    Locale('en', 'US'),
    Locale('de', 'DE'),
  ];

  static const fallbackLocale = Locale('en');
}
