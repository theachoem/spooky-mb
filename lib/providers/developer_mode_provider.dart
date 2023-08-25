import 'package:flutter/material.dart';
import 'package:spooky/core/storages/local_storages/developer_mode_storage.dart';
import 'package:spooky/utils/constants/api_constant.dart';

class DeveloperModeProvider extends ChangeNotifier {
  final DeveloperModeStorage storage = DeveloperModeStorage();

  bool _developerModeOn = false;
  bool get developerModeOn => _developerModeOn || ApiConstant.dev || ApiConstant.staging;

  DeveloperModeProvider() {
    load();
  }

  Future<void> load() async {
    storage.read().then((value) {
      _developerModeOn = value == true;
      notifyListeners();
    });
  }

  Future<void> set(bool value) async {
    _developerModeOn = value;
    await storage.write(value);
    notifyListeners();
  }
}
