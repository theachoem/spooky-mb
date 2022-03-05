import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:spooky/core/file_manager/base/file_manager_mixin.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

abstract class BaseFileManager<T extends BaseModel> with FileManagerMixin {
  Directory get root => FileHelper.directory;

  Future<FileSystemEntity?> write(File file, T content) async {
    return beforeExec(() async {
      await ensureFileExist(file);
      String json = AppHelper.prettifyJson(content.toJson());
      file = await file.writeAsString(json);
      return file;
    });
  }

  Future<FileSystemEntity?> delete(File file) async {
    return beforeExec(() async {
      if (file.existsSync()) return file.delete();
      return null;
    });
  }

  Future<File?> move(File sourceFile, String newFilePath) async {
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

  Future<File?> copy(File sourceFile, String destination) async {
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
