import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

enum FilePath {
  user,
  docs,
  archive,
}

mixin BaseFmConstructorMixin<T> {
  // user, docs, archive
  String get parentPath => parentPathEnum.name;
  FilePath get parentPathEnum;

  String get rootPath => FileHelper.directory.absolute.path + "/" + parentPath;
  String constructParentPath(BaseModel model, [FilePath? customParentPath]);

  // string path to directory.
  // if not exist => create it
  Future<Directory> constructDirectory(BaseModel story, [FilePath? customParentPath]) async {
    String parentPath = constructParentPath(story, customParentPath);
    Directory directory = Directory(parentPath);

    if (kDebugMode) {
      print(directory.absolute.path);
    }

    bool exists = await directory.exists();
    if (!exists) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  // $APP_PATH/user or $APP_PATH/docs
  Future<Directory> constructRootDirectory() async {
    Directory directory = Directory(rootPath);

    bool exists = await directory.exists();
    if (!exists) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  Future<File> constructFile(BaseModel model, Directory directory) async {
    String fileName = model.objectId.toString() + "." + AppConstant.documentExstension;
    File file = File(directory.absolute.path + '/' + fileName);
    return file;
  }
}
