import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:spooky/core/api/cloud_storages/gdrive_storage.dart';
import 'package:spooky/core/storages/local_storages/spooky_drive_folder_id_storage.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:spooky/utils/constants/app_constant.dart';

class GDriveSpookyFolderStorage extends GDriveStorage {
  final SpookyDriveFolderStorageIdStorage storage = SpookyDriveFolderStorageIdStorage();

  Future<String?> uploadImage(io.File image) async {
    return execHandler(() {
      return _uploadImage(image);
    });
  }

  Future<String?> _uploadImage(io.File image) async {
    drive.DriveApi? driveApi = await driveClient;
    if (driveApi == null) return null;
    String? folderId = await getFolderId(driveApi);

    if (folderId == null) return null;

    /// config file before upload
    drive.File fileToUpload = drive.File();
    fileToUpload.parents = [folderId.toString()];
    fileToUpload.name = basename(image.path);

    /// try create file
    drive.File response = await driveApi.files.create(
      fileToUpload,
      uploadMedia: drive.Media(image.openRead(), image.lengthSync()),
    );

    if (response.id == null) return null;
    await image.delete();

    /// result
    final link = 'https://drive.google.com/uc?export=download&id=${response.id}';
    return link;
  }

  Future<String?> getFolderId(drive.DriveApi driveApi) async {
    String? driveFolderId = await storage.read();
    if (driveFolderId == null) {
      driveFolderId = await checkIfFolderExists(driveApi, driveFolderId);
      if (driveFolderId == null) {
        /// set folder permission to publish to display on app
        drive.File? response = await createSpookyFolder(driveApi);
        driveFolderId = response?.id;

        if (driveFolderId != null) {
          grentFolderPermission(driveApi, response?.id);
        }
      }
    }
    if (driveFolderId != null) storage.write(driveFolderId);
    return driveFolderId;
  }

  Future<String?> checkIfFolderExists(drive.DriveApi driveApi, String? driveFolderId) async {
    const mimeType = "mimeType = 'application/vnd.google-apps.folder'";
    drive.FileList? folderList = await driveApi.files.list(q: mimeType);

    /// check if folder "Spooky" is existed or not,
    /// if no create new.
    folderList.files?.forEach((e) {
      if (e.name == AppConstant.driveFolderName) driveFolderId = e.id.toString();
    });
    return driveFolderId;
  }

  Future<drive.File?> createSpookyFolder(drive.DriveApi driveApi) async {
    /// set folder permission to publish to display on app
    drive.File folderToCreate = drive.File();
    folderToCreate.name = AppConstant.driveFolderName;
    drive.File? response;
    try {
      response = await driveApi.files.create(
        folderToCreate..mimeType = "application/vnd.google-apps.folder",
      );
    } catch (e) {
      if (kDebugMode) rethrow;
    }
    return response;
  }

  Future<void> grentFolderPermission(drive.DriveApi driveApi, String? driveFolderId) async {
    try {
      await driveApi.permissions.create(
        drive.Permission.fromJson({"role": "reader", "type": "anyone"}),
        driveFolderId!,
      );
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }
}
