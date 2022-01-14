import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/file_managers/types/file_path_type.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

// store as json
abstract class BaseFileManager {
  Object? error;
  bool get success => error != null;

  FilePathType get filePath;
  String get appPath => FileHelper.directory.absolute.path;

  Future<T?> beforeExec<T>(Future<T?> Function() callback) async {
    error = null;
    try {
      T? result = await callback();
      error = null;
      return result;
    } catch (e) {
      error = e;
      if (kDebugMode) {
        rethrow;
      }
    }
  }

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

  Future<File?> write(File file, BaseModel content) async {
    return beforeExec<File?>(() async {
      await ensureFileExist(file);
      file = await file.writeAsString(
        AppHelper.prettifyJson(content.toJson()),
      );
      return file;
    });
  }

  Future<File?> moveFile(File sourceFile, String newPath) async {
    if (!await sourceFile.exists()) return null;
    return beforeExec<File?>(() async {
      await ensureDirExist(Directory(newPath));
      try {
        File newFile = await sourceFile.rename(newPath);
        await sourceFile.absolute.parent.delete(recursive: true);
        return newFile;
      } on FileSystemException catch (e) {
        if (kDebugMode) {
          print("RENAME: osError: ${e.osError}");
          print("RENAME: path: ${e.path}");
          print("RENAME: message: ${e.message}");
        }
        File newFile = await sourceFile.copy(newPath);
        await sourceFile.delete();
        return newFile;
      }
    });
  }
}
