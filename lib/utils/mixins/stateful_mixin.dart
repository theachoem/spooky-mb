import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';

mixin StatefulMixin<T extends StatefulWidget> on State<T> {
  ColorScheme get colorScheme => Theme.of(context).colorScheme;
  TextTheme get textTheme => Theme.of(context).textTheme;
  ThemeData get themeData => Theme.of(context);
  AppBarTheme get appBarTheme => Theme.of(context).appBarTheme;

  M3Color? get m3Color => M3Color.of(context);
  M3TextTheme get m3TextTheme => M3TextTheme.of(context);

  Size get screenSize => MediaQuery.of(context).size;
  EdgeInsets get viewInsets => MediaQuery.of(context).viewInsets;
  EdgeInsets get viewPadding => MediaQuery.of(context).viewPadding;
  EdgeInsets get mediaQueryPadding => MediaQuery.of(context).padding;
  MediaQueryData get mediaQueryData => MediaQuery.of(context);

  double get statusBarHeight => mediaQueryPadding.top;
  double get bottomHeight => mediaQueryPadding.bottom;
  double get keyboardHeight => mediaQueryData.viewInsets.bottom;
}
