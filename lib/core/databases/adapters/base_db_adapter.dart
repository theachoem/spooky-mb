import 'package:spooky_mb/core/databases/models/base_db_model.dart';
import 'package:spooky_mb/core/databases/models/collection_db_model.dart';

abstract class BaseDbAdapter<T extends BaseDbModel> {
  Future<T?> find(int id);

  Future<CollectionDbModel<T>?> where({
    Map<String, dynamic>? filters,
  });

  Future<T?> update(T record);
  Future<T?> set(T record);
  Future<T?> create(T record);
  Future<T?> delete(int id);
}
