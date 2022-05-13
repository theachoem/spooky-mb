import 'package:flutter/material.dart';
import 'package:spooky/core/storages/local_storages/priority_starred_storage.dart';

class PriorityStarredProvider extends ChangeNotifier {
  bool prioritied = true;

  PriorityStarredProvider() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      load();
    });
  }

  Future<void> load() async {
    bool? value = await PriorityStarredStorage().read();
    if (value != null) {
      prioritied = value;
      notifyListeners();
    }
  }

  Future<void> set(bool value) async {
    await PriorityStarredStorage().write(value);
    return load();
  }
}
