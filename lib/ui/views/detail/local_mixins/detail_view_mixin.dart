import 'package:flutter/material.dart';

mixin DetailViewMixn<T extends StatefulWidget> on State<T> {
  // readOnly is open, keyboard might open too which make UI lage.
  // we use readOnlyAfterAnimatedNotifer to animate those widget only when keyboard is open.
  late ValueNotifier<bool> readOnlyAfterAnimatedNotifer;

  @override
  void initState() {
    readOnlyAfterAnimatedNotifer = ValueNotifier(false);
    super.initState();
  }

  @override
  void dispose() {
    readOnlyAfterAnimatedNotifer.dispose();
    super.dispose();
  }
}
