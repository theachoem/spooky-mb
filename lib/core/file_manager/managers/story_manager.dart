import 'dart:io';
import 'package:spooky/core/file_manager/base/base_story_manager.dart';
import 'package:spooky/core/models/path_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/types/file_path_type.dart';

class StoryManager extends BaseStoryManager<StoryModel> {
  Directory get directory => Directory(root.path + "/" + FilePathType.docs.name);

  @override
  StoryModel objectTransformer(Map<String, dynamic> json, File file, [StoryQueryOptionsModel? options]) {
    StoryModel story = StoryModel.fromJson(json);
    PathModel path = story.path.copyWith(filePath: options?.filePath);
    return story.copyWith(file: file, path: path);
  }

  Future<FileSystemEntity?> updatePathDate(
    StoryModel story,
    DateTime newDatePath,
  ) async {
    PathModel newPath = PathModel.fromDateTime(newDatePath).copyWith(
      filePath: story.path.filePath,
      fileName: story.path.fileName,
    );

    File? newFile = await move(
      story.writableFile,
      newPath.toFullPath(),
    );

    if (newFile != null) {
      return write(newFile, story.copyWith(path: newPath));
    }

    return null;
  }
}
