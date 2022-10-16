import 'dart:async';

import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class InitPickColorViewModel extends BaseViewModel {
  final bool showNextButton;
  late final Completer<int> completer;

  InitPickColorViewModel(this.showNextButton) {
    completer = Completer();
    Future.delayed(ConfigConstant.fadeDuration).then((value) {
      completer.complete(1);
    });
  }

  String? selectedOption;
  void setSelectedOption(String? value) {
    selectedOption = value;
    notifyListeners();
  }
}
