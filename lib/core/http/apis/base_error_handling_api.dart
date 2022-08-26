import 'package:spooky/core/http/apis/base_api.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/commons/object_list_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class BaseErrorHandlingApi<T extends BaseModel> extends BaseApi<T> {
  DioError? _error;

  String? get errorMessage {
    dynamic data = _error?.response?.data;
    if (data is Map) return data['error'];
    return null;
  }

  Future<P?> runQueryExec<P>(Future<P?> Function() callback) async {
    try {
      response = null;
      _error = null;
      return callback();
    } catch (e) {
      if (kDebugMode) print(e);
      if (e is DioError) _error = e;
      return null;
    }
  }

  @override
  Future<ObjectListModel<T>?> fetchAll({
    Map<String, dynamic>? queryParameters,
  }) async {
    return runQueryExec<ObjectListModel<T>>(() async {
      return super.fetchAll(
        queryParameters: queryParameters,
      );
    });
  }

  @override
  Future<T?> fetchOne({
    String? id,
    bool collection = true,
    Map<String, dynamic>? queryParameters,
  }) async {
    return runQueryExec<T>(() async {
      return super.fetchOne(
        id: id,
        collection: collection,
        queryParameters: queryParameters,
      );
    });
  }

  @override
  Future<T?> create({
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return runQueryExec<T>(() async {
      return super.create(
        data: data,
        queryParameters: queryParameters,
      );
    });
  }

  @override
  Future<T?> update({
    String? id,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool collection = true,
  }) async {
    return runQueryExec<T>(() async {
      return super.update(
        id: id,
        data: data,
        queryParameters: queryParameters,
      );
    });
  }

  @override
  Future<void> delete({
    String? id,
    Map<String, dynamic>? queryParameters,
    bool collection = true,
  }) async {
    return runQueryExec<void>(() async {
      return super.delete(
        id: id,
        queryParameters: queryParameters,
        collection: collection,
      );
    });
  }
}
