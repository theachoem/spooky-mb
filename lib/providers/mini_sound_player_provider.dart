import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:spooky/core/models/sound_list_model.dart';
import 'package:spooky/core/models/sound_model.dart';
import 'package:spooky/gen/assets.gen.dart';

class MiniSoundPlayerProvider extends ChangeNotifier {
  late final ValueNotifier<SoundModel?> currentlyPlaying;
  late final ValueNotifier<double> playerExpandProgress;
  late final MiniplayerController controller;

  final miniplayerPercentageDeclaration = 0.2;
  final double playerMinHeight = 70;
  final double playerMaxHeight = 370;
  SoundListModel? soundsList;

  MiniSoundPlayerProvider() {
    currentlyPlaying = ValueNotifier(null);
    playerExpandProgress = ValueNotifier(playerMinHeight);
    controller = MiniplayerController();
    load();
  }

  @override
  void dispose() {
    currentlyPlaying.dispose();
    playerExpandProgress.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> load() async {
    String str = await rootBundle.loadString(Assets.backups.rain);
    dynamic json = jsonDecode(str);
    soundsList = SoundListModel.fromJson(json);
    notifyListeners();
  }

  void onTap() {}

  double valueFromPercentageInRange({required final double min, max, percentage}) {
    return percentage * (max - min) + min;
  }

  double percentageFromValueInRange({required final double min, max, value}) {
    return (value - min) / (max - min);
  }
}
