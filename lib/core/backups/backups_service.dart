import 'dart:io';
import 'package:spooky/core/backups/backups_file_manager.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/mixins/backups_cachable.dart';
import 'package:spooky/core/backups/mixins/backups_constructor.dart';
import 'package:spooky/core/backups/models/backups_model.dart';
import 'package:spooky/core/db/databases/base_database.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/databases/tag_database.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';

class BackupsService with BackupsConstructor, BackupsCachable {
  BackupsService._();
  static BackupsService get instance => BackupsService._();
  final BackupsFileManager manager = BackupsFileManager();

  final List<BaseDatabase> databases = [
    StoryDatabase.instance,
    TagDatabase.instance,
  ];

  Future<CloudFileModel?> backup({
    required BaseBackupDestination destination,
  }) async {
    DateTime currentDate = DateTime.now();
    BackupsModel backups = await constructBackupsModel(databases, currentDate);
    FileSystemEntity? file = await manager.syncBackups(
      backups: backups,
      cloudStorageId: destination.cloudId,
    );

    if (file?.existsSync() == true) {
      CloudFileModel? cloudFile = await destination.backup(file!, backups);
      if (cloudFile == null) file.deleteSync();
      return cloudFile;
    }

    return null;
  }

  Future<void> restore({
    required BackupsModel backups,
  }) async {
    Map<String, dynamic> tables = backups.tables;
    Map<String, List<BaseDbModel>> datas = await decodeTables(databases, tables);
    for (BaseDatabase db in databases) {
      List<BaseDbModel>? items = datas[db.tableName];
      if (items != null) {
        for (BaseDbModel element in items) {
          await db.set(body: element.toJson());
        }
      }
    }
  }

  Future<BackupsModel?> download({
    required CloudFileModel file,
    required BaseBackupDestination destination,
  }) async {
    if (isDownloaded(file.id) != null) return isDownloaded(file.id);
    BackupsModel? backups = await destination.download(file);
    if (backups != null) setCache(file.id, backups);
    return backups;
  }
}
