import 'dart:async';

import 'package:flutter/material.dart';

class SpCountDown extends StatefulWidget {
  const SpCountDown({
    super.key,
    required this.endTime,
    required this.endWidget,
    required this.builder,
  });

  final DateTime endTime;
  final Widget endWidget;
  final Widget Function(bool ended, Widget endWidget) builder;

  @override
  State<SpCountDown> createState() => _SpCountDownState();
}

class _SpCountDownState extends State<SpCountDown> {
  late final Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      DateTime abitBeforeEndTime = widget.endTime.add(const Duration(milliseconds: 500));
      if (DateTime.now().isBefore(abitBeforeEndTime)) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      DateTime.now().isAfter(widget.endTime),
      widget.endWidget,
    );
  }
}
