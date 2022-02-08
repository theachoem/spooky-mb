import 'package:flutter/material.dart';

abstract class BaseRouteSetting {
  final Widget Function(dynamic) route;
  final String title;
  final bool fullscreenDialog;

  BaseRouteSetting({
    required this.route,
    required this.title,
    required this.fullscreenDialog,
  });
}
