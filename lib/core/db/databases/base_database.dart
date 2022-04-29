import 'package:googleapis/cloudsearch/v1.dart';
import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';

abstract class BaseDatabase<T extends BaseDbModel> {
  BaseDbAdapter get adapter;
  Object? error;

  Future<P?> beforeExec<P>(Future<P?> Function() callback) async {
    try {
      P? data = await callback();
      return data;
    } catch (e) {
      error = e;
      return null;
    }
  }

  Future<BaseDbListModel<T>?> fetchAll({
    Map<String, dynamic>? params,
  }) async {
    return beforeExec<BaseDbListModel<T>>(() async {
      Map<String, dynamic>? map = await adapter.fetchOne(params: params);
      if (map == null) throw ErrorMessage(errorMessage: "Response null");
      BaseDbListModel<T>? items = await itemsTransformer(map);
      return items;
    });
  }

  Future<T?> fetchOne({
    String? id,
    Map<String, dynamic>? params,
  }) {
    return beforeExec<T>(() async {
      Map<String, dynamic>? map = await adapter.fetchOne(id: id, params: params);
      if (map == null) throw ErrorMessage(errorMessage: "Response null");
      T? object = await objectTransformer(map);
      return object;
    });
  }

  Future<T?> create({
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {
    return beforeExec<T>(() async {
      Map<String, dynamic>? map = await adapter.create(body: body, params: params);
      if (map == null) throw ErrorMessage(errorMessage: "Response null");
      T? object = await objectTransformer(map);
      return object;
    });
  }

  Future<T?> update({
    required String id,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {
    return beforeExec<T>(() async {
      Map<String, dynamic>? map = await adapter.update(id: id, body: body, params: params);
      if (map == null) throw ErrorMessage(errorMessage: "Response null");
      T? object = await objectTransformer(map);
      return object;
    });
  }

  Future<T?> delete({
    required String id,
    Map<String, dynamic> params = const {},
  }) async {
    return beforeExec<T>(() async {
      Map<String, dynamic>? map = await adapter.delete(id: id, params: params);
      if (map == null) throw ErrorMessage(errorMessage: "Response null");
      T? object = await objectTransformer(map);
      return object;
    });
  }

  Future<BaseDbListModel<T>?> itemsTransformer(Map<String, dynamic> json);
  Future<T?> objectTransformer(Map<String, dynamic> json);

  Future<List<T>> buildItemsList(Map<String, dynamic> json) async {
    dynamic data = json['data'];

    if (data != null && data is List) {
      List<T> items = [];
      for (dynamic element in data) {
        T? item = await objectTransformer(element);
        if (item != null) {
          items.add(item);
        }
      }
      return items;
    }

    return [];
  }
}
