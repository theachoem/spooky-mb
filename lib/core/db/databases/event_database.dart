import 'package:flutter/foundation.dart';
import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/adapters/objectbox/event_objectbox_db_adapter.dart';
import 'package:spooky/core/db/databases/base_database.dart';
import 'package:spooky/core/db/models/event_db_model.dart';

EventDbModel _constructEventIsolate(Map<String, dynamic> json) {
  return EventDbModel.fromJson(json);
}

class EventDatabase extends BaseDatabase<EventDbModel> {
  static final EventDatabase instance = EventDatabase._();
  EventDatabase._();

  @override
  BaseDbAdapter<EventDbModel> get adapter => EventObjectboxDbAdapter(tableName);

  @override
  String get tableName => "events";

  @override
  Future<void> onCRUD(EventDbModel? object) async {}

  @override
  Future<EventDbModel?> objectTransformer(Map<String, dynamic> json) {
    return compute(_constructEventIsolate, json);
  }
}
