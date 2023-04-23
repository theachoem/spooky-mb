import 'dart:ui';

class AppConstant {
  AppConstant._internal();
  static const String appName = 'Spooky';
  static const String driveFolderName = appName;
  static const Duration deleteInDuration = Duration(days: 30);

  static const supportedLocales = [
    Locale('en'),
    Locale('km'),
    Locale('zh', 'rCN'),
  ];

  static const fallbackLocale = Locale('en');
  static const String documentExstension = "json";
  static Duration lockLifeDefaultCircleDuration = const Duration(seconds: 20);
}
