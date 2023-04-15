import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/security/security_service.dart';
import 'package:spooky/core/storages/local_storages/story_config_storage.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/providers/bottom_nav_items_provider.dart';
import 'package:spooky/providers/story_config_provider.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/widgets/sp_story_list/sp_story_list.dart';

class MainViewModel extends BaseViewModel with ScheduleMixin {
  late final ValueNotifier<bool> shouldShowBottomNavNotifier;
  late final ValueNotifier<double?> bottomNavigationHeight;

  final BuildContext context;
  final SecurityService service = SecurityService();

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

  Future<void> createStory(BuildContext context, {bool useTodayDate = false}) async {
    final StoryConfigStorage storage = context.read<StoryConfigProvider>().storage;

    final bool disableDatePicker = storage.disableDatePicker;
    final SpListLayoutType layout = storage.layoutType;

    DateTime? date;

    if (useTodayDate) {
      date = DateTime.now();
    } else if (disableDatePicker) {
      date = DateTime.now();
      switch (layout) {
        case SpListLayoutType.timeline:
        case SpListLayoutType.library:
          date = DateTime(year, date.month, date.day, date.hour, date.minute, date.second);
          break;
        case SpListLayoutType.diary:
          date = this.date;
          break;
      }
    } else {
      switch (layout) {
        case SpListLayoutType.timeline:
        case SpListLayoutType.library:
          date = await SpDatePicker.showMonthDayPicker(context, this.date);
          break;
        case SpListLayoutType.diary:
          date = await SpDatePicker.showDayPicker(context, this.date);
          break;
      }
    }
    if (date != null) onConfirm(date, context);
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
