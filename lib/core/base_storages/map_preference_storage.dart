import 'dart:convert';
import 'package:spooky/core/base_storages/base_storage.dart';
import 'package:spooky/core/base_storages/storage_adapters/base_storage_adapter.dart';
import 'package:spooky/core/base_storages/storage_adapters/default_stroage_adapter.dart';

abstract class MapPreferenceStorage<T, U> extends BaseStorage<String> {
  @override
  Future<BaseStorageAdapter<String>> get adapter async => DefaultStorageAdapter<String>();

  Future<void> writeMap(Map<T, U> value) async {
    return (await adapter).write(key: key, value: jsonEncode(value));
  }

  Future<Map<T, U>?> readMap() async {
    String? value = await (await adapter).read(key: key);
    if (value == null) return null;
    try {
      Map<T, U> result = jsonDecode(value);
      return result;
    } catch (e) {
      return null;
    }
  }
}
