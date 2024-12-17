import 'package:spooky_mb/core/databases/adapters/base_db_adapter.dart';
import 'package:spooky_mb/core/databases/models/base_db_model.dart';
import 'package:spooky_mb/core/databases/models/collection_db_model.dart';

// This is just for example.
class BaseSqliteDbAdapter extends BaseDbAdapter {
  @override
  Future<BaseDbModel?> create(BaseDbModel record) {
    throw UnimplementedError();
  }

  @override
  Future<BaseDbModel?> delete(BaseDbModel record) {
    throw UnimplementedError();
  }

  @override
  Future<CollectionDbModel<BaseDbModel>?> getAll() {
    throw UnimplementedError();
  }

  @override
  Future<BaseDbModel?> update(BaseDbModel record) {
    throw UnimplementedError();
  }

  @override
  Future<CollectionDbModel<BaseDbModel>?> where({
    required Map<String, dynamic> filters,
  }) {
    throw UnimplementedError();
  }
}
