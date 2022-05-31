import 'dart:ui';

class AppConstant {
  AppConstant._internal();
  static const String appName = 'Spooky';
  static const String privacyPolicy = 'https://github.com/juniorise/spooky/wiki/Privacy-Policy';

  static const supportedLocales = [
    Locale('en'),
    Locale('km'),
  ];

  static const fallbackLocale = Locale('en');
  static const String documentExstension = "json";
  static Duration lockLifeDefaultCircleDuration = const Duration(seconds: 20);
}
