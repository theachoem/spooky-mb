import 'package:flutter/material.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:stacked/stacked.dart';

class MainViewModel extends BaseViewModel with ScheduleMixin {
  late final ValueNotifier<bool> shouldShowBottomNavNotifier;
  late final ValueNotifier<bool> shouldScrollToTopNotifier;
  late final ValueNotifier<double?> bottomNavigationHeight;

  Map<int, ScrollController> scrollControllers = {};
  ScrollController? get currentScrollController {
    if (scrollControllers.containsKey(activeIndex)) {
      return scrollControllers[activeIndex];
    }
    return null;
  }

  void setScrollController({
    required int index,
    required ScrollController controller,
  }) {
    scrollControllers[index] = controller;
  }

  // bnv - bottom navigatoin
  bool fixedHideBnv = false;

  MainViewModel() {
    shouldShowBottomNavNotifier = ValueNotifier(true);
    shouldScrollToTopNotifier = ValueNotifier(false);
    bottomNavigationHeight = ValueNotifier(null);
    DateTime date = DateTime.now();
    year = date.year;
    month = date.month;
    day = date.day;
  }

  @override
  void dispose() {
    shouldShowBottomNavNotifier.dispose();
    shouldScrollToTopNotifier.dispose();
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

  void setShouldScrollToTop(bool value) {
    shouldScrollToTopNotifier.value = value;
  }

  void setShouldHideBottomNav(bool value, [bool fixed = false]) {
    if (fixed) {
      shouldShowBottomNavNotifier.value = value;
      fixedHideBnv = fixed;
    } else if (shouldShowBottomNavNotifier.value || !fixedHideBnv) {
      scheduleAction(() {
        shouldShowBottomNavNotifier.value = value;
        fixedHideBnv = fixed;
      });
    }
  }
}
