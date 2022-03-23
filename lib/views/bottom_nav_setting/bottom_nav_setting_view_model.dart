import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/views/main/main_view_item.dart';

class BottomNavSettingViewModel extends BaseViewModel {
  late List<MainTabBarItem> tabs;
  BottomNavSettingViewModel() {
    tabs = MainTabBar().availableTabs.values.toList();
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    if (!tabs[oldIndex].optinal || !tabs[newIndex].optinal) return;

    final MainTabBarItem item = tabs.removeAt(oldIndex);
    tabs.insert(newIndex, item);
    notifyListeners();
  }
}
