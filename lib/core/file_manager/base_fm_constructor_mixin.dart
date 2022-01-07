import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/utils/constants/app_constant.dart';

enum FilePath { user, docs }

mixin BaseFmConstructorMixin<T> {
  // user, docs
  String get parentPath => parentPathEnum.name;
  FilePath get parentPathEnum;

  String constructParentPath(BaseModel model);

  Future<Directory> constructDirectory(BaseModel story) async {
    String parentPath = constructParentPath(story);
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

  Future<File> constructFile(BaseModel model, Directory directory) async {
    String fileName = model.objectId.toString() + "." + AppConstant.documentExstension;
    File file = File(directory.absolute.path + '/' + fileName);
    return file;
  }
}
