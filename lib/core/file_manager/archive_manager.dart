import 'dart:io';
import 'package:spooky/core/file_manager/base_file_manager.dart';
import 'package:spooky/core/file_manager/base_fm_constructor_mixin.dart';
import 'package:spooky/core/file_manager/docs_manager.dart';
import 'package:spooky/core/file_manager/story_query_mixin.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/story_model.dart';

class ArchiveManager extends BaseFileManager with StoryQueryMixin {
  final DocsManager _docsManager = DocsManager();

  bool canAchieve(StoryModel story) {
    return story.filePath == FilePath.docs;
  }

  bool canUnachieve(StoryModel story) {
    return story.filePath == FilePath.archive;
  }

  Future<void> achieveDocument(StoryModel story) async {
    if (!canAchieve(story)) {
      error = message = MessageSummary("Document is unable to achieve");
      return;
    }

    Directory storyDir = await _docsManager.constructDirectory(story);
    Directory achieveRootDir = await constructRootDirectory();

    List<FileSystemEntity> entities = storyDir.listSync();
    for (FileSystemEntity e in entities) {
      if (e is File) {
        String newPath = e.path.replaceAll(_docsManager.rootPath, achieveRootDir.absolute.path);
        File? file = await moveFile(e, newPath);
        if (file == null) break;
        message = MessageSummary('Achieve success!');
      }
    }
  }

  Future<void> unachieveDocument(StoryModel story) async {
    error = null;
    file = null;

    String? storyParentPath = story.parentPath;
    if (!canUnachieve(story) || storyParentPath == null) {
      error = message = MessageSummary("Document is unable to unachieve");
      return;
    }

    Directory achieveRootDir = await constructRootDirectory();
    Directory storyDir = Directory(storyParentPath);
    await ensureDirExist(storyDir);

    List<FileSystemEntity> entities = storyDir.listSync();
    for (FileSystemEntity e in entities) {
      if (e is File) {
        String newPath = e.path.replaceAll(achieveRootDir.absolute.path, _docsManager.rootPath);
        File? file = await moveFile(e, newPath);
        if (file == null) break;
      }
    }

    message = MessageSummary('Achieve success!');
  }

  @override
  String constructParentPath(BaseModel model, [FilePath? customParentPath]) {
    return _docsManager.constructParentPath(model, parentPathEnum);
  }

  @override
  FilePath get parentPathEnum => FilePath.archive;

  Future<List<StoryModel>?> fetchAll() async {
    return beforeExec<List<StoryModel>?>(() async {
      Directory rootDir = await constructRootDirectory();
      List<FileSystemEntity> entities = rootDir.listSync(recursive: true);
      return entitiesToDocuments(entities);
    });
  }
}
