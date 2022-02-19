import 'package:spooky/core/base_storages/storage_adapters/base_storage_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultStorageAdapter<T> extends BaseStorageAdapter<T> {
  Future<SharedPreferences> get instance => SharedPreferences.getInstance();

  @override
  Future<T?> read({required String key}) async {
    SharedPreferences _instance = await instance;
    if (T is bool) {
      return _instance.getBool(key) as T;
    } else if (T is double) {
      return _instance.getDouble(key) as T;
    } else if (T is int) {
      return _instance.getInt(key) as T;
    } else if (T is String) {
      return _instance.getString(key) as T;
    } else if (T is List<String>) {
      return _instance.getStringList(key) as T;
    } else {
      _instance.get(key);
    }
    return null;
  }

  @override
  Future<void> write({required String key, required T value}) async {
    SharedPreferences _instance = await instance;
    if (T is bool) {
      _instance.setBool(key, value as bool);
    } else if (T is double) {
      _instance.setDouble(key, value as double);
    } else if (T is int) {
      _instance.setInt(key, value as int);
    } else if (T is String) {
      _instance.setString(key, value as String);
    } else if (T is List<String>) {
      _instance.setStringList(key, value as List<String>);
    }
  }

  @override
  Future<void> remove({required String key}) async {
    SharedPreferences _instance = await instance;
    _instance.remove(key);
  }
}
