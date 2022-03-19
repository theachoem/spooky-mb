import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
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
    notifyListeners();
  }

  Future<void> download(SoundModel sound) async {
    String ref = 'sounds/rains/' + sound.fileName;
    String downloadURL = await FirebaseStorage.instance.ref(ref).getDownloadURL();
  }
}
