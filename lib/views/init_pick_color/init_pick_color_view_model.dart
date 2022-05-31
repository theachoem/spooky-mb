import 'package:spooky/core/base/base_view_model.dart';

class InitPickColorViewModel extends BaseViewModel {
  final bool showNextButton;
  InitPickColorViewModel(this.showNextButton);

  String? selectedOption;
  void setSelectedOption(String? value) {
    selectedOption = value;
    notifyListeners();
  }
}
