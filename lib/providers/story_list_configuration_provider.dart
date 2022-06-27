import 'package:flutter/material.dart';
import 'package:spooky/core/storages/local_storages/priority_starred_storage.dart';
import 'package:spooky/core/storages/local_storages/show_chips_storage.dart';
import 'package:spooky/core/storages/local_storages/sort_type_storage.dart';
import 'package:spooky/core/types/sort_type.dart';

class StoryListConfigurationProvider extends ChangeNotifier {
  bool shouldShowChip = true;
  bool prioritied = true;
  SortType? sortType;

  StoryListConfigurationProvider() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      load();
    });
  }

  final ShowChipsStorage showChipsStorage = ShowChipsStorage();
  final PriorityStarredStorage priorityStarredStorage = PriorityStarredStorage();
  final SortTypeStorage sortTypeStorage = SortTypeStorage();

  bool _loaded = false;
  bool get loaded => _loaded;

  Future<void> load() async {
    shouldShowChip = await showChipsStorage.read() ?? shouldShowChip;
    prioritied = await priorityStarredStorage.read() ?? prioritied;
    sortType = await sortTypeStorage.readEnum() ?? SortType.newToOld;
    _loaded = true;
    notifyListeners();
  }

  Future<void> setShouldShowChip(bool value) async {
    if (value == shouldShowChip) return;
    await showChipsStorage.write(value);
    load();
  }

  Future<void> setPriorityStarred(bool value) async {
    if (value == prioritied) return;
    await priorityStarredStorage.write(value);
    load();
  }

  Future<void> setSortType(SortType value) async {
    if (value == sortType) return;
    await sortTypeStorage.writeEnum(value);
    load();
  }
}
