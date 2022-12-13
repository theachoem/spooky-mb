import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:spooky/core/db/adapters/base/base_objectbox_adapter.dart';
import 'package:spooky/core/db/adapters/objectbox/entities.dart';
import 'package:spooky/core/db/models/event_db_model.dart';

class EventObjectboxDbAdapter extends BaseObjectBoxAdapter<EventObjectBox, EventDbModel> {
  EventObjectboxDbAdapter(String tableName) : super(tableName);

  @override
  QueryBuilder<EventObjectBox>? buildQuery({Map<String, dynamic>? params}) => null;

  @override
  Future<EventObjectBox> objectConstructor(EventDbModel json, [Map<String, dynamic>? params]) {
    return compute(_objectConstructor, json);
  }

  @override
  Future<EventDbModel> objectTransformer(EventObjectBox object, [Map<String, dynamic>? params]) {
    return compute(_objectTransformer, object);
  }

  @override
  Future<List<EventDbModel>> itemsTransformer(List<EventObjectBox> objects, [Map<String, dynamic>? params]) {
    return compute(_itemsTransformer, objects);
  }
}

List<EventDbModel> _itemsTransformer(List<EventObjectBox> object) {
  return object.map((e) {
    return _objectTransformer(e);
  }).toList();
}

EventObjectBox _objectConstructor(EventDbModel tag) {
  return EventObjectBox(
    id: tag.id,
    budget: tag.budget,
    title: tag.title,
    lastTransactionId: tag.lastTransactionId,
    totalExpense: tag.totalExpense,
    startAt: tag.startAt,
    finishAt: tag.finishAt,
    createdAt: tag.createdAt,
    updatedAt: tag.updatedAt,
  );
}

EventDbModel _objectTransformer(EventObjectBox object) {
  return EventDbModel(
    id: object.id,
    budget: object.budget,
    title: object.title,
    lastTransactionId: object.lastTransactionId,
    totalExpense: object.totalExpense,
    startAt: object.startAt,
    finishAt: object.finishAt,
    createdAt: object.createdAt,
    updatedAt: object.updatedAt,
  );
}
