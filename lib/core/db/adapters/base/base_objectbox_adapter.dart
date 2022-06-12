import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/objectbox.g.dart';

abstract class BaseObjectBoxAdapter<T> extends BaseDbAdapter {
  BaseObjectBoxAdapter(String tableName) : super(tableName);
  static Store? _store;
  Box<T>? _box;

  Future<Store> get store async {
    _store ??= await openStore();
    return _store!;
  }

  Future<Box<T>> get box async {
    _box ??= (await store).box<T>();
    return _box!;
  }

  Future<void> close() async {
    (await store).close();
  }
}
