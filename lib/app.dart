import 'package:flutter/material.dart';
import 'package:spooky_mb/views/home/home_view.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
      home: const HomeView(),
    );
  }
}
