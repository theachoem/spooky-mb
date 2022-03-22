import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/file_manager/managers/sound_file_manager.dart';
import 'package:spooky/core/models/sound_list_model.dart';
import 'package:spooky/core/models/sound_model.dart';
import 'package:spooky/core/storages/local_storages/background_sound_storage.dart';
import 'package:spooky/core/types/sound_type.dart';
import 'package:spooky/gen/assets.gen.dart';

Map<SoundType, List<SoundModel>> _loadSoundMaps(String str) {
  Map<SoundType, List<SoundModel>> soundsMap = {};

  SoundListModel? soundsList;
  dynamic json = jsonDecode(str);
  soundsList = SoundListModel.fromJson(json);

  // sort
  List<SoundModel> sounds = soundsList.sounds;
  sounds.sort((a, b) => a.fileSize.compareTo(b.fileSize));
  soundsList = soundsList.copyWith(sounds: sounds);
  for (SoundType type in SoundType.values) {
    soundsMap[type] = soundsList.sounds.where((e) => e.type == type).toList();
  }

  return soundsMap;
}

class SoundListViewModel extends BaseViewModel {
  SoundFileManager fileManager = SoundFileManager();
  Map<SoundType, List<SoundModel>> soundsMap = {};

  bool playSoundInBackground = false;
  void toggleBackgroundSound() {
    BackgroundSoundStorage().write(!playSoundInBackground);
    loadConfig();
  }

  SoundListViewModel() {
    load();
    loadConfig();
  }

  void loadConfig() {
    BackgroundSoundStorage().read().then((value) {
      playSoundInBackground = value == true;
    });
  }

  Future<void> load() async {
    String str = await rootBundle.loadString(Assets.backups.sounds);
    soundsMap = await compute(_loadSoundMaps, str);
    notifyListeners();
  }

  Future<String> download(SoundModel sound) async {
    if (fileManager.downloaded(sound)) return "Downloaded";
    if (sound.fileSize > 10000000) return "File too big";

    String file = fileManager.constructFile(sound.fileName);

    String ref;
    switch (sound.type) {
      case SoundType.music:
        ref = 'sounds/music/' + sound.fileName;
        break;
      case SoundType.sound:
        ref = 'sounds/rains/' + sound.fileName;
        break;
    }

    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance.ref(ref).writeToFile(File(file));
      if (kDebugMode) {
        print(snapshot.ref);
      }
    } catch (e) {
      return e.toString();
    }

    WidgetsBinding.instance?.addPersistentFrameCallback((timeStamp) {
      notifyListeners();
    });

    return "Downloaded";
  }
}
