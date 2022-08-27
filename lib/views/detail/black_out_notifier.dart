import 'package:spooky/core/base/base_view_model.dart';

class BlackOutNotifier extends BaseViewModel {
  bool blackout = false;

  void toggle() {
    blackout = !blackout;
    notifyListeners();
  }
}
