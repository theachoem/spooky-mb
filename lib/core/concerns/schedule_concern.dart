import 'dart:async';
import 'package:flutter/material.dart';

mixin ScheduleConcern {
  final Map<String, Timer?> _timers = {};
  Timer? _singleTimer;

  Timer? _timer(String? key) {
    if (_timers.containsKey(key)) return _timers[key];
    return _singleTimer;
  }

  void scheduleAction(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 300),
    String? key,
  }) {
    cancelTimer(key);
    _singleTimer = Timer(duration, () async {
      callback();
    });
    if (key != null) {
      _timers[key] = _singleTimer;
    }
  }

  void cancelTimer(String? key) {
    if (_timer(key) != null && _timer(key)!.isActive) {
      _timer(key)?.cancel();
    }
  }
}
