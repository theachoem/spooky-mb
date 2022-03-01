import 'package:flutter/material.dart';
import 'package:spooky/core/storages/local_storages/nickname_storage.dart';
import 'package:spooky/main.dart';

class NicknameProvider extends ChangeNotifier {
  String? name;
  NicknameProvider() {
    load();
  }

  Future<void> load() async {
    NicknameStorage().read().then((value) {
      if (value is String) {
        name = value;
        notifyListeners();
      }
    });
  }

  void setNickname(String value) {
    if (value != name && value.trim().isNotEmpty) {
      name = value;
      NicknameStorage().write(value);
      notifyListeners();
    }
  }

  void clearNickname() {
    NicknameStorage().remove();
    name = "";
    notifyListeners();
  }

  @override
  void notifyListeners() {
    spAppIntiailized = name?.trim().isNotEmpty == true;
    super.notifyListeners();
  }
}
