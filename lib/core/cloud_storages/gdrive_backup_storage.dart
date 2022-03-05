import 'dart:async';
import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:spooky/core/cloud_storages/gdrive_storage.dart';
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
        return CloudFileModel(
          fileName: recieved.name,
          id: recieved.id!,
          description: recieved.description,
        );
      }
    }

    return null;
  }
}
