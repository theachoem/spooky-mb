import 'dart:io';

import 'package:spooky/core/api/cloud_storages/gdrive_backups_storage.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/core/backups/models/backups_model.dart';

class GDriveBackupDestination extends BaseBackupDestination {
  final GDriveBackupsStorage cloudStorage = GDriveBackupsStorage();

  @override
  String get cloudId => "google_drive";

  @override
  Future<CloudFileModel?> backup(FileSystemEntity file, BackupsModel backups) async {
    CloudFileModel? cloudFile = await cloudStorage.execHandler(() {
      return cloudStorage.write({
        "file": file,
        "backups": backups,
      });
    });
    return cloudFile;
  }

  @override
  Future<String?> fetchContent(CloudFileModel file) async {
    String? content = await cloudStorage.execHandler(() => cloudStorage.get({"file": file}));
    return content;
  }

  @override
  Future<CloudFileListModel?> fetchAll({
    Map<String, dynamic> params = const {},
  }) async {
    CloudFileListModel? list = await cloudStorage.execHandler(() {
      return cloudStorage.list({"next_token": params['next_token']});
    });

    List<CloudFileModel>? files = list?.files
        //.where((file) {
        //   return file.fileName?.startsWith(BackupsMetaData.prefix) == true;
        // }).toList()
        ;

    return list?.copyWith(files: files);
  }
}
