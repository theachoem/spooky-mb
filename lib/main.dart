import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/storages/theme_storage.dart';
import 'package:spooky/firebase_options.dart';
import 'package:spooky/initializers/database_initializer.dart';
import 'package:spooky/initializers/file_initializer.dart';
import 'package:spooky/initializers/local_auth_initializer.dart';
import 'package:spooky/initializers/user_initializer.dart';
import 'package:spooky/provider_scope.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // core
  await UserInitializer.call();
  await FileInitializer.call();
  await DatabaseInitializer.call();
  await LocalAuthInitializer.call();

  // ui
  await ThemeStorage.instance.load();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
