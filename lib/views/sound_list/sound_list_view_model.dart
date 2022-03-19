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
import 'package:spooky/gen/assets.gen.dart';

class SoundListViewModel extends BaseViewModel {
  SoundListModel? soundsList;
  SoundFileManager fileManager = SoundFileManager();

  SoundListViewModel() {
    load();
  }

  Future<void> load() async {
    String str = await rootBundle.loadString(Assets.backups.rain);
    dynamic json = jsonDecode(str);
    soundsList = SoundListModel.fromJson(json);

    // sort
    List<SoundModel> sounds = soundsList!.sounds;
    sounds.sort((a, b) => a.fileSize.compareTo(b.fileSize));
    soundsList = soundsList!.copyWith(sounds: sounds);

    notifyListeners();
  }

  Future<String> download(SoundModel sound) async {
    if (fileManager.downloaded(sound)) return "Downloaded";
    if (sound.fileSize > 10000000) return "File too big";

    String ref = 'sounds/rains/' + sound.fileName;
    String file = fileManager.constructFile(sound.fileName);
    TaskSnapshot snapshot = await FirebaseStorage.instance.ref(ref).writeToFile(File(file));

    if (kDebugMode) {
      print(snapshot.ref);
    }

    WidgetsBinding.instance?.addPersistentFrameCallback((timeStamp) {
      notifyListeners();
    });

    return "Downloaded";
  }
}
