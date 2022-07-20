import 'package:flutter/material.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/security/security_service.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/providers/bottom_nav_items_provider.dart';
import 'package:spooky/widgets/sp_list_layout_builder.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/widgets/sp_story_list/sp_story_list.dart';

class MainViewModel extends BaseViewModel with ScheduleMixin {
  late final ValueNotifier<bool> shouldShowBottomNavNotifier;
  late final ValueNotifier<double?> bottomNavigationHeight;

  final BuildContext context;
  final SecurityService service = SecurityService();

  Map<SpRouter, ScrollController> scrollControllers = {};
  ScrollController? get currentScrollController {
    if (scrollControllers.containsKey(activeRouter)) {
      return scrollControllers[activeRouter];
    }
    return null;
  }

  void setScrollController({
    required int index,
    required ScrollController controller,
  }) {
    scrollControllers[activeRouter] = controller;
  }

  MainViewModel(this.context) {
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

  SpRouter activeRouter = SpRouter.home;
  void setActiveRouter(SpRouter router) {
    if (activeRouter != router) {
      activeRouter = router;
      notifyListeners();
    }
  }

  late int year;
  late int month;
  late int day;

  void setYear(int year) {
    this.year = year;
  }

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

  String? tagId;
  bool initialStarred = false;
  void onTagChange(String? tag) {
    if (tag == "*") {
      tagId = null;
      initialStarred = true;
    } else if (tag == null) {
      tagId = null;
      initialStarred = false;
    } else {
      tagId = tag;
      initialStarred = false;
    }
  }

  void onMonthChange(int month) {
    this.month = month;
  }

  void setShouldShowBottomNav(bool value) {
    shouldShowBottomNavNotifier.value = value;
  }

  Future<void> createStory(BuildContext context) async {
    await SpListLayoutBuilder.get().then((layout) async {
      Future<DateTime?> date;
      switch (layout) {
        case SpListLayoutType.timeline:
        case SpListLayoutType.library:
          date = SpDatePicker.showMonthDayPicker(context, this.date);
          break;
        case SpListLayoutType.diary:
          date = SpDatePicker.showDayPicker(context, this.date);
          break;
      }

      date.then((date) {
        if (date != null) onConfirm(date, context);
      });
    });
  }

  void onConfirm(DateTime date, BuildContext context) {
    DetailArgs args = DetailArgs(
      intialFlow: DetailViewFlowType.create,
      initialStory: StoryDbModel.fromDate(date).copyWith(
        tags: tagId != null ? [tagId!] : null,
        starred: initialStarred,
      ),
    );
    Navigator.of(context).pushNamed(SpRouter.detail.path, arguments: args);
  }

  int selectedIndex(BottomNavItemsProvider provider) {
    if (provider.tabs?.contains(activeRouter) == true) {
      return provider.tabs!.indexOf(activeRouter);
    } else {
      return 0;
    }
  }
}
