library security_storage;

import 'package:spooky/core/storages/base_storages/enum_storage.dart';
import 'package:spooky/core/storages/base_storages/secure_storage.dart';
import 'package:spooky/core/storages/storage_adapters/base_storage_adapter.dart';
import 'package:spooky/core/storages/storage_adapters/secure_storage_adapter.dart';

part 'lock_secret_storage.dart';
part 'lock_type_storage.dart';

class SecurityObject {
  // secret can be password, passcode
  final String? secret;
  final LockType type;

  SecurityObject(this.type, this.secret);
}

class SecurityStorage {
  final _LockTypeStorage _lockTypeStorage = _LockTypeStorage();
  final _LockSecretStorage _lockSecretStorage = _LockSecretStorage();

  Future<void> setLock(LockType type, [String? secret]) async {
    _lockTypeStorage.writeEnum(type);
    _lockSecretStorage.write(secret);
  }

  Future<SecurityObject?> getLock() async {
    LockType? lock = await _lockTypeStorage.readEnum();
    String? secret = await _lockSecretStorage.read();
    if (lock == null) return null;
    switch (lock) {
      case LockType.pin:
      case LockType.password:
        if (secret == null) return null;
        return SecurityObject(lock, secret);
      case LockType.biometric:
        return SecurityObject(lock, secret);
    }
  }

  Future<void> clearLock() async {
    _lockTypeStorage.remove();
    _lockSecretStorage.remove();
  }
}
