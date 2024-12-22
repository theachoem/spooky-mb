import 'dart:io';
import 'package:spooky/core/databases/adapters/base_db_adapter.dart';
import 'package:spooky/core/databases/models/base_db_model.dart';
import 'package:spooky/core/databases/models/collection_db_model.dart';
import 'package:spooky/core/services/file_service.dart';
import 'package:spooky/objectbox.g.dart';

abstract class BaseObjectBox<B, T extends BaseDbModel> extends BaseDbAdapter<T> {
  String get tableName;

  static Store? _store;
  Store get store => _store!;

  Box<B>? _box;

  Box<B> get box {
    _box ??= store.box<B>();
    return _box!;
  }

  Future<B> objectConstructor(T object, [Map<String, dynamic>? options]);
  Future<T> objectTransformer(B object, [Map<String, dynamic>? options]);
  Future<List<T>> itemsTransformer(
    List<B> objects, [
    Map<String, dynamic>? options,
  ]);

  Future<void> initilize() async {
    if (_store != null) return;

    Directory directory = Directory(FileService.addDirectory("database/objectbox"));
    if (!await directory.exists()) await directory.create(recursive: true);

    _store = await openStore(
      directory: directory.path,
      macosApplicationGroup: '24KJ877SZ9',
    );
  }

  @override
  Future<T?> find(int id) async {
    B? object = box.get(id);

    if (object != null) {
      return objectTransformer(object);
    } else {
      return null;
    }
  }

  QueryBuilder<B>? buildQuery({
    Map<String, dynamic>? filters,
  });

  @override
  Future<int> count({
    Map<String, dynamic>? filters,
  }) async {
    QueryBuilder<B>? queryBuilder = buildQuery(filters: filters);

    if (queryBuilder != null) {
      Query<B>? query = queryBuilder.build();
      return query.count();
    } else {
      return box.count();
    }
  }

  @override
  Future<CollectionDbModel<T>?> where({
    Map<String, dynamic>? filters,
  }) async {
    List<B> objects;
    QueryBuilder<B>? queryBuilder = buildQuery(filters: filters);

    if (queryBuilder != null) {
      Query<B>? query = queryBuilder.build();
      objects = await query.findAsync();
    } else {
      objects = await box.getAllAsync();
    }

    List<T> docs = await itemsTransformer(objects);
    return CollectionDbModel<T>(items: docs);
  }

  @override
  Future<T?> set(T record) async {
    B constructed = await objectConstructor(record);
    await box.putAsync(constructed, mode: PutMode.put);
    afterCommit(record.id);
    return record;
  }

  @override
  Future<T?> update(T record) async {
    B constructed = await objectConstructor(record);
    await box.putAsync(constructed, mode: PutMode.update);
    afterCommit(record.id);
    return record;
  }

  @override
  Future<T?> create(T record) async {
    B constructed = await objectConstructor(record);
    await box.putAsync(constructed, mode: PutMode.insert);
    afterCommit(record.id);
    return record;
  }

  @override
  Future<T?> delete(int id) async {
    await box.removeAsync(id);
    afterCommit(id);
    return null;
  }
}
