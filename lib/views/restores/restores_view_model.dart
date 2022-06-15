import 'package:flutter/material.dart';
import 'package:spooky/core/base/base_view_model.dart';

class RestoresViewModel extends BaseViewModel {
  late final ValueNotifier<bool> showSkipNotifier;
  final bool showSkipButton;

  RestoresViewModel(this.showSkipButton) {
    showSkipNotifier = ValueNotifier<bool>(true);
    load();
  }

  Future<void> load() async {}
}
