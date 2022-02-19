import 'package:spooky/core/base_storages/bool_preference_storage.dart';
import 'package:spooky/core/base_storages/storage_adapters/base_storage_adapter.dart';
import 'package:spooky/core/base_storages/storage_adapters/default_stroage_adapter.dart';

class DeveloperModeStorage extends BoolPreferenceStorage {
  @override
  Future<BaseStorageAdapter<bool>> get adapter async => DefaultStorageAdapter<bool>();
}
