import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';

abstract class BaseFileDbAdapter extends BaseDbAdapter {
  BaseFileDbAdapter(String tableName) : super(tableName);
}
