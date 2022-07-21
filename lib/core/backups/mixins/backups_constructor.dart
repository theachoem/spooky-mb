import 'package:flutter/foundation.dart';
import 'package:spooky/core/backups/models/backups_metadata.dart';
import 'package:spooky/core/backups/models/backups_model.dart';
import 'package:spooky/core/db/databases/base_database.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';

import 'package:spooky/utils/helpers/app_helper.dart';

mixin BackupsConstructor {
  /// ```dart
  /// return {
  ///   "version": 1,
  ///   "stories": [
  ///     StoryDbModel(...)
  ///   ],
  ///   "todos": [
  ///     TodoModel(...)
  ///   ],
  /// }
  /// ```
  Future<Map<String, dynamic>> constructTables(List<BaseDatabase> databases) async {
    Map<String, dynamic> tables = {};
    for (BaseDatabase db in databases) {
      BaseDbListModel<BaseDbModel>? items;
      items = await db.fetchAll(params: {'all_changes': true});
      if (items != null) {
        List<Map<String, dynamic>> data = await compute(_toJson, items);
        tables[db.tableName] = data;
      }
    }
    return tables;
  }

  // {
  //   "stories": [ story1, story2 ],
  //   "todos": [ todo1, todo2 ]
  // }
  Future<Map<String, List<BaseDbModel>>> decodeTables(
    List<BaseDatabase<BaseDbModel>> databases,
    Map<String, dynamic> tables,
  ) async {
    Map<String, List<BaseDbModel>> maps = {};
    for (BaseDatabase db in databases) {
      dynamic contents = tables[db.tableName];
      if (contents is List) {
        maps[db.tableName] = await _decodeContents(contents, db);
      }
    }
    return maps;
  }

  Future<BackupsModel> constructBackupsModel(
    List<BaseDatabase> databases, [
    DateTime? currentDate,
  ]) async {
    List<String> deviceInfos = await AppHelper.getDeviceModel();
    Map<String, dynamic> tables = await constructTables(databases);
    return BackupsModel(
      tables: tables,
      metaData: BackupsMetadata(
        deviceModel: deviceInfos[0],
        deviceId: deviceInfos[1],
        createdAt: currentDate ?? DateTime.now(),
      ),
    );
  }

  Future<List<T>> _decodeContents<T extends BaseDbModel>(
    List contents,
    BaseDatabase<T> db,
  ) async {
    List<T> items = [];
    for (dynamic json in contents) {
      if (json is Map<String, dynamic>) {
        T? item = await db.objectTransformer(json);
        if (item != null) items.add(item);
      }
    }
    return items;
  }
}

List<Map<String, dynamic>> _toJson(BaseDbListModel<BaseDbModel> items) {
  return items.items.map((e) => e.toJson()).toList();
}
