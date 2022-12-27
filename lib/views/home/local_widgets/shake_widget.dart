// Source: https://github.com/aiyakuaile/flutter_shake_animated

// Copyright 2013 The Flutter Authors. All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
// ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:spooky/widgets/sp_animation_controller.dart';

class ShakeLittleConstant1 implements ShakeConstant {
  @override
  List<int> get interval => [2];

  @override
  List<double> get opacity => const [];

  @override
  List<double> get rotate {
    return const [
      0,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0
    ];
  }

  @override
  List<Offset> get translate {
    return const [
      Offset(0, 0),
      Offset(1, 1),
      Offset(0, 1),
      Offset(0, 1),
      Offset(0, 1),
      Offset(1, 0),
      Offset(0, 1),
      Offset(1, 0),
      Offset(1, 1),
      Offset(1, 0),
      Offset(1, 0),
      Offset(0, 1),
      Offset(1, 1),
      Offset(1, 1),
      Offset(0, 0),
      Offset(0, 1),
      Offset(0, 1),
      Offset(1, 0),
      Offset(0, 0),
      Offset(1, 0),
      Offset(0, 0),
      Offset(1, 0),
      Offset(1, 1),
      Offset(1, 1),
      Offset(1, 1),
      Offset(0, 0),
      Offset(0, 0),
      Offset(0, 0),
      Offset(1, 0),
      Offset(0, 1),
      Offset(1, 0),
      Offset(0, 1),
      Offset(0, 1),
      Offset(0, 0),
      Offset(0, 1),
      Offset(0, 1),
      Offset(0, 1),
      Offset(0, 1),
      Offset(1, 1),
      Offset(1, 1),
      Offset(0, 1),
      Offset(1, 1),
      Offset(0, 1),
      Offset(1, 0),
      Offset(0, 1),
      Offset(0, 1),
      Offset(0, 1),
      Offset(1, 0),
      Offset(1, 1),
      Offset(1, 1),
      Offset(0, 0)
    ];
  }

