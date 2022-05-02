import 'dart:io';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/file_manager/base/base_file_manager.dart';
import 'package:spooky/core/types/file_path_type.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

@Deprecated("Use Story Database instead")
class ArchiveFileManager extends BaseFileManager {
  bool canArchive(StoryModel story) {
    return story.path.filePath == FilePathType.docs;
  }

  bool canUnarchive(StoryModel story) {
    return story.path.filePath == FilePathType.archive;
  }

  Future<File?> archiveDocument(StoryModel story) async {
    String destinationFilePath;
    if (story.file != null) {
      String removed = FileHelper.removeDirectory(story.file!.path);
      List<String> paths = removed.split("/");
      paths[0] = FilePathType.archive.name;
      destinationFilePath = FileHelper.addDirectory(paths.join("/"));
    } else {
      destinationFilePath = story.path.copyWith(filePath: FilePathType.archive).toFullPath();
    }
    return move(story.writableFile, destinationFilePath);
  }

  Future<File?> unarchiveDocument(StoryDbModel story) async {
    return null;

    // File fileToMove = story.writableFile;
    // String destinationFilePath = story.path.copyWith(filePath: FilePathType.docs).toFullPath();
    // return move(fileToMove, destinationFilePath);
  }

  Future<FileSystemEntity?> deleteDocument(StoryDbModel story) async {
    return null;

    // return delete(story.writableFile);
  }
}
