import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/file_managers/base_file_manager.dart';
import 'package:spooky/core/file_managers/types/file_path_type.dart';
import 'package:spooky/core/models/path_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

class StoryFileManager extends BaseFileManager {
  File modelToFile(StoryModel model) {
    String path = FileHelper.directory.absolute.path + "/" + model.path.toPath();
    return File(path);
  }

  Future<File?> updatePathDate(
    StoryModel story,
    DateTime newDatePath,
  ) async {
    File fileToMove = story.file ?? story.path.toFile();

    PathModel newPath = PathModel.fromDateTime(newDatePath).copyWith(
      filePath: story.path.filePath,
      fileName: story.path.fileName,
    );

    File? newFile = await moveFile(
      fileToMove,
      newPath.toFullPath(),
    );

    if (newFile != null) {
      return write(newFile, story.copyWith(path: newPath));
    }

    return null;
  }

  Future<File?> writeStory(StoryModel content) async {
    File file = content.file ?? modelToFile(content);
    if (kDebugMode) {
      print(file.absolute.path);
    }
    return write(file, content);
  }

  Future<StoryModel?> fetchOne(File file) async {
    if (!file.path.endsWith(".json")) return null;
    return beforeExec<StoryModel?>(() async {
      String result = await file.readAsString();
      // try catch to check if json is validated
      try {
        dynamic json = jsonDecode(result);
        if (json is Map<String, dynamic>) {
          StoryModel story = StoryModel.fromJson(json).copyWith(file: file);
          return story;
        }
      } catch (e) {
        if (kDebugMode) {
          print("ERROR: fetchOne: $e");
        }
      }
      return null;
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
              PathModel path = story.path.copyWith(filePath: options.filePath);
              stories.add(story.copyWith(path: path));
            }
          }
        }

        return stories;
      }
      return null;
    });
  }

  @override
  FilePathType get filePath => FilePathType.docs;
}
