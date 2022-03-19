import 'dart:io';

import 'package:spooky/core/file_manager/base/base_file_manager.dart';
import 'package:spooky/core/models/sound_model.dart';
import 'package:spooky/core/types/file_path_type.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

class SoundFileManager extends BaseFileManager {
  Directory get directory => Directory(root.path + "/" + FilePathType.sounds.name);
  Future<File?> save(File waveFile) async {
    String fileName = FileHelper.fileName(waveFile.path);
    return move(waveFile, constructFile(fileName));
  }

  String constructFile(String fileName) => directory.path + "/" + fileName;
  Future<File?> get(SoundModel sound) async {
    List<FileSystemEntity> list = directory.listSync();
    Iterable<FileSystemEntity> result = list.where((e) => e.path.endsWith(sound.fileName));
    if (result.isNotEmpty) {
      return result.first as File;
    }
    return null;
  }

  bool downloaded(SoundModel sound) {
    return File(constructFile(sound.fileName)).existsSync();
  }
}
