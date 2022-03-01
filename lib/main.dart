import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:spooky/core/notification/notification_service.dart';
import 'package:spooky/core/services/initial_tab_service.dart';
import 'package:spooky/core/storages/local_storages/nickname_storage.dart';
import 'package:spooky/initial_theme.dart';
import 'package:spooky/provider_scope.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:spooky/utils/helpers/file_helper.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'package:spooky/firebase_options.dart';
// import 'package:spooky/utils/helpers/debug_error_exception.dart';

bool spFlutterTest = Platform.environment.containsKey('FLUTTER_TEST');
bool spAppIntiailized = false;

void main() async {
  await _initialize();
  runApp(
    Phoenix(
      child: EasyLocalization(
        supportedLocales: AppConstant.supportedLocales,
        fallbackLocale: AppConstant.fallbackLocale,
        path: 'assets/translations',
        child: ProviderScope(
          child: const InitialTheme(),
        ),
      ),
    ),
  );
}

Future<void> _initialize() async {
  // core
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  tz.initializeTimeZones();
  await FileHelper.initialFile();

  // ui
  spAppIntiailized = await NicknameStorage().read() != null;
  NotificationService.initialize();
  await M3Color.initialize();
  await InitialStoryTabService.initialize();
  if (Platform.isFuchsia || Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    await DesktopWindow.setMinWindowSize(Size(320, 510));
  }

  // debug
  // FlutterError.onError = (details) => DebugErrorException.run(details);
}
