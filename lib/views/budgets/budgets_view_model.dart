import 'package:flutter/material.dart';
import 'package:spooky/core/base/base_view_model.dart';

class BudgetsViewModel extends BaseViewModel {
  late final ValueNotifier<double> offsetNotifier;
  BudgetsViewModel() {
    offsetNotifier = ValueNotifier(0.0);
  }

  @override
  void dispose() {
    offsetNotifier.dispose();
    super.dispose();
  }
}
