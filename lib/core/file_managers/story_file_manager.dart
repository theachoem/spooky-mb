import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/file_managers/base_file_manager.dart';
import 'package:spooky/core/file_managers/types/file_path_type.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

class StoryFileManager extends BaseFileManager {
  File modelToFile(StoryModel model) {
    String path = FileHelper.directory.absolute.path + "/" + model.path.toPath();
    return File(path);
  }

  Future<File?> writeStory(StoryModel content) async {
    File file = modelToFile(content);
    if (kDebugMode) {
      print(file.absolute.path);
    }
    return write(file, content);
  }

  Future<StoryModel?> fetchOne(File file) async {
    return beforeExec<StoryModel?>(() async {
      String result = await file.readAsString();
      dynamic json = jsonDecode(result);
      if (json is Map<String, dynamic>) {
        StoryModel story = StoryModel.fromJson(json);
        return story;
      }
    });
  }

  Future<List<StoryModel>?> fetchAll(StoryQueryOptionsModel options) async {
    Directory directory = Directory(FileHelper.directory.absolute.path + "/" + options.toPath());
    if (kDebugMode) {
      print("fetchAll directory: ${directory.absolute.path}");
    }

    return beforeExec<List<StoryModel>?>(() async {
      if (directory.existsSync()) {
        List<FileSystemEntity> entities = directory.listSync(recursive: true);

        List<StoryModel> stories = [];
        for (FileSystemEntity item in entities) {
          if (item is File && item.absolute.path.endsWith(".json")) {
            StoryModel? story = await fetchOne(item);
            if (story != null) {
              stories.add(story);
            }
          }
        }

        return stories;
      }
    });
  }

  @override
  FilePathType get filePath => FilePathType.docs;
}
