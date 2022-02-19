import 'package:spooky/core/base_storages/base_storage.dart';
import 'package:spooky/core/base_storages/storage_adapters/base_storage_adapter.dart';
import 'package:spooky/core/base_storages/storage_adapters/default_stroage_adapter.dart';

abstract class BoolPreferenceStorage extends BaseStorage<bool> {
  @override
  Future<BaseStorageAdapter<bool>> get adapter async => DefaultStorageAdapter<bool>();

  Future<void> toggle() async {
    final bool current = await read() == true;
    (await adapter).write(key: key, value: !current);
  }
}
