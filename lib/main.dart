import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/storages/theme_storage.dart';
import 'package:spooky/initializers/database_initializer.dart';
import 'package:spooky/initializers/file_initializer.dart';
import 'package:spooky/provider_scope.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // core
  await FileInitializer.call();
  await DatabaseInitializer.call();

  // ui
  await ThemeStorage.instance.load();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
