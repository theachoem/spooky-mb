import 'package:spooky_mb/core/databases/adapters/base_db_adapter.dart';
import 'package:spooky_mb/core/databases/models/base_db_model.dart';
import 'package:spooky_mb/core/databases/models/collection_db_model.dart';

class BaseObjectboxDbAdapter<T extends BaseDbModel> extends BaseDbAdapter<T> {
  @override
  Future<T?> create(T record) {
    throw UnimplementedError();
  }

  @override
  Future<T?> delete(T record) {
    throw UnimplementedError();
  }

  @override
  Future<CollectionDbModel<T>?> getAll() {
    throw UnimplementedError();
  }

  @override
  Future<T?> update(T record) {
    throw UnimplementedError();
  }

  @override
  Future<CollectionDbModel<T>?> where({
    required Map<String, dynamic> filters,
  }) {
    throw UnimplementedError();
  }
}
