import 'dart:ui';

class AppConstant {
  AppConstant._internal();
  static const String appName = 'Spooky';

  static const supportedLocales = [
    Locale('en'),
    Locale('km'),
  ];

  static const fallbackLocale = Locale('en');
  static const String documentExstension = "json";
}
