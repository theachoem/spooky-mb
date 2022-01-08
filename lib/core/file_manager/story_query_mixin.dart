import 'dart:convert';
import 'dart:io';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

mixin StoryQueryMixin {
  Future<List<StoryModel>> entitiesToDocuments(List<FileSystemEntity> entities) async {
    // {
    //    parentPath: fileName,
    //    parentPath: fileName,
    // }
    Map<String, String> storiesPath = {};

    for (FileSystemEntity e in entities) {
      if (e.absolute.path.endsWith(".json") && e is File) {
        String fileName = FileHelper.fileName(e.absolute.path);
        String key = e.parent.absolute.path;

        // override if fileName is newer than storiesPath[key]
        if (storiesPath.containsKey(key)) {
          if (storiesPath[key]?.compareTo(fileName) == -1) {
            storiesPath[key] = fileName;
          }
        } else {
          storiesPath[key] = fileName;
        }
      }
    }

    List<StoryModel> stories = [];

    for (MapEntry<String, String> e in storiesPath.entries) {
      File file = File(e.key + "/" + e.value);
      StoryModel? story = await fetchOne(file);
      if (story != null) {
        stories.add(story);
      }
    }

    return stories;
  }

  Future<StoryModel?> fetchOneByFileParent(String parent) async {
    Directory parentDir = Directory(parent);
    if (await parentDir.exists()) {
      List<FileSystemEntity> entities = parentDir.listSync();
      List<StoryModel> result = await entitiesToDocuments(entities);
      if (result.isNotEmpty) {
        return result.first;
      }
    }
  }

  Future<StoryModel?> fetchOne(File file) async {
    String result = await file.readAsString();
    dynamic json = jsonDecode(result);
    if (json is Map<String, dynamic>) {
      StoryModel story = StoryModel.fromJson(json).copyWith(parentPath: file.absolute.parent.path);
      return story;
    }
  }
}
