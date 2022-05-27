import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBuilder extends StatelessWidget {
  const AppBuilder({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle overlay = fetchOverlayStyle(context);
    SystemChrome.setSystemUIOverlayStyle(overlay);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlay,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }

  SystemUiOverlayStyle fetchOverlayStyle(BuildContext context) {
    SystemUiOverlayStyle overlay = fetchOverlay(context);
    return overlay.copyWith(systemNavigationBarColor: Theme.of(context).appBarTheme.backgroundColor);
  }

  SystemUiOverlayStyle fetchOverlay(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return SystemUiOverlayStyle.dark;
    } else {
      return SystemUiOverlayStyle.light;
    }
  }
}
