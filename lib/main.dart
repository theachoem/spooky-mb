import 'package:flutter/material.dart';
import 'package:spooky_mb/app.dart';
import 'package:spooky_mb/provider_scope.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
