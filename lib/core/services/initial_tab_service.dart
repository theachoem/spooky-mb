import 'package:spooky/core/storages/local_storages/initial_story_tab_storage.dart';

class InitialStoryTabService {
  static final InitialStoryTabStorage _storage = InitialStoryTabStorage();

  static DateTime get initial => _initial;
  static DateTime _initial = DateTime.now();

  static Future<void> initialize() async {
    _initial = await _storage.getInitialTab();
  }

  static Future<void> setInitialTab(int year, int month) async {
    return _storage.setInitialTab(year, month);
  }
}
