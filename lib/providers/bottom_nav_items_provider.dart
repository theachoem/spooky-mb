import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/storages/local_storages/bottom_nav_items_storage.dart';

class BottomNavItemsProvider extends ChangeNotifier {
  final BottomNavItemStorage storage = BottomNavItemStorage();
  BottomNavItemsProvider() {
    load();
  }

  List<SpRouter>? tabs;
  Future<void> load() async {
    tabs = await storage.getItems();
    notifyListeners();
  }
}
