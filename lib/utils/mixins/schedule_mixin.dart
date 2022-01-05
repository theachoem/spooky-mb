// ignore_for_file: unnecessary_this

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
    if (this._timer != null && this._timer!.isActive) {
      this._timer?.cancel();
    }
  }
}
