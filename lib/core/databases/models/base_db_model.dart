import 'package:spooky_mb/core/databases/adapters/base_db_adapter.dart';

abstract class BaseDbModel {
  BaseDbAdapter get dbAdapter;

  Map<String, dynamic> toJson();
}
