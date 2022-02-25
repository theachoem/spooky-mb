import 'dart:io';

import 'package:flutter/foundation.dart';

mixin FileManagerMixin {
  Object? error;

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
}
