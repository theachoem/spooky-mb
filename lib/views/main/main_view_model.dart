import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/core/security/security_service.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/core/types/list_layout_type.dart';
import 'package:spooky/core/types/quick_actions_type.dart';
import 'package:spooky/widgets/sp_list_layout_builder.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';

class MainViewModel extends ChangeNotifier with ScheduleMixin {
  late final ValueNotifier<bool> shouldShowBottomNavNotifier;
  late final ValueNotifier<double?> bottomNavigationHeight;

  final BuildContext context;
  final SecurityService service = SecurityService();

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

  MainViewModel(this.context) {
    shouldShowBottomNavNotifier = ValueNotifier(true);
    bottomNavigationHeight = ValueNotifier(null);
    DateTime date = DateTime.now();
    year = date.year;
    month = date.month;
    day = date.day;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      onModelReady(context);
    });
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

  void setShouldShowBottomNav(bool value) {
    shouldShowBottomNavNotifier.value = value;
  }

  Future<void> createStory(BuildContext context) async {
    ListLayoutType? layout = await SpListLayoutBuilder.get();

    DateTime? date;
    switch (layout) {
      case ListLayoutType.single:
        date = await SpDatePicker.showMonthDayPicker(context, this.date);
        break;
      case ListLayoutType.tabs:
        date = await SpDatePicker.showDayPicker(context, this.date);
        break;
    }

    if (date != null) onConfirm(date, context);
  }

  void onConfirm(DateTime date, BuildContext context) {
    DetailArgs args = DetailArgs(initialStory: StoryModel.fromDate(date), intialFlow: DetailViewFlowType.create);
    Navigator.of(context).pushNamed(SpRouteConfig.detail, arguments: args).then((value) {
      if (storyListReloader != null && value != null) storyListReloader!();
    });
  }

  void onModelReady(BuildContext context) {
    QuickActions quickActions = const QuickActions();
    quickActions.initialize((shortcutType) {
      QuickActionsType? type;
      for (QuickActionsType item in QuickActionsType.values) {
        if (shortcutType == item.name) {
          type = item;
          break;
        }
      }
      switch (type) {
        case QuickActionsType.create:
          createStory(context);
          break;
        case null:
          break;
      }
    });

    quickActions.setShortcutItems(
      QuickActionsType.values.map((e) {
        return ShortcutItem(localizedTitle: quickActionLabel(e), type: e.name);
      }).toList(),
    );
  }

  String quickActionLabel(QuickActionsType type) {
    switch (type) {
      case QuickActionsType.create:
        return "Create New Story";
    }
  }
}
