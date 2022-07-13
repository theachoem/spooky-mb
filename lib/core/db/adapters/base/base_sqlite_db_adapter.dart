import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';

class BaseSqliteDbAdapter extends BaseDbAdapter {
  BaseSqliteDbAdapter(String tableName) : super(tableName);

  @override
  Future<BaseDbModel?> create({
    Map<String, dynamic> body = const {},
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
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BaseDbModel?> update({
    required int id,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) {
    throw UnimplementedError();
  }
}
