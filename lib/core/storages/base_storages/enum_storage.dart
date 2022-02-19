import 'package:spooky/core/storages/base_storages/share_preference_storage.dart';
import 'package:spooky/core/storages/storage_adapters/base_storage_adapter.dart';
import 'package:spooky/core/storages/storage_adapters/default_stroage_adapter.dart';

abstract class EnumStorage<T> extends SharePreferenceStorage<String> {
  List<T> get values;

  @override
  Future<BaseStorageAdapter<String>> get adapter async => DefaultStorageAdapter<String>();

  Future<void> writeEnum(T value) async {
    (await adapter).write(key: key, value: "$value");
  }

  Future<T?> readEnum() async {
    String? result = await (await adapter).read(key: key);
    for (T e in values) {
      if ("$e" == result) return e;
    }
    return null;
  }
}
