import 'package:flutter/material.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:stacked/stacked.dart';

class MainViewModel extends BaseViewModel with ScheduleMixin {
  late final ValueNotifier<bool> shouldShowBottomNavNotifier;
  late final ValueNotifier<double?> bottomNavigationHeight;

  MainViewModel() {
    shouldShowBottomNavNotifier = ValueNotifier(true);
    bottomNavigationHeight = ValueNotifier(null);
    DateTime date = DateTime.now();
    year = date.year;
    month = date.month;
    day = date.day;
  }

  @override
  void dispose() {
    shouldShowBottomNavNotifier.dispose();
    bottomNavigationHeight.dispose();
    super.dispose();
  }

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

  void onTabChange(int month) {
    this.month = month;
  }

  void setShowBottomNav(bool value) {
    scheduleAction(() {
      shouldShowBottomNavNotifier.value = value;
    });
  }
}
