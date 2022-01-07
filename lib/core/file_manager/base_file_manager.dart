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
}

class MessageSummary extends ErrorSummary {
  MessageSummary(String message) : super(message);
}
