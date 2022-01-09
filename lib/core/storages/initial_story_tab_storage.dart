import 'package:spooky/core/base_storages/map_preference_storage.dart';

class InitialStoryTabStorage extends MapPreferenceStorage {
  Future<void> setInitialTab(int? year, int? month) async {
    return writeMap({'year': year, 'month': month});
  }

  Future<DateTime> getInitialTab() async {
    Map<dynamic, dynamic>? result = await super.readMap();
    int? year = _getValueByKey(result, 'year');
    int? month = _getValueByKey(result, 'month');

    if (result != null) {
      // initial tab will only read once, then remove
      remove();
    }

    DateTime now = DateTime.now();
    if (year != null || month != null) {
      return DateTime(year ?? now.year, month ?? now.month);
    } else {
      return now;
    }
  }

  int? _getValueByKey(Map<dynamic, dynamic>? map, String key) {
    if (map?.containsKey(key) == true) {
      dynamic value = map?[key];
      if (value is int) return value;
    }
  }
}
