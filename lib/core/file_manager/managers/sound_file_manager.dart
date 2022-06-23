import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:spooky/core/file_manager/base/base_file_manager.dart';
import 'package:spooky/core/models/sound_list_model.dart';
import 'package:spooky/core/models/sound_model.dart';
import 'package:spooky/core/types/file_path_type.dart';
import 'package:spooky/gen/assets.gen.dart';
import 'package:spooky/utils/helpers/file_helper.dart';

class SoundFileManager extends BaseFileManager {
  Directory get directory => Directory("${root.path}/${FilePathType.sounds.name}");
  Future<File?> save(File waveFile) async {
    String fileName = FileHelper.fileName(waveFile.path);
    return move(waveFile, constructFile(fileName));
  }

  String constructFile(String fileName) => "${directory.path}/$fileName";

  Future<SoundListModel> fetchJsonSounds() async {
    String str = await rootBundle.loadString(Assets.sounds.sounds);
    dynamic json = jsonDecode(str);
    SoundListModel soundsList = SoundListModel.fromJson(json);

    // sort
    List<SoundModel> sounds = soundsList.sounds;
    sounds.sort((a, b) => a.fileSize.compareTo(b.fileSize));
    soundsList = soundsList.copyWith(sounds: sounds);

    return soundsList;
  }

  Future<List<SoundModel>> downloadedSound() async {
    await ensureDirExist(directory);
    Iterable<FileSystemEntity> list = directory.listSync().whereType<File>();
    List<String> files = list.map((e) => FileHelper.fileName(e.path)).toList();

    SoundListModel result = await fetchJsonSounds();
    List<SoundModel> downloaded = result.sounds..removeWhere((e) => !files.contains(e.fileName));

    return downloaded;
  }

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
