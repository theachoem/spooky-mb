import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spooky/core/models/theme_model.dart';
import 'package:spooky/core/storages/local_storages/bottom_nav_items_storage.dart';
import 'package:spooky/core/storages/local_storages/priority_starred_storage.dart';
import 'package:spooky/core/storages/local_storages/sort_type_storage.dart';
import 'package:spooky/core/storages/local_storages/sp_list_layout_type_storage.dart';
import 'package:spooky/core/storages/local_storages/theme_storage.dart';
import 'package:spooky/core/types/sort_type.dart';
import 'package:spooky/widgets/sp_story_list/sp_story_list.dart';

class AnalyticInitializer {
  static Future<void> initialize() async {
    bool supported = await FirebaseAnalytics.instance.isSupported();
    if (supported) {
      await setDefaultAnalytics();
      await setUserId();
      await setTheme();
    }
  }

  static Future<void> setUserId() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) await FirebaseAnalytics.instance.setUserId(id: uid);
  }

  static Future<void> setDefaultAnalytics() async {
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    if (!FirebaseAnalytics.instance.app.isAutomaticDataCollectionEnabled) {
      await FirebaseAnalytics.instance.app.setAutomaticDataCollectionEnabled(true);
    }
  }

  static Future<void> setTheme() async {
    ThemeModel? object = await ThemeStorage().readObject();
    SpListLayoutType? layoutType = await SpListLayoutTypeStorage().readEnum();
    SortType? sortType = await SortTypeStorage().readEnum();
    bool? priorityStarred = await PriorityStarredStorage().read();
    List<String?>? tabs = await BottomNavItemStorage().readObject().then(
        (value) => value?.items?.where((element) => element.selected == true).map((e) => e.router?.name).toList());

    FirebaseAnalytics.instance.setUserProperty(name: 'font_family', value: object?.fontFamily);
    FirebaseAnalytics.instance.setUserProperty(name: 'font_weight', value: object?.fontWeight.index.toString());
    FirebaseAnalytics.instance.setUserProperty(name: 'color_seed', value: object?.colorSeedValue?.toString());
    FirebaseAnalytics.instance.setUserProperty(name: 'theme_mode', value: object?.themeMode?.name);
    FirebaseAnalytics.instance.setUserProperty(name: 'layout_type', value: layoutType?.name);
    FirebaseAnalytics.instance.setUserProperty(name: 'sort_type', value: sortType?.name);
    FirebaseAnalytics.instance.setUserProperty(name: 'priority_starred', value: priorityStarred?.toString());
    FirebaseAnalytics.instance.setUserProperty(name: 'tabs', value: tabs?.join("|"));
  }
}
