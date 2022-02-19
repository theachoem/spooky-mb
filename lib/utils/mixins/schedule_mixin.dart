import 'dart:async';
import 'package:flutter/material.dart';

mixin ScheduleMixin {
  final Map<Key, Timer?> _timers = {};
  Timer? _singleTimer;

  Timer? _timer(Key? key) {
    if (_timers.containsKey(key)) return _timers[key];
    return _singleTimer;
  }

  void scheduleAction(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 300),
    Key? key,
  }) {
    cancelTimer(key);
    _singleTimer = Timer(duration, () async {
      callback();
    });
    if (key != null) {
      _timers[key] = _singleTimer;
    }
  }

  void cancelTimer(Key? key) {
    if (_timer(key) != null && _timer(key)!.isActive) {
      _timer(key)?.cancel();
    }
  }
}
