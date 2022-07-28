import 'package:flutter/material.dart';

typedef LockBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
);

class ScreenLockRoute<T> extends PageRoute<T> {
  ScreenLockRoute({
    this.barrierColor,
    required this.builder,
  });

  @override
  final Color? barrierColor;

  final LockBuilder builder;

  @override
  bool get fullscreenDialog => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context, animation, secondaryAnimation);
  }

  @override
  bool get opaque => false;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    return theme.buildTransitions(this, context, animation, secondaryAnimation, child);
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => false;
}
