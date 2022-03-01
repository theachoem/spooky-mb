import 'package:flutter/material.dart';
import 'package:spooky/core/storages/local_storages/developer_mode_storage.dart';

class DeveloperModeProvider extends ChangeNotifier {
  bool developerModeOn = false;
  final DeveloperModeStorage storage = DeveloperModeStorage();

  DeveloperModeProvider() {
    load();
  }

  Future<void> load() async {
    storage.read().then((value) {
      developerModeOn = value == true;
      notifyListeners();
    });
  }

  Future<void> set(bool value) async {
    developerModeOn = value;
    await storage.write(value);
    notifyListeners();
  }
}
