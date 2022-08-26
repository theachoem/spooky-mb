import 'dart:async';
import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:spooky/core/external_apis/cloud_storages/gdrive_storage.dart';
import 'package:spooky/core/backups/models/backups_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';

class GDriveBackupsStorage extends GDriveStorage {
  @override
  Future<CloudFileModel?> write(Map<String, dynamic> options) async {
    File file = options['file'];
    BackupsModel backups = options['backups'];

    drive.DriveApi? driveApi = await driveClient;
    if (driveApi != null) {
      drive.File fileToUpload = drive.File();
      fileToUpload.name = backups.metaData.fileNameWithExt;
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
