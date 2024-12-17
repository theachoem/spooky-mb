import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SpFadeIn extends StatelessWidget {
  const SpFadeIn({
    super.key,
    required this.child,
    this.duration = Durations.medium1,
    this.curve = Curves.ease,
    this.builder,
    this.delay,
  });

  final Widget child;
  final Curve curve;
  final Duration? delay;
  final Duration duration;
  final Widget Function(BuildContext, double lerp, Widget child)? builder;

  factory SpFadeIn.fromLeft({
    required Widget child,
    Duration? delay,
  }) {
    return SpFadeIn(
      delay: delay,
      builder: (context, lerp, child) {
        return Transform(
          transform: Matrix4.identity()..translate(lerpDouble(-4.0, 0, lerp)!, 0.0),
          child: child,
        );
      },
      child: child,
    );
  }

  factory SpFadeIn.fromRight({
    required Widget child,
    Duration? delay,
  }) {
    return SpFadeIn(
      delay: delay,
      builder: (context, lerp, child) {
        return Transform(
          transform: Matrix4.identity()..translate(lerpDouble(4.0, 0, lerp)!, 0.0),
          child: child,
        );
      },
      child: child,
    );
  }

  factory SpFadeIn.fromTop({
    required Widget child,
    Duration? delay,
  }) {
    return SpFadeIn(
      delay: delay,
      builder: (context, lerp, child) {
        return Transform(
          transform: Matrix4.identity()..translate(0.0, lerpDouble(-4.0, 0, lerp)!),
          child: child,
        );
      },
      child: child,
    );
  }

  factory SpFadeIn.fromBottom({
    required Widget child,
    Duration? delay,
    Duration duration = Durations.medium1,
  }) {
    return SpFadeIn(
      delay: delay,
      duration: duration,
      builder: (context, lerp, child) {
        return Transform(
          transform: Matrix4.identity()..translate(0.0, lerpDouble(4.0, 0, lerp)!),
          child: child,
        );
      },
      child: child,
    );
  }

  factory SpFadeIn.bound({
    required Widget child,
    Duration? delay,
  }) {
    return SpFadeIn(
      delay: delay,
      duration: Durations.medium1,
      builder: (context, lerp, child) {
        return AnimatedContainer(
          duration: Durations.medium1,
          transform: Matrix4.identity()..scale(lerp > 0.2 ? 1.0 : 0.9),
          transformAlignment: Alignment.center,
          curve: Curves.ease,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return child;
    if (delay != null) {
      return FutureBuilder<int>(
        future: Future.delayed(delay!).then((value) => 1),
        builder: (context, snapshot) {
          return Visibility(
            visible: snapshot.data == 1,
            child: buildAnimatedChild(),
          );
        },
      );
    } else {
      return buildAnimatedChild();
    }
  }

  Widget buildAnimatedChild() {
    return _AnimationState(
      duration: duration,
      curve: curve,
      builder: (context, controller) {
        return FadeTransition(
          opacity: controller,
          child: builder != null
              ? AnimatedBuilder(
                  animation: controller,
                  child: child,
                  builder: (context, child) {
                    return builder!(context, controller.value, child!);
                  },
                )
              : child,
        );
      },
    );
  }
}

class _AnimationState extends StatefulWidget {
  const _AnimationState({
    required this.duration,
    required this.curve,
    required this.builder,
  });

  final Duration duration;
  final Curve curve;
  final Widget Function(BuildContext context, AnimationController controller) builder;

  @override
  State<_AnimationState> createState() => __AnimationStateState();
}

class __AnimationStateState extends State<_AnimationState> with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..drive(CurveTween(curve: widget.curve))
      ..forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, controller);
  }
}
