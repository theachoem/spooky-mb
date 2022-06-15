import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:spooky/core/backups/models/backups_metadata.dart';
import 'package:spooky/core/backups/models/backups_model.dart';
import 'package:spooky/core/file_manager/base/base_file_manager.dart';
import 'package:spooky/core/types/file_path_type.dart';

class BackupsFileManager extends BaseFileManager {
  Directory get parent => Directory("${root.path}/${FilePathType.backups.name}");

  File constructFile(String cloudStorageId) {
    if (!parent.existsSync()) parent.createSync(recursive: true);
    return File("${parent.path}/$cloudStorageId");
  }

  Future<FileSystemEntity?> syncBackups({
    required BackupsModel backups,
    required String cloudStorageId,
  }) async {
    File file = constructFile(cloudStorageId);
    FileSystemEntity? result = await write(file, backups);
    return result;
  }

  Future<void> clear() async {
    for (FileSystemEntity file in parent.listSync()) {
      if (file.existsSync()) file.delete();
    }
  }

  Future<BackupsMetadata?> lastSynced(String cloudStorageId) async {
    try {
      File file = constructFile(cloudStorageId);
      if (await file.exists()) {
        String read = await file.readAsString();
        dynamic map = jsonDecode(read);
        return BackupsMetadata.fromJson(map['meta_data']);
      }
    } catch (e) {
      if (kDebugMode) print("ERROR: metaData $e");
    }
    return null;
  }
}
