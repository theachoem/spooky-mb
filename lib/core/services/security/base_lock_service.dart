part of security_service;

abstract class _BaseLockService<T extends _BaseLockOptions> {
  Future<bool> set(T option);
  Future<bool> update(T option);
  Future<bool> remove(T option);
  Future<bool> unlock(T option);
}
