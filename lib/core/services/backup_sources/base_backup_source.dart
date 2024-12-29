import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' show getApplicationSupportDirectory;
import 'package:spooky/core/databases/adapters/base_db_adapter.dart';
import 'package:spooky/core/databases/models/base_db_model.dart';
import 'package:spooky/core/databases/models/collection_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/databases/models/tag_db_model.dart';
import 'package:spooky/core/objects/backup_file_object.dart';
import 'package:spooky/core/objects/backup_object.dart';
import 'package:spooky/core/objects/cloud_file_list_object.dart';
import 'package:spooky/core/objects/cloud_file_object.dart';
import 'package:spooky/core/objects/device_info_object.dart';
import 'package:spooky/core/types/file_path_type.dart';

part 'base_backup_helper.dart';

abstract class BaseBackupSource {
  String get cloudId;

  static final List<BaseDbAdapter> databases = [
    StoryDbModel.db,
    TagDbModel.db,
  ];

  bool? isSignedIn;
  CloudFileObject? syncedFile;

  DateTime? get lastSyncedAt {
    return syncedFile?.getFileInfo()?.createdAt;
  }

  Future<bool> checkIsSignedIn();
  Future<bool> reauthenticate();
  Future<bool> signIn();
  Future<bool> signOut();
  Future<bool> uploadFile(String fileName, io.File file);
  Future<CloudFileObject?> getFileByFileName(String fileName);
  Future<void> deleteCloudFile(CloudFileObject file);

  Future<void> load({
    required DateTime? lastDbUpdatedAt,
  }) async {
    isSignedIn = await checkIsSignedIn();

    if (isSignedIn == true) {
      await reauthenticate();
    }

    await loadSyncedFile(lastDbUpdatedAt);
  }

  Future<CloudFileListObject?> fetchAllCloudFiles({
    String? nextToken,
  });

  Future<void> backup({
    required DateTime lastUpdatedAt,
  }) async {
    BackupObject backup = await _BaseBackupHelper().constructBackup(databases: databases, lastUpdatedAt: lastUpdatedAt);
    final io.File file = await _BaseBackupHelper().constructFile(cloudId, backup);

    await uploadFile(backup.fileInfo.fileNameWithExtention, file);
    await loadSyncedFile(lastUpdatedAt);
  }

  Future<void> loadSyncedFile(DateTime? lastDbUpdatedAt) async {
    if (lastDbUpdatedAt != null) {
      String fileName = BackupFileObject(
        createdAt: lastDbUpdatedAt,
        device: await DeviceInfoObject.get(),
      ).fileNameWithExtention;

      syncedFile = await getFileByFileName(fileName);
    } else {
      syncedFile = null;
    }
  }
}
