import 'dart:io';
import 'package:spooky_mb/core/databases/adapters/base_db_adapter.dart';
import 'package:spooky_mb/core/databases/models/base_db_model.dart';
import 'package:spooky_mb/core/databases/models/collection_db_model.dart';
import 'package:spooky_mb/core/services/file_service.dart';
import 'package:spooky_mb/objectbox.g.dart';

abstract class BaseObjectBox<B, T extends BaseDbModel> extends BaseDbAdapter<T> {
  String get tableName;

  static Store? _store;
  Store get store => _store!;

  Box<B>? _box;

  Box<B> get box {
    _box ??= store.box<B>();
    return _box!;
  }

  Future<B> objectConstructor(T object, [Map<String, dynamic>? params]);
  Future<T> objectTransformer(B object, [Map<String, dynamic>? params]);
  Future<List<T>> itemsTransformer(
    List<B> objects, [
    Map<String, dynamic>? params,
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
  Future<CollectionDbModel<T>?> where({
    Map<String, dynamic>? filters,
  }) async {
    List<B> objects;
    QueryBuilder<B>? queryBuilder = buildQuery(filters: filters);

    if (queryBuilder != null) {
      Query<B>? query = queryBuilder.build();
      objects = query.find();
    } else {
      objects = box.getAll();
    }

    List<T> docs = await itemsTransformer(objects);
    return CollectionDbModel<T>(items: docs);
  }

  @override
  Future<T?> update(T record) async {
    B constructed = await objectConstructor(record);
    await box.putAsync(constructed, mode: PutMode.update);
    return record;
  }

  @override
  Future<T?> set(T record) async {
    B constructed = await objectConstructor(record);
    await box.putAsync(constructed, mode: PutMode.put);
    return record;
  }

  @override
  Future<T?> create(T record) async {
    B constructed = await objectConstructor(record);
    await box.putAsync(constructed, mode: PutMode.put);
    return record;
  }

  @override
  Future<T?> delete(int id) async {
    await box.removeAsync(id);
    return null;
  }
}
