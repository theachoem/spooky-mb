import 'dart:io';
import 'package:spooky/core/file_manager/managers/archive_file_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:flutter/material.dart';

class ArchiveViewModel extends ChangeNotifier {
  final ArchiveFileManager fileManager = ArchiveFileManager();

  Future<bool> unarchiveDocument(StoryModel story) async {
    File? file = await fileManager.unarchiveDocument(story);
    bool success = file != null;
    return success;
  }

  Future<bool> delete(StoryModel story) async {
    FileSystemEntity? file = await fileManager.deleteDocument(story);
    bool success = file != null;
    return success;
  }
}
