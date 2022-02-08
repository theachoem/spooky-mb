import 'package:stacked/stacked.dart';

class MainViewModel extends BaseViewModel {
  int activeIndex = 0;
  void setActiveIndex(int index) {
    activeIndex = index;
    notifyListeners();
  }

  void Function()? storyListReloader;

  late int year;
  late int month;
  late int day;

  DateTime get date {
    final now = DateTime.now();
    return DateTime(
      year,
      month,
      day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
      now.microsecond,
    );
  }

  MainViewModel() {
    DateTime date = DateTime.now();
    year = date.year;
    month = date.month;
    day = date.day;
  }

  void onTabChange(int month) {
    this.month = month;
  }
}
