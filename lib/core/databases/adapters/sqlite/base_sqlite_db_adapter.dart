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
  Future<BaseDbModel?> delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future<BaseDbModel?> find(int id) {
    throw UnimplementedError();
  }

  @override
  Future<BaseDbModel?> update(BaseDbModel record) {
    throw UnimplementedError();
  }

  @override
  Future<BaseDbModel?> set(BaseDbModel record) {
    throw UnimplementedError();
  }

  @override
  Future<CollectionDbModel<BaseDbModel>?> where({Map<String, dynamic>? filters}) {
    throw UnimplementedError();
  }
}
