import 'package:spooky/core/databases/adapters/base_db_adapter.dart';
import 'package:spooky/core/databases/models/base_db_model.dart';
import 'package:spooky/core/objects/backup_object.dart';
import 'package:spooky/core/services/backup_sources/base_backup_source.dart';

class RestoreBackupService {
  Future<void> restore({
    required BackupObject backup,
  }) async {
    Map<String, dynamic> tables = backup.tables;
    Map<String, List<BaseDbModel>> datas = decodeTables(tables);

    for (BaseDbAdapter db in BaseBackupSource.databases) {
      List<BaseDbModel>? items = datas[db.tableName];
      if (items != null) {
        for (BaseDbModel item in items) {
          await db.set(item);
        }
      }
    }
  }

  // {
  //   "stories": [ story1, story2 ],
  //   "todos": [ todo1, todo2 ]
  // }
  Map<String, List<BaseDbModel>> decodeTables(
    Map<String, dynamic> tables,
  ) {
    Map<String, List<BaseDbModel>> maps = {};

    for (BaseDbAdapter db in BaseBackupSource.databases) {
      dynamic contents = tables[db.tableName];
      if (contents is List) {
        maps[db.tableName] = _decodeContents(contents, db);
      }
    }

    return maps;
  }

  List<T> _decodeContents<T extends BaseDbModel>(
    List contents,
    BaseDbAdapter<T> db,
  ) {
    List<T> items = [];

    for (dynamic json in contents) {
      if (json is Map<String, dynamic>) {
        T? item = db.modelFromJson(json);
        items.add(item);
      }
    }

    return items;
  }
}