  @override
  Duration get duration => const Duration(milliseconds: 100);
}

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final ShakeConstant shakeConstant;
  final Duration? duration;
  final bool autoPlay;
  final bool enableWebMouseHover;
  final Function(SpAnimationController controller)? onController;

  const ShakeWidget({
    Key? key,
    required this.child,
    required this.shakeConstant,
    this.duration,
    this.autoPlay = false,
    this.enableWebMouseHover = true,
    this.onController,
  }) : super(key: key);

  @override
  ShakeWidgetState createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
  late SpAnimationController _controller;
  late Animation<Offset> _translateAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotateAnimation;

  int _tempEnterSecond = 0;

  @override
  void initState() {
    super.initState();
    _controller = SpAnimationController(vsync: this, duration: widget.duration ?? widget.shakeConstant.duration);

    // translate
    if (widget.shakeConstant.translate.isEmpty) {
      _translateAnimation = ConstantTween(Offset.zero).animate(_controller);
    } else if (widget.shakeConstant.translate.length == 1) {
      _translateAnimation = ConstantTween(widget.shakeConstant.translate.first).animate(_controller);
    } else {
      _translateAnimation = TweenSequence(
        List.generate(widget.shakeConstant.translate.length - 1, (index) {
          final beginOffset = widget.shakeConstant.translate[index];
          final endOffset = widget.shakeConstant.translate[index + 1];
          double weight = 0;
          if (widget.shakeConstant.interval.length == 1) {
            weight = widget.shakeConstant.interval.first * 1.0;
          } else if (widget.shakeConstant.interval.length > 1 &&
              widget.shakeConstant.interval.length == widget.shakeConstant.translate.length) {
            final beginWeight = widget.shakeConstant.interval[index];
            final endWeight = widget.shakeConstant.interval[index + 1];
            weight = (endWeight - beginWeight) * 1.0;
          } else {
            weight = 100 / math.max((widget.shakeConstant.translate.length - 1), 1);
          }
          return TweenSequenceItem(tween: Tween(begin: beginOffset, end: endOffset), weight: weight);
        }),
      ).animate(_controller);
    }
    // opacity
    if (widget.shakeConstant.opacity.isEmpty) {
      _opacityAnimation = ConstantTween(1.0).animate(_controller);
    } else if (widget.shakeConstant.opacity.length == 1) {
      _opacityAnimation = ConstantTween(widget.shakeConstant.opacity.first).animate(_controller);
    } else {
      _opacityAnimation = TweenSequence(
        List.generate(widget.shakeConstant.opacity.length - 1, (index) {
          final beginOpacity = widget.shakeConstant.opacity[index];
          final endOpacity = widget.shakeConstant.opacity[index + 1];

          double weight = 0;
          if (widget.shakeConstant.interval.length == 1) {
            weight = widget.shakeConstant.interval.first * 1.0;
          } else if (widget.shakeConstant.interval.length > 1 &&
              widget.shakeConstant.interval.length == widget.shakeConstant.opacity.length) {
            final beginWeight = widget.shakeConstant.interval[index];
            final endWeight = widget.shakeConstant.interval[index + 1];
            weight = (endWeight - beginWeight) * 1.0;
          } else {
            weight = 100 / math.max((widget.shakeConstant.translate.length - 1), 1);
          }
          return TweenSequenceItem(tween: Tween(begin: beginOpacity, end: endOpacity), weight: weight);
        }),
      ).animate(_controller);
    }

    // rotate
    if (widget.shakeConstant.rotate.isEmpty) {
      _rotateAnimation = ConstantTween(0.0).animate(_controller);
    } else if (widget.shakeConstant.rotate.length == 1) {
      _rotateAnimation = ConstantTween(widget.shakeConstant.rotate.first * 1.0).animate(_controller);
    } else {
      _rotateAnimation = TweenSequence(
        List.generate(widget.shakeConstant.rotate.length - 1, (index) {
          final beginRotate = widget.shakeConstant.rotate[index];
          final endRotate = widget.shakeConstant.rotate[index + 1];
          double weight = 0;
          if (widget.shakeConstant.interval.length == 1) {
            weight = widget.shakeConstant.interval.first * 1.0;
          } else if (widget.shakeConstant.interval.length > 1 &&
              widget.shakeConstant.interval.length == widget.shakeConstant.rotate.length) {
            final beginWeight = widget.shakeConstant.interval[index];
            final endWeight = widget.shakeConstant.interval[index + 1];
            weight = (endWeight - beginWeight) * 1.0;
          } else {
            weight = 100 / math.max((widget.shakeConstant.translate.length - 1), 1);
          }
          return TweenSequenceItem(
              tween: Tween(begin: math.pi / 180 * beginRotate, end: math.pi / 180 * endRotate), weight: weight);
        }),
      ).animate(_controller);
    }

    if (widget.autoPlay) _controller.repeat(reverse: true);
    widget.onController?.call(_controller);
  }

  @override
  void didUpdateWidget(covariant ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.autoPlay != widget.autoPlay) {
      if (widget.autoPlay) {
        _controller.repeat();
      } else {
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(_translateAnimation.value.dx, _translateAnimation.value.dy)
            ..rotateZ(_rotateAnimation.value),
          child: Opacity(opacity: _opacityAnimation.value, child: child),
        );
      },
      child: widget.autoPlay || widget.enableWebMouseHover == false
          ? widget.child
          : MouseRegion(
              onEnter: (PointerEnterEvent event) {
                if (event.timeStamp.inMicroseconds != _tempEnterSecond) {
                  _controller.repeat(reverse: true);
                  _tempEnterSecond = event.timeStamp.inMicroseconds;
                }
              },
              onExit: (PointerExitEvent event) {
                if (event.timeStamp.inMicroseconds != _tempEnterSecond) {
                  _controller.reset();
                }
              },
              child: widget.child,
            ),
    );
  }
}

abstract class ShakeConstant {
  /// range: 0 - 100, when only have one element,represents the same interval
  final List<int> interval;

  /// Offset(double dx, double dy)
  final List<Offset> translate;

  /// eg: 45deg = pi / 4, []:0 = [45]: rotate 45deg
  final List<double> rotate;

  /// range: 0 - 1.0, []:1.0 = [1.0]
  final List<double> opacity;

  final Duration duration;

  ShakeConstant({
    required this.interval,
    required this.translate,
    required this.rotate,
    required this.opacity,
    this.duration = const Duration(milliseconds: 100),
  })  : assert(interval.isEmpty || interval.length == 1 || interval.length > 1),
        assert(rotate.isEmpty || rotate.length == 1 || rotate.length > 1),
        assert(opacity.isEmpty || opacity.length == 1 || opacity.length > 1),
        assert(translate.isEmpty || translate.length == 1 || translate.length > 1);
}
