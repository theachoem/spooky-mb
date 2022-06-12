import 'package:flutter/foundation.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';
import 'package:spooky/core/db/models/base/links_model.dart';
import 'package:spooky/core/db/models/base/meta_model.dart';

abstract class BaseDatabase<T extends BaseDbModel> {
  BaseDbAdapter get adapter;
  ErrorMessage? error;
  Object? errorObject;

  Future<P?> beforeExec<P>(Future<P?> Function() callback) async {
    try {
      P? data = await callback();
      return data;
    } catch (e) {
      errorObject = error;

      if (e is ErrorMessage) {
        error = e;
      } else if (kDebugMode) {
        rethrow;
      }

      return null;
    }
  }

  Future<void> onCRUD(T? object);

  Future<BaseDbListModel<T>?> fetchAll({
    Map<String, dynamic>? params,
  }) async {
    return beforeExec<BaseDbListModel<T>>(() async {
      Map<String, dynamic>? map = await adapter.fetchAll(params: params);
      if (map == null) throw ErrorMessage(errorMessage: "Response null");
      BaseDbListModel<T>? items = await itemsTransformer(map);
      return items;
    });
  }

  Future<T?> fetchOne({
    required int id,
    Map<String, dynamic>? params,
  }) {
    return beforeExec<T>(() async {
      Map<String, dynamic>? map = await adapter.fetchOne(id: id, params: params);
      if (map == null) throw ErrorMessage(errorMessage: "Response null");
      T? object = await objectTransformer(map);
      return object;
    });
  }

  Future<T?> set({
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {
    return beforeExec<T>(() async {
      Map<String, dynamic>? map = await adapter.set(body: body, params: params);
      if (map == null) throw ErrorMessage(errorMessage: "Response null");
      T? object = await objectTransformer(map);
      onCRUD(object);
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
      onCRUD(object);
      return object;
    });
  }

  Future<T?> update({
    required int id,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {
    return beforeExec<T>(() async {
      Map<String, dynamic>? map = await adapter.update(id: id, body: body, params: params);
      if (map == null) throw ErrorMessage(errorMessage: "Response null");
      T? object = await objectTransformer(map);
      onCRUD(object);
      return object;
    });
  }

  Future<T?> delete({
    required int id,
    Map<String, dynamic> params = const {},
  }) async {
    return beforeExec<T>(() async {
      Map<String, dynamic>? map = await adapter.delete(id: id, params: params);
      if (map != null) {
        T? object = await objectTransformer(map);
        onCRUD(object);
        return object;
      }
      return null;
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

  Future<MetaModel?> buildMeta(Map<String, dynamic> json) async {
    dynamic meta = json['meta'];
    if (meta != null && meta is Map<String, dynamic>) {
      return MetaModel.fromJson(meta);
    }
    return null;
  }

  Future<LinksModel?> buildLinks(Map<String, dynamic> json) async {
    dynamic links = json['links'];
    if (links != null && links is Map<String, dynamic>) {
      return LinksModel.fromJson(links);
    }
    return null;
  }
}
