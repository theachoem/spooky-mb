import 'dart:io';
import 'package:spooky/core/file_manager/base/base_story_manager.dart';
import 'package:spooky/core/file_manager/managers/backup_file_manager.dart';
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
      return write(
        newFile,
        story.copyWith(path: newPath),
      );
    }

    return null;
  }

  Future<Set<int>?> fetchYears() async {
    Directory docsPath = directory;
    if (await docsPath.exists()) {
      await ensureDirExist(docsPath);

      List<FileSystemEntity> result = docsPath.listSync();
      Set<String> years = result.map((e) {
        return e.absolute.path.split("/").last;
      }).toSet();

      Set<int> yearsInt = {};
      for (String e in years) {
        int? y = int.tryParse(e);
        if (y != null) yearsInt.add(y);
      }

      return yearsInt;
    }
    return null;
  }

  @override
  Future<FileSystemEntity?> write(File file, StoryModel content) async {
    FileSystemEntity? written = await super.write(file, content);
    if (written != null) {
      // call to unsyced
      await BackupFileManager().unsynced(content.path.year);
      return written;
    }
    return null;
  }
}
