import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/adapters/objectbox/transaction_objectbox_db_adapter.dart';
import 'package:spooky/core/db/databases/base_database.dart';
import 'package:spooky/core/db/models/transaction_db_model.dart';

class TransactionDatabase extends BaseDatabase<TransactionDbModel> {
  static final TransactionDatabase instance = TransactionDatabase._();
  TransactionDatabase._();

  @override
  BaseDbAdapter<TransactionDbModel> get adapter => TransactionObjectboxDbAdapter(tableName);

  @override
  String get tableName => "transactions";

  @override
  Future<void> onCRUD(TransactionDbModel? object) async {}
}
