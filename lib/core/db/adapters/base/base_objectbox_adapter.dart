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

  Map<String, dynamic> objectTransformer(T object);
  Future<T> objectConstructor(Map<String, dynamic> json);

  @override
  Future<Map<String, dynamic>?> create({
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {
    int id = (await box).put(
      await objectConstructor(body),
      mode: PutMode.insert,
    );
    return fetchOne(id: id);
  }

  @override
  Future<Map<String, dynamic>?> fetchOne({
    required int id,
    Map<String, dynamic>? params,
  }) async {
    T? object = (await box).get(id);
    if (object != null) {
      return objectTransformer(object);
    } else {
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> delete({
    required int id,
    Map<String, dynamic> params = const {},
  }) async {
    (await box).remove(id);
    return null;
  }

  @override
  Future<Map<String, dynamic>?> update({
    required int id,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {
    T object = await objectConstructor(body);
    await (await box).putAsync(
      object,
      mode: PutMode.update,
    );
    return fetchOne(id: id);
  }
}
