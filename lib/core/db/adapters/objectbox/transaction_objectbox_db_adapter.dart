import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:spooky/core/db/adapters/base/base_objectbox_adapter.dart';
import 'package:spooky/core/db/adapters/objectbox/entities.dart';
import 'package:spooky/core/db/models/transaction_db_model.dart';

class TransactionObjectboxDbAdapter extends BaseObjectBoxAdapter<TransactionObjectBox, TransactionDbModel> {
  TransactionObjectboxDbAdapter(String tableName) : super(tableName);

  @override
  QueryBuilder<TransactionObjectBox>? buildQuery({Map<String, dynamic>? params}) => null;

  @override
  Future<TransactionObjectBox> objectConstructor(TransactionDbModel json, [Map<String, dynamic>? params]) {
    return compute(_objectConstructor, json);
  }

  @override
  Future<TransactionDbModel> objectTransformer(TransactionObjectBox object, [Map<String, dynamic>? params]) {
    return compute(_objectTransformer, object);
  }

  @override
  Future<List<TransactionDbModel>> itemsTransformer(List<TransactionObjectBox> objects,
      [Map<String, dynamic>? params]) {
    return compute(_itemsTransformer, objects);
  }
}

List<TransactionDbModel> _itemsTransformer(List<TransactionObjectBox> object) {
  return object.map((e) {
    return _objectTransformer(e);
  }).toList();
}

TransactionObjectBox _objectConstructor(TransactionDbModel tag) {
  return TransactionObjectBox(
    id: tag.id,
    day: tag.day,
    month: tag.month,
    year: tag.year,
    time: tag.time,
    specificDate: tag.specificDate,
    note: tag.note,
    eventId: tag.eventId,
    billingId: tag.billingId,
    categoryId: tag.categoryId,
    createdAt: tag.createdAt,
    updatedAt: tag.updatedAt,
  );
}

TransactionDbModel _objectTransformer(TransactionObjectBox object) {
  return TransactionDbModel(
    id: object.id,
    day: object.day,
    month: object.month,
    year: object.year,
    time: object.time,
    specificDate: object.specificDate,
    note: object.note,
    eventId: object.eventId,
    billingId: object.billingId,
    categoryId: object.categoryId,
    createdAt: object.createdAt,
    updatedAt: object.updatedAt,
  );
}
