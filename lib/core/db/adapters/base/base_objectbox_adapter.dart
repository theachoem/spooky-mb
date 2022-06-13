import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/objectbox.g.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

abstract class BaseObjectBoxAdapter<T> extends BaseDbAdapter {
  BaseObjectBoxAdapter(String tableName) : super(tableName);
  static Store? _store;
  Store get store => _store!;

  Box<T>? _box;

  Box<T> get box {
    _box ??= store.box<T>();
    return _box!;
  }

  static Future<void> initilize() async {
    if (_store != null) return;
    Directory directory = Directory(FileHelper.addDirectory("database/objectbox"));
    if (!directory.existsSync()) await directory.create(recursive: true);
    _store = await openStore(directory: directory.path, macosApplicationGroup: '24KJ877SZ9');
  }

  Future<void> close() async {
    store.close();
  }

  Map<String, dynamic> objectTransformer(T object);
  Future<T> objectConstructor(Map<String, dynamic> json);

  @override
  Future<Map<String, dynamic>?> fetchOne({
    required int id,
    Map<String, dynamic>? params,
  }) async {
    T? object = box.get(id);
    if (object != null) {
      return objectTransformer(object);
    } else {
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> delete({
    required int id,
    Map<String, dynamic> params = const {},
  }) async {
    box.remove(id);
    return null;
  }

  @override
  Future<Map<String, dynamic>?> set({
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {
    int id = box.put(await objectConstructor(body), mode: PutMode.put);
    Map<String, dynamic>? object = await fetchOne(id: body['id']);
    if (kDebugMode) {
      print(
        'OBJECT: $id - ${body['id']} - ${object?['id']}: ${body['year']}/${body['month']} - ${object?['year']}/${object?['month']}',
      );
    }
    return object;
  }

  @override
  Future<Map<String, dynamic>?> create({
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {
    int id = box.put(
      await objectConstructor(body),
      mode: PutMode.insert,
    );
    return fetchOne(id: id);
  }

  @override
  Future<Map<String, dynamic>?> update({
    required int id,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {
    T object = await objectConstructor(body);
    await box.putAsync(
      object,
      mode: PutMode.update,
    );
    return fetchOne(id: id);
  }
}
