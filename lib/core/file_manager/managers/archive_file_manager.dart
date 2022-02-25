import 'dart:io';
import 'package:spooky/core/file_manager/base/base_file_manager.dart';
import 'package:spooky/core/types/file_path_type.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

class ArchiveFileManager extends BaseFileManager {
  bool canArchive(StoryModel story) {
    return story.path.filePath == FilePathType.docs;
  }

  bool canUnarchive(StoryModel story) {
    return story.path.filePath == FilePathType.archive;
  }

  Future<File?> archiveDocument(StoryModel story) async {
    File fileToMove = story.file ?? story.path.toFile();

    String destinationFilePath;
    if (story.file != null) {
      String removed = FileHelper.removeDirectory(story.file!.path);
      List<String> paths = removed.split("/");
      paths[0] = FilePathType.archive.name;
      destinationFilePath = FileHelper.addDirectory(paths.join("/"));
    } else {
      destinationFilePath = story.path.copyWith(filePath: FilePathType.archive).toFullPath();
    }

    return move(fileToMove, destinationFilePath);
  }

  Future<File?> unarchiveDocument(StoryModel story) async {
    File fileToMove = story.path.toFile();
    String destinationFilePath = story.path.copyWith(filePath: FilePathType.docs).toFullPath();
    return move(fileToMove, destinationFilePath);
  }

  Future<FileSystemEntity?> deleteDocument(StoryModel story) async {
    File fileToDelete = story.file ?? story.path.toFile();
    return delete(fileToDelete);
  }
}
