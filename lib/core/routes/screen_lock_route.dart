import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:animations/animations.dart';

typedef _LockBuilder = ScreenLock Function(
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

  final _LockBuilder builder;

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
    return FadeScaleTransition(
      animation: animation,
      child: child,
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => false;
}
