import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:spooky/core/db/adapters/base/base_objectbox_adapter.dart';
import 'package:spooky/core/db/adapters/objectbox/entities.dart';
import 'package:spooky/core/db/models/bill_db_model.dart';

class BillObjectboxDbAdapter extends BaseObjectBoxAdapter<BillObjectBox, BillDbModel> {
  BillObjectboxDbAdapter(String tableName) : super(tableName);

  @override
  QueryBuilder<BillObjectBox>? buildQuery({Map<String, dynamic>? params}) => null;

  @override
  Future<BillObjectBox> objectConstructor(BillDbModel json, [Map<String, dynamic>? params]) {
    return compute(_objectConstructor, json);
  }

  @override
  Future<BillDbModel> objectTransformer(BillObjectBox object, [Map<String, dynamic>? params]) {
    return compute(_objectTransformer, object);
  }

  @override
  Future<List<BillDbModel>> itemsTransformer(List<BillObjectBox> objects, [Map<String, dynamic>? params]) {
    return compute(_itemsTransformer, objects);
  }
}

List<BillDbModel> _itemsTransformer(List<BillObjectBox> object) {
  return object.map((e) {
    return _objectTransformer(e);
  }).toList();
}

BillObjectBox _objectConstructor(BillDbModel tag) {
  return BillObjectBox(
    id: tag.id,
    cron: tag.cron,
    startAt: tag.startAt,
    finishAt: tag.finishAt,
    title: tag.title,
    categoryId: tag.categoryId,
    lastTransactionId: tag.lastTransactionId,
    autoAddTranaction: tag.autoAddTranaction,
    totalExpense: tag.totalExpense,
    createdAt: tag.createdAt,
    updatedAt: tag.updatedAt,
  );
}

BillDbModel _objectTransformer(BillObjectBox object) {
  return BillDbModel(
    id: object.id,
    cron: object.cron,
    startAt: object.startAt,
    finishAt: object.finishAt,
    title: object.title,
    categoryId: object.categoryId,
    lastTransactionId: object.lastTransactionId,
    autoAddTranaction: object.autoAddTranaction,
    totalExpense: object.totalExpense,
    createdAt: object.createdAt,
    updatedAt: object.updatedAt,
  );
}
