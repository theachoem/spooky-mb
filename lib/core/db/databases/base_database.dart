import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';

abstract class BaseDatabase<T extends BaseDbModel> {
  String get tableName;
  BaseDbAdapter<T> get adapter;
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
      BaseDbListModel<T>? map = await adapter.fetchAll(params: params);
      if (map == null) throw ErrorMessage(errorMessage: tr("msg.response_null"));
      return map;
    });
  }

  Future<T?> fetchOne({
    required int id,
    Map<String, dynamic>? params,
  }) {
    return beforeExec<T>(() async {
      T? map = await adapter.fetchOne(id: id, params: params);
      if (map == null) throw ErrorMessage(errorMessage: tr("msg.response_null"));
      return map;
    });
  }

  Future<T?> set({
    required T body,
    Map<String, dynamic> params = const {},
  }) async {
    return beforeExec<T>(() async {
      T? map = await adapter.set(body: body, params: params);
      if (map == null) throw ErrorMessage(errorMessage: tr("msg.response_null"));
      onCRUD(map);
      return map;
    });
  }

  Future<T?> create({
    required T body,
    Map<String, dynamic> params = const {},
  }) async {
    return beforeExec<T>(() async {
      T? map = await adapter.create(body: body, params: params);
      if (map == null) throw ErrorMessage(errorMessage: tr("msg.response_null"));
      onCRUD(map);
      return map;
    });
  }

  Future<T?> update({
    required int id,
    required T body,
    Map<String, dynamic> params = const {},
  }) async {
    return beforeExec<T>(() async {
      T? map = await adapter.update(id: id, body: body, params: params);
      if (map == null) throw ErrorMessage(errorMessage: tr("msg.response_null"));
      onCRUD(map);
      return map;
    });
  }

  Future<T?> delete({
    required int id,
    Map<String, dynamic> params = const {},
  }) async {
    return beforeExec<T>(() async {
      T? map = await adapter.delete(id: id, params: params);
      if (map != null) {
        onCRUD(map);
        return map;
      }
      return null;
    });
  }

  // For restore from backups
  Future<T?> objectTransformer(Map<String, dynamic> json);
}
