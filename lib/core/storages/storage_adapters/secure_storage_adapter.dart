import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spooky/core/storages/storage_adapters/base_storage_adapter.dart';

class SecureStorageAdapter extends BaseStorageAdapter<String> {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Future<String?> read({required String key}) {
    return storage.read(key: key);
  }

  @override
  Future<void> write({
    required String key,
    required String value,
  }) {
    return storage.write(key: key, value: value);
  }

  @override
  Future<void> remove({required String key}) {
    return storage.delete(key: key);
  }
}
