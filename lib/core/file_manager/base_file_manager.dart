import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/file_manager/base_fm_constructor_mixin.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

// store as json
abstract class BaseFileManager with BaseFmConstructorMixin {
  Object? error;
  bool? success;
  File? file;

  MessageSummary? message;

  String get appPath => FileHelper.directory.absolute.path;

  Future<T?> beforeExec<T>(Future<T> Function() callback) async {
    success = false;
    error = null;
    file = null;
    try {
      T result = await callback();
      success = true;
      error = null;
      return result;
    } catch (e) {
      error = e;
      success = false;
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  Future<void> ensureDirExist(Directory directory) async {
    Directory parent = directory.absolute.parent;
    bool exists = await parent.exists();
    if (!exists) {
      await parent.create(recursive: true);
    }
  }

  /// eg. app_path/parent_path_str/object_id.json
  Future<void> write(BaseModel model) async {
    return beforeExec<void>(() async {
      Directory directory = await constructDirectory(model);
      File _file = await constructFile(model, directory);

      file = await _file.writeAsString(
        AppHelper.prettifyJson(model.toJson()),
      );

      success = true;
      message = MessageSummary(
        file != null ? FileHelper.fileName(file!.path) : "Successfully!",
      );
    });
  }

  Future<File?> moveFile(File sourceFile, String newPath) async {
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

      try {
        File newFile = await sourceFile.copy(newPath);
        await sourceFile.delete();
        return newFile;
      } on FileSystemException catch (e) {
        if (kDebugMode) {
          print("COPY: osError: ${e.osError}");
          print("COPY: path: ${e.path}");
          print("COPY: message: ${e.message}");
        }
        error = e;
        message = MessageSummary(e.message);
      }
    }
  }
}

class MessageSummary extends ErrorSummary {
  MessageSummary(String message) : super(message);
}
