import 'dart:async';

import 'package:spooky/core/storages/base_storages/bool_storage.dart';

class ShowChipsStorage extends BoolStorage {
  static StreamController<bool?> controller = StreamController.broadcast();
  static Future<void> reset() async {
    bool? value = await ShowChipsStorage().read();
    controller.add(value);
  }

  static Future<void> set(bool value) async {
    ShowChipsStorage().write(value);
    return reset();
  }
}
