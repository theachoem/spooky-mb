import 'package:flutter/foundation.dart';
import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/adapters/objectbox/bill_objectbox_db_adapter.dart';
import 'package:spooky/core/db/databases/base_database.dart';
import 'package:spooky/core/db/models/bill_db_model.dart';

BillDbModel _constructBillIsolate(Map<String, dynamic> json) {
  return BillDbModel.fromJson(json);
}

class BillDatabase extends BaseDatabase<BillDbModel> {
  static final BillDatabase instance = BillDatabase._();
  BillDatabase._();

  @override
  BaseDbAdapter<BillDbModel> get adapter => BillObjectboxDbAdapter(tableName);

  @override
  String get tableName => "bills";

  @override
  Future<void> onCRUD(BillDbModel? object) async {}

  @override
  Future<BillDbModel?> objectTransformer(Map<String, dynamic> json) {
    return compute(_constructBillIsolate, json);
  }
}
