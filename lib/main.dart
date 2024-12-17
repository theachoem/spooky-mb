import 'package:flutter/material.dart';
import 'package:spooky_mb/app.dart';
import 'package:spooky_mb/initializers/database_initializer.dart';
import 'package:spooky_mb/initializers/file_initializer.dart';
import 'package:spooky_mb/provider_scope.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FileInitializer.call();
  await DatabaseInitializer.call();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
