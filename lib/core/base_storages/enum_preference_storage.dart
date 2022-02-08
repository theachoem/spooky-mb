import 'package:shared_preferences/shared_preferences.dart';

abstract class EnumPreferenceStorage<T> {
  List<T> get values;

  String get key => runtimeType.toString();

  Future<void> writeEnum(T value) async {
    SharedPreferences _instance = await SharedPreferences.getInstance();
    _instance.setString(key, value.toString());
  }

  Future<T?> readEnum() async {
    SharedPreferences _instance = await SharedPreferences.getInstance();
    String? result = _instance.getString(key);
    for (T e in values) {
      if ("$e" == result) return e;
    }
    return null;
  }

  Future<void> remove() async {
    SharedPreferences _instance = await SharedPreferences.getInstance();
    await _instance.remove(key);
  }
}
