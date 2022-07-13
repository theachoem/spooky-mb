import 'dart:io';
import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';
import 'package:spooky/core/db/models/base/links_model.dart';
import 'package:spooky/core/db/models/base/meta_model.dart';
import 'package:spooky/objectbox.g.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

abstract class BaseObjectBoxAdapter<T, P extends BaseDbModel> extends BaseDbAdapter<P> {
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

  Future<P> objectTransformer(T object);
  Future<List<P>> itemsTransformer(List<T> objects);
  Future<T> objectConstructor(Map<String, dynamic> json);
  QueryBuilder<T>? buildQuery({Map<String, dynamic>? params});

  @override
  Future<BaseDbListModel<P>> fetchAll({
    Map<String, dynamic>? params,
  }) async {
    List<T> objects;
    QueryBuilder<T>? queryBuilder = buildQuery(params: params);

    if (queryBuilder != null) {
      Query<T>? query = queryBuilder.build();
      objects = query.find();
    } else {
      objects = box.getAll();
    }

    List<P> docs = await itemsTransformer(objects);
    return BaseDbListModel(
      items: docs,
      meta: MetaModel(),
      links: LinksModel(),
    );
  }

  @override
  Future<P?> fetchOne({
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
  Future<P?> delete({
    required int id,
    Map<String, dynamic> params = const {},
  }) async {
    box.remove(id);
    return null;
  }

  @override
  Future<P?> set({
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {
    int id = body['id'];
    bool exists = box.contains(id);
    if (!exists || id == 0) {
      return create(
        body: body,
        params: params,
      );
    } else {
      return update(
        id: id,
        body: body,
        params: params,
      );
    }
  }

  @override
  Future<P?> create({
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {
    T constructed = await objectConstructor(body);
    int id = box.put(constructed, mode: PutMode.insert);
    body['id'] = id;
    return null;
  }

  @override
  Future<P?> update({
    required int id,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {
    T object = await objectConstructor(body);
    box.put(object, mode: PutMode.update);
    return null;
  }
}
