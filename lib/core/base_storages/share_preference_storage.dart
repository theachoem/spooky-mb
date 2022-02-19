import 'package:spooky/core/base_storages/base_storage.dart';
import 'package:spooky/core/base_storages/storage_adapters/base_storage_adapter.dart';
import 'package:spooky/core/base_storages/storage_adapters/default_stroage_adapter.dart';

abstract class SharePreferenceStorage<T> extends BaseStorage<T> {
  @override
  Future<BaseStorageAdapter<T>> get adapter async => DefaultStorageAdapter<T>();
}
