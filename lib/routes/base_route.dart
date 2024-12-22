import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_nested_navigation.dart';

abstract class BaseRoute {
  bool get nestedRoute => false;

  Widget buildPage(BuildContext context);

  Future<T?> push<T extends Object?>(BuildContext context) {
    if (nestedRoute) {
      return SpNestedNavigation.maybeOf(context)!.push(buildPage(context));
    } else {
      return Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return buildPage(context);
      }));
    }
  }
}
