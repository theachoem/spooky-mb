import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/file_manager/base/base_file_manager.dart';
import 'package:spooky/core/models/backup_model.dart';
import 'package:spooky/core/types/file_path_type.dart';

// Once backup is synced, we store them to local storage as well.
class BackupFileManager extends BaseFileManager {
  Directory get directory => Directory("${root.path}/${FilePathType.backups.name}");
  File buildFile(int year) => File("${directory.path}/$year.json");

  // use year as file name.
  // call when backup complete
  Future<FileSystemEntity?> backup(BackupModel backup) async {
    return write(buildFile(backup.year), backup);
  }

  // call when story is saved to make it unsyned
  Future<FileSystemEntity?> unsynced(int year) async {
    return delete(buildFile(year));
  }

  // available in this list mean it already synced
  Future<List<BackupModel>> fetchAll() async {
    await ensureDirExist(directory);
    List<FileSystemEntity> result = directory.listSync();

    List<BackupModel> backups = [];
    for (FileSystemEntity file in result) {
      if (file.path.endsWith(".json") && file is File) {
        String str = await file.readAsString();
        try {
          dynamic map = jsonDecode(str);
          if (map['version'] != null) {
            BackupModel backup = BackupModel.fromJson(map);
            backups.add(backup);
          }
        } catch (e) {
          if (kDebugMode) {
            print("ERROR: $e");
          }
        }
      }
    }

    return backups;
  }
}
