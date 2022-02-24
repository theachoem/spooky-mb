import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/types/file_path_type.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

// store as json
abstract class BaseFileManager {
  Object? error;
  bool get success => error != null;

  FilePathType get filePath;
  String get appPath => FileHelper.directory.absolute.path;
  String get rootPath => FileHelper.directory.absolute.path + "/" + filePath.name;

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
    return null;
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

  Future<FileSystemEntity?> deleteFile(File file) async {
    return beforeExec(() async {
      return await file.delete();
    });
  }

  Future<File?> moveFile(File sourceFile, String newFilePath) async {
    if (!sourceFile.existsSync()) return null;
    return beforeExec<File?>(() async {
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
    });
  }

  Future<File?> copyFile(File sourceFile, String destination) async {
    File file = File(destination);
    if (!sourceFile.existsSync()) return null;
    return beforeExec<File?>(() async {
      await ensureFileExist(file);
      try {
        await file.writeAsString(await sourceFile.readAsString());
        return file;
      } on FileSystemException catch (e) {
        if (kDebugMode) {
          print("RENAME: osError: ${e.osError}");
          print("RENAME: path: ${e.path}");
          print("RENAME: message: ${e.message}");
        }
      }
      return null;
    });
  }
}
