import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:spooky/core/api/authentication/google_auth_client.dart';
import 'package:spooky/core/api/authentication/google_auth_service.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

class GoogleDriveService {
  Future<drive.DriveApi?> get driveClient async {
    GoogleAuthClient? client = await GoogleAuthService.instance.client;
    if (client != null) return drive.DriveApi(client);
    return null;
  }

  Future<String?> fetchOne(drive.File file) async {
    drive.DriveApi? driveApi = await driveClient;
    Object? media = await driveApi?.files.get(
      file.id!,
      downloadOptions: drive.DownloadOptions.fullMedia,
    );

    if (media is drive.Media) {
      List<int> dataStore = [];

      Completer completer = Completer();
      media.stream.listen(
        (data) => dataStore.insertAll(dataStore.length, data),
        onDone: () => completer.complete(true),
        onError: (error) {},
      );

      await completer.future;
      return utf8.decode(dataStore);
    }

    return null;
  }

  Future<drive.FileList?> fetchAll() async {
    drive.DriveApi? driveApi = await driveClient;
    if (driveApi != null) {
      drive.FileList fileList = await driveApi.files.list(spaces: 'appDataFolder');
      return fileList;
    }
    return null;
  }

  Future<drive.File?> write(File file) async {
    drive.DriveApi? driveApi = await driveClient;
    if (driveApi != null) {
      drive.File fileToUpload = drive.File();
      fileToUpload.name = FileHelper.removeDirectory(file.path);
      fileToUpload.parents = ["appDataFolder"];
      fileToUpload.driveId = FileHelper.fileName(file.path);

      drive.File recieved = await driveApi.files.create(
        fileToUpload,
        uploadMedia: drive.Media(
          file.openRead(),
          file.lengthSync(),
        ),
      );
      return recieved;
    }
    return null;
  }
}
