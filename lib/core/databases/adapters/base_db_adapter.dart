import 'dart:async';
import 'package:spooky/core/databases/models/base_db_model.dart';
import 'package:spooky/core/databases/models/collection_db_model.dart';

abstract class BaseDbAdapter<T extends BaseDbModel> {
  final Map<int, List<FutureOr<void> Function()>> _listeners = {};

  String get tableName;

  Future<T?> find(int id);

  Future<int> count({Map<String, dynamic>? filters});
  Future<CollectionDbModel<T>?> where({
    Map<String, dynamic>? filters,
  });

  Future<T?> set(T record);
  Future<T?> update(T record);
  Future<T?> create(T record);
  Future<T?> delete(int id);

  Future<void> afterCommit(int id) async {
    for (FutureOr<void> Function() callback in _listeners[id] ?? []) {
      await callback();
    }
  }

  void addListener({
    required int recordId,
    required void Function() callback,
  }) {
    _listeners[recordId] ??= [];
    _listeners[recordId]?.add(callback);
  }

  void removeListener({
    required int recordId,
    required void Function() callback,
  }) {
    _listeners[recordId] ??= [];
    _listeners[recordId]?.remove(callback);
  }
}
