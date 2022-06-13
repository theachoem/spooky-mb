library backup;

import 'dart:io';
import 'package:spooky/core/api/cloud_storages/gdrive_backup_storage.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/file_manager/managers/backup_file_manager.dart';
import 'package:spooky/core/models/backup_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/types/path_type.dart';

part 'backup_constructor.dart';

class BackupService with BackupConstructor {
  final BackupFileManager _backupFileManager = BackupFileManager();
  final GDriveBackupStorage _gDriveBackupStorage = GDriveBackupStorage();

  Future<void> backup(int year) async {
    BackupModel? backup = await generateBackupsForAYears(year);
    if (backup != null) {
      FileSystemEntity? file = await _backupFileManager.backup(backup);
      if (file != null) {
        CloudFileModel? cloudFile = await _gDriveBackupStorage.write({
          "file": file,
          "backup": backup,
        });
        bool success = cloudFile != null;
        if (!success) await file.delete();
      }
    }
  }

  Future<void> restore(BackupModel? backup) async {
    if (backup != null && backup.version != null) {
      for (StoryDbModel e in backup.stories) {
        await StoryDatabase.instance.set(body: e.toJson());
      }
    }
  }
}
