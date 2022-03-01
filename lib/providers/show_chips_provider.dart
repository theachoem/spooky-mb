import 'package:flutter/material.dart';
import 'package:spooky/core/storages/local_storages/show_chips_storage.dart';

class ShowChipsProvider extends ChangeNotifier {
  bool shouldShow = true;

  ShowChipsProvider() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      load();
    });
  }

  Future<void> load() async {
    bool? value = await ShowChipsStorage().read();
    shouldShow = value == true;
    notifyListeners();
  }

  Future<void> set(bool value) async {
    await ShowChipsStorage().write(value);
    return load();
  }
}
