part of security_service;

abstract class _BaseLockService<T extends _BaseLockOptions> {
  Future<bool> unlock(T option);
  Future<bool> set(T option);
  Future<bool> remove(T option);
}
