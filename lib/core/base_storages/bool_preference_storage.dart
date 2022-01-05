import 'package:shared_preferences/shared_preferences.dart';

abstract class BoolPreferenceStorage {
  String get key => runtimeType.toString();

  Future<void> toggle() async {
    SharedPreferences _instance = await SharedPreferences.getInstance();
    final bool current = await readBool() == true;
    await _instance.setBool(key, !current);
  }

  Future<void> writeBool({required bool value}) async {
    SharedPreferences _instance = await SharedPreferences.getInstance();
    await _instance.setBool(key, value);
  }

  Future<bool?> readBool() async {
    SharedPreferences _instance = await SharedPreferences.getInstance();
    return _instance.getBool(key);
  }

  Future<void> remove() async {
    SharedPreferences _instance = await SharedPreferences.getInstance();
    await _instance.remove(key);
  }
}
