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

part 'back_backup_helper.dart';

abstract class BaseBackupSource {
  String get cloudId;

  final List<BaseDbAdapter> databases = [
    StoryDbModel.db,
    TagDbModel.db,
  ];

  bool? isSignedIn;
  bool? synced;

  Future<bool> checkIsSignedIn();
  Future<bool> reauthenticate();
  Future<bool> signIn();
  Future<bool> signOut();
  Future<bool> uploadFile(String fileName, io.File file);
  Future<void> deleteCloudFile(CloudFileObject file);

  Future<void> load() async {
    isSignedIn = await checkIsSignedIn();

    if (isSignedIn == true) {
      await reauthenticate();
    }
  }

  Future<CloudFileListObject?> fetchAllCloudFiles({
    String? nextToken,
  });

  Future<void> backup() async {
    BackupObject backup = await _BaseBackupHelper().constructBackup(databases);
    final io.File file = await _BaseBackupHelper().constructFile(cloudId, backup);

    await uploadFile(backup.fileInfo.fileNameWithExtention, file);
  }
}
