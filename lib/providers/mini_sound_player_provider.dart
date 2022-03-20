import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:spooky/core/file_manager/managers/sound_file_manager.dart';
import 'package:spooky/core/models/sound_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/messenger_service.dart';

class MiniSoundPlayerProvider extends ChangeNotifier with WidgetsBindingObserver {
  final SoundFileManager manager = SoundFileManager();
  final AudioPlayer player = AudioPlayer(
    mode: PlayerMode.MEDIA_PLAYER,
    playerId: "rain",
  );

  late final ValueNotifier<bool> currentlyPlayingNotifier;
  late final ValueNotifier<double> playerExpandProgressNotifier;
  late final MiniplayerController controller;

  final miniplayerPercentageDeclaration = 0.2;
  final double playerMinHeight = 48 + 16 * 2;
  final double playerMaxHeight = 232;

  SoundModel? _currentSound;
  SoundModel? get currentSound => _currentSound;

  void _setCurrentSound(SoundModel? value) {
    _currentSound = value;
    currentlyPlayingNotifier.value = true;
    notifyListeners();

    // avoid show barrier color
    if (_currentSound == null) {
      playerExpandProgressNotifier.value = playerMinHeight;
    }
  }

  MiniSoundPlayerProvider() {
    currentlyPlayingNotifier = ValueNotifier(false);
    playerExpandProgressNotifier = ValueNotifier(playerMinHeight);
    controller = MiniplayerController();
    load();
    WidgetsBinding.instance?.addObserver(this);
  }

  List<SoundModel>? downloadedSounds;
  Future<void> load() async {
    downloadedSounds = await manager.downloadedSound();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }

  void play(SoundModel sound) async {
    if (manager.downloaded(sound)) {
      File? file = await manager.get(sound);
      if (file != null) {
        _setCurrentSound(sound);
        await player.setReleaseMode(ReleaseMode.LOOP);
        await player.play(file.path, isLocal: true);
      }
    }
  }

  void playPreviousNext({
    required BuildContext context,
    required bool previous,
  }) {
    if (downloadedSounds?.isNotEmpty == true) {
      int index = downloadedSounds!.indexWhere((e) => currentSound?.fileName == e.fileName);
      int validatedIndex = (previous ? index - 1 : index + 1) % downloadedSounds!.length;
      play(downloadedSounds![validatedIndex]);
      if (validatedIndex == 0) {
        showDownloadMoreSound(context);
      }
    }
  }

  void showDownloadMoreSound(BuildContext context) {
    MessengerService.instance.showSnackBar(
      "Download more sounds",
      action: SnackBarAction(
        label: "All sounds",
        onPressed: () {
          Navigator.of(context).pushNamed(SpRouter.soundList.path);
        },
      ),
    );
  }

  void onDismissed() {
    _setCurrentSound(null);
    currentlyPlayingNotifier.value = false;
    player.stop();
  }

  @override
  void dispose() {
    currentlyPlayingNotifier.dispose();
    playerExpandProgressNotifier.dispose();
    controller.dispose();
    player.dispose();
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  void togglePlayPause() {
    currentlyPlayingNotifier.value ? pause() : resume();
  }

  void pause() {
    if (currentlyPlayingNotifier.value && currentSound != null) {
      player.pause();
      currentlyPlayingNotifier.value = false;
    }
  }

  void resume() {
    if (!currentlyPlayingNotifier.value && currentSound != null) {
      player.resume();
      currentlyPlayingNotifier.value = true;
    }
  }

  double offset(double percentage) {
    double offset = (percentage - playerMinHeight) / (playerMaxHeight - playerMinHeight);
    return offset;
  }

  double valueFromPercentageInRange({required final double min, max, percentage}) {
    return percentage * (max - min) + min;
  }

  double percentageFromValueInRange({required final double min, max, value}) {
    return (value - min) / (max - min);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        resume();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        pause();
        break;
    }
  }
}
