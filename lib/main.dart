import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/initializers/database_initializer.dart';
import 'package:spooky/initializers/file_initializer.dart';
import 'package:spooky/provider_scope.dart';

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
