import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';

abstract class BaseFileDbAdapter<T extends BaseDbModel> extends BaseDbAdapter<T> {
  BaseFileDbAdapter(String tableName) : super(tableName);

  Future<void> ensureDirExist(Directory directory) async {
    bool exists = await directory.exists();
    if (!exists) {
      await directory.create(recursive: true);
    }
  }

  Future<void> ensureFileExist(File file) async {
    bool exists = await file.exists();
    if (!exists) {
      await file.create(recursive: true);
    }
  }

  Future<File?> move(File sourceFile, String newFilePath) async {
    if (!sourceFile.existsSync()) return null;
    await ensureFileExist(File(newFilePath));
    try {
      File newFile = await sourceFile.rename(newFilePath);
      return newFile;
    } on FileSystemException catch (e) {
      if (kDebugMode) {
        print("RENAME: osError: ${e.osError}");
        print("RENAME: path: ${e.path}");
        print("RENAME: message: ${e.message}");
      }
      File newFile = await sourceFile.copy(newFilePath);
      await sourceFile.delete();
      return newFile;
    }
  }
}
