import 'dart:async';
import 'package:flutter/material.dart';

mixin ScheduleMixin {
  Timer? _timer;
  scheduleAction(VoidCallback callback, {Duration duration = const Duration(milliseconds: 300)}) {
    cancelTimer();
    _timer = Timer(duration, () async {
      callback();
    });
  }

  cancelTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
  }
}
