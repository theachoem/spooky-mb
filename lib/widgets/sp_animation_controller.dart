import 'package:flutter/material.dart';

class SpAnimationController extends AnimationController {
  SpAnimationController({
    super.value,
    super.duration,
    super.reverseDuration,
    super.debugLabel,
    super.lowerBound = 0.0,
    super.upperBound = 1.0,
    super.animationBehavior,
    required super.vsync,
  });

  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}
