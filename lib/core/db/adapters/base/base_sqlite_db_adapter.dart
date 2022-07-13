import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';

class BaseSqliteDbAdapter extends BaseDbAdapter {
  BaseSqliteDbAdapter(String tableName) : super(tableName);

  @override
  Future<BaseDbModel?> create({
    required BaseDbModel body,
    Map<String, dynamic> params = const {},
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BaseDbModel?> delete({
    required int id,
    Map<String, dynamic> params = const {},
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BaseDbListModel<BaseDbModel>> fetchAll({
    Map<String, dynamic>? params,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BaseDbModel?> fetchOne({
    required int id,
    Map<String, dynamic>? params,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BaseDbModel?> set({
    required BaseDbModel body,
    Map<String, dynamic> params = const {},
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BaseDbModel?> update({
    required int id,
    required BaseDbModel body,
    Map<String, dynamic> params = const {},
  }) {
    throw UnimplementedError();
  }
}
