import 'package:spooky/core/storages/base_object_storages/map_storage.dart';
import 'package:spooky/core/storages/storage_adapters/base_storage_adapter.dart';
import 'package:spooky/core/storages/storage_adapters/default_storage_adapter.dart';
import 'package:spooky/core/storages/storage_adapters/secure_storage_adapter.dart';
import 'package:spooky/main.dart';

abstract class TokenStorage extends MapStorage {
  @override
  Future<BaseStorageAdapter<String>> get adapter async {
    if (Global.instance.unitTesting) {
      return DefaultStorageAdapter<String>();
    } else {
      return SecureStorageAdapter<String>();
    }
  }
}
