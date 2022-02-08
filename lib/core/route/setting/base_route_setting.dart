import 'package:flutter/material.dart';

abstract class BaseRouteSetting {
  final Widget Function(dynamic) route;
  final String title;

  BaseRouteSetting({
    required this.route,
    required this.title,
  });
}
