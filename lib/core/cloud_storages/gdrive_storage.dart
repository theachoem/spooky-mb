import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:spooky/core/api/authentication/google_auth_client.dart';
import 'package:spooky/core/api/authentication/google_auth_service.dart';
import 'package:spooky/core/cloud_storages/base_cloud_storage.dart';
import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

class GDriveStorage extends BaseCloudStorage {
  Future<drive.DriveApi?> get driveClient async {
    GoogleAuthClient? client = await GoogleAuthService.instance.client;
    if (client != null) return drive.DriveApi(client);
    return null;
  }

  @override
  Future<CloudFileModel?> delete(Map<String, dynamic> options) async {
    String fileId = options['file_id'];
    drive.DriveApi? driveApi = await driveClient;

    if (driveApi != null) {
      await driveApi.files.delete(fileId);
      return CloudFileModel(
        id: fileId,
        fileName: null,
      );
    }
    return null;
  }

  @override
  Future<CloudFileModel?> exist(Map<String, dynamic> options) async {
    String fileName = options['file_name'];
    drive.DriveApi? driveApi = await driveClient;

    if (driveApi != null) {
      drive.FileList? fileList = await driveApi.files.list(
        $fields: "name = '$fileName'",
        spaces: "appDataFolder",
      );

      List<drive.File>? files = fileList.files;
      if (files != null && files.isNotEmpty == true) {
        drive.File last = files.last;
        if (last.id != null) {
          return CloudFileModel(
            fileName: last.originalFilename,
            id: last.id!,
          );
        }
      }
    }

    return null;
  }

  @override
  Future<CloudFileListModel?> list(Map<String, dynamic> options) async {
    drive.DriveApi? driveApi = await driveClient;
    if (driveApi != null) {
      drive.FileList fileList = await driveApi.files.list(
        spaces: "appDataFolder",
      );
      List<drive.File>? files = fileList.files;
      List<CloudFileModel> list = [];
      files?.forEach((e) {
        if (e.id != null) {
          list.add(CloudFileModel(fileName: e.name, id: e.id!));
        }
      });
      return CloudFileListModel(
        files: list,
        nextToken: fileList.nextPageToken,
      );
    }
    return null;
  }

  @override
  Future<bool> synced(Map<String, dynamic> options) async {
    File file = options['file'];
    drive.DriveApi? driveApi = await driveClient;

    if (driveApi != null) {
      String fileName = FileHelper.fileName(file.path);
      CloudFileModel? fileInfo = await exist({'file_name': fileName});

      if (fileInfo != null) {
        Object? media = await driveApi.files.get(
          fileInfo.id,
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
          String cloudContent = utf8.decode(dataStore);
          String localContent = await file.readAsString();

          return cloudContent == localContent;
        }
      }
    }

    return false;
  }

  @override
  Future<CloudFileModel?> write(Map<String, dynamic> options) async {
    File file = options['file'];

    drive.DriveApi? driveApi = await driveClient;
    if (driveApi != null) {
      drive.File fileToUpload = drive.File();
      fileToUpload.name = FileHelper.removeDirectory(file.path);
      fileToUpload.parents = ["appDataFolder"];
      fileToUpload.driveId = FileHelper.fileName(file.path);
      fileToUpload.properties = {
        "synced_at": DateTime.now().millisecondsSinceEpoch.toString(),
      };

      drive.File recieved = await driveApi.files.create(
        fileToUpload,
        useContentAsIndexableText: true,
        uploadMedia: drive.Media(
          file.openRead(),
          file.lengthSync(),
        ),
      );

      if (recieved.id != null) {
        return CloudFileModel(
          fileName: recieved.originalFilename,
          id: recieved.id!,
        );
      }
    }
    return null;
  }
}
