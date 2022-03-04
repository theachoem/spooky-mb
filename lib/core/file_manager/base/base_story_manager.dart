import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/file_manager/base/base_file_manager.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';

abstract class BaseStoryManager<T extends BaseModel> extends BaseFileManager<T> {
  T objectTransformer(Map<String, dynamic> json, File file, [StoryQueryOptionsModel? options]);

  Future<T?> fetchOne(File file) async {
    bool isJson = file.path.endsWith(".json");
    if (!isJson) return null;
    return beforeExec<T?>(() async {
      String result = await file.readAsString();
      dynamic json = jsonDecode(result);
      if (json is Map<String, dynamic>) {
        return objectTransformer(json, file);
      }
      return null;
    });
  }

  Future<List<T>?> fetchAll({
    required StoryQueryOptionsModel options,
    String? parent,
  }) async {
    Directory directory = Directory(options.toPath(parent));
    if (kDebugMode) print("fetchAll directory: ${directory.absolute.path}");

    return beforeExec<List<T>?>(() async {
      if (directory.existsSync()) {
        List<FileSystemEntity> entities = directory.listSync(recursive: true);
        List<T> docs = [];
        for (FileSystemEntity item in entities) {
          if (item is File && item.absolute.path.endsWith(".json")) {
            T? singleDoc = await fetchOne(item);
            if (singleDoc != null) docs.add(singleDoc);
          }
        }
        return docs;
      }
      return null;
    });
  }
}
