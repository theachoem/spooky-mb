import 'package:spooky/core/models/bottom_nav_item_list_model.dart';
import 'package:spooky/core/models/bottom_nav_item_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/storages/base_object_storages/object_storage.dart';

class BottomNavItemStorage extends ObjectStorage<BottomNavItemListModel> {
  @override
  int? get version => 1;

  final List<SpRouter> defaultTabs = [
    SpRouter.home,
    SpRouter.cloudStorages,
    SpRouter.soundList,
    SpRouter.setting,
  ];

  @override
  BottomNavItemListModel decode(Map<String, dynamic> json) {
    return BottomNavItemListModel.fromJson(json);
  }

  @override
  Map<String, dynamic> encode(BottomNavItemListModel object) {
    return object.toJson();
  }

  Future<BottomNavItemListModel> getItems() async {
    BottomNavItemListModel? listModel = await super.readObject();
    List<BottomNavItemModel> validatedItems = [];

    for (final item in listModel?.items ?? <BottomNavItemModel>[]) {
      if (item.router?.datas.tab != null) {
        validatedItems.add(item);
      }
    }

    List<SpRouter?> validatedRouters = validatedItems.map((e) {
      return e.router;
    }).toList();

    // make sure other index available
    for (SpRouter route in SpRouter.values) {
      if (route.datas.tab != null && !validatedRouters.contains(route)) {
        validatedItems.add(
          BottomNavItemModel(
            router: route,
            selected: route.datas.tab?.optinal == false || defaultTabs.contains(route),
          ),
        );
      }
    }

    return BottomNavItemListModel(validatedItems);
  }
}
