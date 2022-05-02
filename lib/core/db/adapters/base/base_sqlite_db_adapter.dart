import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';

class BaseSqliteDbAdapter extends BaseDbAdapter {
  BaseSqliteDbAdapter(String tableName) : super(tableName);

  @override
  Future<Map<String, dynamic>?> create({
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> delete({
    required String id,
    Map<String, dynamic> params = const {},
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> fetchAll({
    Map<String, dynamic>? params,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> fetchOne({
    required String id,
    Map<String, dynamic>? params,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> update({
    required String id,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) {
    throw UnimplementedError();
  }
}
