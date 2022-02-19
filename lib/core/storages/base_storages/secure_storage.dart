import 'package:spooky/core/storages/base_storages/base_storage.dart';
import 'package:spooky/core/storage_adapters/base_storage_adapter.dart';
import 'package:spooky/core/storage_adapters/default_stroage_adapter.dart';

abstract class SecurePreferenceStorage extends BaseStorage<String> {
  @override
  Future<BaseStorageAdapter<String>> get adapter async => DefaultStorageAdapter<String>();
}
