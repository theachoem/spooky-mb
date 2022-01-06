import 'package:easy_localization/easy_localization.dart';
import 'package:spooky/initial_theme.dart';
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
      child: const InitialTheme(),
    ),
  );
}
