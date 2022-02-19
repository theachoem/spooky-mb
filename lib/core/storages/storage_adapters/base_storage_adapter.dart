abstract class BaseStorageAdapter<T> {
  Future<T?> read({required String key});
  Future<void> write({required String key, required T value});
  Future<void> remove({required String key});
}
