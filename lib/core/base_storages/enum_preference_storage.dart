import 'package:shared_preferences/shared_preferences.dart';
import 'package:spooky/core/base_storages/base_storage.dart';
import 'package:spooky/core/base_storages/storage_adapters/base_storage_adapter.dart';
import 'package:spooky/core/base_storages/storage_adapters/default_stroage_adapter.dart';

abstract class EnumPreferenceStorage<T> extends BaseStorage<T> {
  @override
  Future<BaseStorageAdapter<T>> get adapter async => DefaultStorageAdapter<T>();

  List<T> get values;

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
}
