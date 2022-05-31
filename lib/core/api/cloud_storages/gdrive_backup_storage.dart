import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:spooky/core/api/cloud_storages/gdrive_storage.dart';
import 'package:spooky/core/models/backup_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';

class GDriveBackupStorage extends GDriveStorage {
  @override
  Future<CloudFileModel?> write(Map<String, dynamic> options) async {
    File file = options['file'];
    BackupModel backup = options['backup'];

    drive.DriveApi? driveApi = await driveClient;
    if (driveApi != null) {
      drive.File fileToUpload = drive.File();
      fileToUpload.name = backup.fileName;
      fileToUpload.parents = ["appDataFolder"];
      drive.File recieved = await driveApi.files.create(
        fileToUpload,
        uploadMedia: drive.Media(
          file.openRead(),
          file.lengthSync(),
        ),
      );
      if (recieved.id != null) {
        await removeOldHistories(options, backup, recieved);
        return CloudFileModel(
          fileName: recieved.name,
          id: recieved.id!,
          description: recieved.description,
        );
      }
    }

    return null;
  }

  Future<void> removeOldHistories(
    Map<String, dynamic> options,
    BackupModel backup,
    drive.File recieved,
  ) async {
    try {
      List<CloudFileModel> files = await list(options).then((value) => value!.files) ?? [];
      files = files.where((e) => e.fileName?.startsWith(backup.year.toString()) == true).toList();
      files.sort((a, b) => b.fileName!.compareTo(a.fileName!));
      for (int i = 5; i < files.length; i++) {
        if (files[i].id != recieved.id) {
          await delete({"file_id": files[i].id});
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("ERROR: removeOldHistories $e");
      }
    }
  }
}
