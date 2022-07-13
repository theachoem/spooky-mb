import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';

abstract class BaseDbAdapter<T extends BaseDbModel> {
  final String tableName;
  BaseDbAdapter(this.tableName);

  Future<BaseDbListModel<T>?> fetchAll({
    Map<String, dynamic>? params,
  });

  Future<T?> fetchOne({
    required int id,
    Map<String, dynamic>? params,
  });

  Future<T?> set({
    required T body,
    Map<String, dynamic> params = const {},
  });

  Future<T?> create({
    required T body,
    Map<String, dynamic> params = const {},
  });

  Future<T?> update({
    required int id,
    required T body,
    Map<String, dynamic> params = const {},
  });

  Future<T?> delete({
    required int id,
    Map<String, dynamic> params = const {},
  });
}
