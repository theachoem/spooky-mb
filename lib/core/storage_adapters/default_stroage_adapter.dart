import 'dart:convert';

import 'package:spooky/core/storage_adapters/base_storage_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultStorageAdapter<T> extends BaseStorageAdapter<T> {
  Future<SharedPreferences> get _instance => SharedPreferences.getInstance();

  @override
  Future<T?> read({required String key}) async {
    SharedPreferences instance = await _instance;

    dynamic result;
    if (T is bool) {
      result = instance.getBool(key);
    } else if (T is double) {
      result = instance.getDouble(key);
    } else if (T is int) {
      result = instance.getInt(key);
    } else if (T is String) {
      result = instance.getString(key);
    } else if (T is List<String>) {
      result = instance.getStringList(key);
    } else if (T is Map) {
      String? map = instance.getString(key);
      result = jsonDecode(map ?? "");
    } else {
      result = instance.get(key);
    }

    if (result is T) return result;
    return null;
  }

  @override
  Future<void> write({
    required String key,
    required T value,
  }) async {
    SharedPreferences instance = await _instance;
    if (value is bool) {
      instance.setBool(key, value);
    } else if (value is double) {
      instance.setDouble(key, value);
    } else if (value is int) {
      instance.setInt(key, value);
    } else if (value is String) {
      instance.setString(key, value);
    } else if (value is List<String>) {
      instance.setStringList(key, value);
    } else if (value is Map) {
      instance.setString(key, jsonEncode(value));
    }
  }

  @override
  Future<void> remove({required String key}) async {
    SharedPreferences instance = await _instance;
    instance.remove(key);
  }
}
