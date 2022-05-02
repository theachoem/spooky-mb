import 'dart:io';

import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';

abstract class BaseFileDbAdapter extends BaseDbAdapter {
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
}
