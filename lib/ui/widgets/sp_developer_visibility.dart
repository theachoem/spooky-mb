import 'package:flutter/material.dart';
import 'package:spooky/app.dart';

class SpDeveloperVisibility extends StatelessWidget {
  const SpDeveloperVisibility({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool>? notifier = App.of(context)?.developerModeNotifier;
    if (notifier == null) return SizedBox.shrink();
    return ValueListenableBuilder<bool>(
      valueListenable: App.of(context)!.developerModeNotifier,
      child: child,
      builder: (context, isDeveloperMode, child) {
        return Visibility(
          visible: isDeveloperMode,
          child: child ?? SizedBox.shrink(),
        );
      },
    );
  }
}
