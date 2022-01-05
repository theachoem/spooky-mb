import 'package:flutter/material.dart';

class AppBuilder extends StatelessWidget {
  const AppBuilder({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        return FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
