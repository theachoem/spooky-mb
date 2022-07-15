import 'package:flutter/foundation.dart';
import 'package:spooky/core/backups/models/backups_metadata.dart';
import 'package:spooky/core/backups/models/backups_model.dart';
import 'package:spooky/core/db/databases/base_database.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:spooky/main.dart';
import 'dart:io';

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
    List<String> deviceInfos = await _getDeviceModel();
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

  Future<List<String>> _getDeviceModel() async {
    if (Global.instance.unitTesting) return ["Device Model", "device_id"];

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? device;
    String? id;

    if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      device = info.model ?? info.name;
      id = info.identifierForVendor;
    }

    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      device = info.model ?? info.device;
      id = info.androidId;
    }

    if (Platform.isMacOS) {
      MacOsDeviceInfo info = await deviceInfo.macOsInfo;
      device = info.model;
      id = info.systemGUID;
    }

    if (Platform.isWindows) {
      WindowsDeviceInfo info = await deviceInfo.windowsInfo;
      device = info.computerName;
      id = info.computerName;
    }

    if (Platform.isLinux) {
      LinuxDeviceInfo info = await deviceInfo.linuxInfo;
      device = info.name;
      id = info.machineId;
    }

    return [device ?? "Unknown", id ?? "unknown_id"];
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
