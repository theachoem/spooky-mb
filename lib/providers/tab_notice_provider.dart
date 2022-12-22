import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/routes/sp_router.dart';

enum TabNoticeSetterSourceType {
  updater,
  backupAlerter,
}

// show red color on bottom navigation item
class TabNoticeProvider extends BaseViewModel {
  static final instance = TabNoticeProvider._();
  TabNoticeProvider._();

  Map<TabNoticeSetterSourceType, SpRouter> _noticedTabs = {};
  Map<TabNoticeSetterSourceType, SpRouter> get noticedTabs => _noticedTabs;

  void setNoticeTab(SpRouter route, TabNoticeSetterSourceType source) {
    if (route.datas.tab != null) {
      final noticedTabs = {..._noticedTabs};
      noticedTabs[source] = route;
      notifyIfUpdated(noticedTabs);
    }
  }

  void removeNoticeTab(SpRouter route, TabNoticeSetterSourceType source) {
    if (route.datas.tab != null) {
      final noticedTabs = {..._noticedTabs};
      noticedTabs.remove(source);
      notifyIfUpdated(noticedTabs);
    }
  }

  void notifyIfUpdated(Map<TabNoticeSetterSourceType, SpRouter> noticedTabs) {
    if (noticedTabs != _noticedTabs) {
      _noticedTabs = noticedTabs;
      notifyListeners();
    }
  }

  void set(
    SpRouter route,
    TabNoticeSetterSourceType source, {
    required bool add,
  }) {
    if (add) {
      setNoticeTab(route, source);
    } else {
      removeNoticeTab(route, source);
    }
  }
}
