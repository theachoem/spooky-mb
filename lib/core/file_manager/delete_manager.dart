import 'dart:io';

import 'package:spooky/core/file_manager/base_file_manager.dart';
import 'package:spooky/core/file_manager/base_fm_constructor_mixin.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/story_model.dart';

class DeleteManager extends BaseFileManager {
  bool canDelete(StoryModel model) {
    return model.filePath == FilePath.archive;
  }

  Future<void> delete(StoryModel model) async {
    if (canDelete(model) && model.parentPath != null) {
      beforeExec(() async {
        Directory directory = Directory(model.parentPath!);
        if (await directory.exists()) {
          await directory.delete(recursive: true);
        }
      });
    }
  }

  @override
  String constructParentPath(BaseModel model, [FilePath? customParentPath]) => "";

  @override
  FilePath get parentPathEnum => throw UnimplementedError();
}
