part of security_storage;

enum LockType {
  pin,
  password,
  biometric,
}

class _LockTypeStorage extends EnumStorage<LockType> {
  @override
  Future<BaseStorageAdapter<String>> get adapter async => SecureStorageAdapter();

  @override
  List<LockType> get values => LockType.values;
}
