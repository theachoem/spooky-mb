import 'dart:ui';

class AppConstant {
  AppConstant._internal();
  static const String appName = 'Spooky';
  static const String driveFolderName = appName;
  static const String privacyPolicy = 'https://github.com/juniorise/spooky/wiki/Privacy-Policy';
  static const String telegramChannel = 'https://t.me/spookyjuniorise';
  static const String facebookGroup = 'https://www.facebook.com/groups/593901148915391';
  static const String customerSupport = 'https://t.me/spookymb';
  static const Duration deleteInDuration = Duration(days: 30);

  static const supportedLocales = [
    Locale('en'),
    Locale('km'),
  ];

  static const fallbackLocale = Locale('en');
  static const String documentExstension = "json";
  static Duration lockLifeDefaultCircleDuration = const Duration(seconds: 20);
}
