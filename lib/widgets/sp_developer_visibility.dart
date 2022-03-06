import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/developer_mode_provider.dart';

class SpDeveloperVisibility extends StatelessWidget {
  const SpDeveloperVisibility({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Consumer<DeveloperModeProvider>(
      child: child,
      builder: (context, provider, child) {
        return Visibility(
          visible: provider.developerModeOn,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
