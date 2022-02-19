import 'package:spooky/core/storages/base_storages/enum_storage.dart';
import 'package:spooky/core/storages/storage_adapters/base_storage_adapter.dart';
import 'package:spooky/core/storages/storage_adapters/secure_storage_adapter.dart';

enum LockedType {
  pin,
  password,
  biometric,
}

class LockStorage extends EnumPreferenceStorage<LockedType> {
  @override
  Future<BaseStorageAdapter<String>> get adapter async => SecureStorageAdapter();

  @override
  List<LockedType> get values => LockedType.values;
}
