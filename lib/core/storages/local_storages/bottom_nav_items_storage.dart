import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/storages/base_storages/share_preference_storage.dart';

class BottomNavItemStorage extends SharePreferenceStorage<List<String>> {
  List<SpRouter> defaultTabs = [SpRouter.home, SpRouter.setting];

  Future<List<SpRouter>?> getItems() async {
    Set<SpRouter> routes = {};
    List<String>? items = await super.read();
    for (String item in items ?? []) {
      Iterable<SpRouter> result = SpRouter.values.where((e) => e.name == item);
      if (result.isNotEmpty) {
        routes.add(result.first);
      }
    }
    if (routes.length < 2) {
      return defaultTabs;
    } else {
      return routes.toList();
    }
  }

  Future<void> writeItems(List<SpRouter> items) async {
    List<String> itemsStr = items.map((e) => e.name).toList();
    return write(itemsStr);
  }
}
