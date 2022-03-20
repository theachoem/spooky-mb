import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:spooky/core/file_manager/managers/sound_file_manager.dart';
import 'package:spooky/core/models/sound_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/loop_audio_seamlessly.dart';
import 'package:spooky/core/services/messenger_service.dart';

class MiniSoundPlayerProvider extends ChangeNotifier with WidgetsBindingObserver {
  final SoundFileManager manager = SoundFileManager();
  late final LoopAudioSeamlessly audioSeamlessly;
  late final ValueNotifier<bool> currentlyPlayingNotifier;
  late final ValueNotifier<double> playerExpandProgressNotifier;
  late final MiniplayerController controller;

  final miniplayerPercentageDeclaration = 0.2;
  final double playerMinHeight = 48 + 16 * 2;
  final double playerMaxHeight = 232;

  SoundModel? get currentSound => audioSeamlessly.currentSound;

  MiniSoundPlayerProvider() {
    currentlyPlayingNotifier = ValueNotifier(false);
    playerExpandProgressNotifier = ValueNotifier(playerMinHeight);
    controller = MiniplayerController();
    audioSeamlessly = LoopAudioSeamlessly();
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
    audioSeamlessly.play(sound);
    currentlyPlayingNotifier.value = true;
    notifyListeners();
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
    audioSeamlessly.stop();
    currentlyPlayingNotifier.value = false;
    // avoid show barier
    playerExpandProgressNotifier.value = playerMinHeight;
    notifyListeners();
  }

  @override
  void dispose() {
    currentlyPlayingNotifier.dispose();
    playerExpandProgressNotifier.dispose();
    controller.dispose();
    audioSeamlessly.dispose();
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  void togglePlayPause() {
    currentlyPlayingNotifier.value ? pause() : resume();
  }

  void pause() {
    if (currentlyPlayingNotifier.value && currentSound != null) {
      audioSeamlessly.pause();
      currentlyPlayingNotifier.value = false;
    }
  }

  void resume() {
    if (!currentlyPlayingNotifier.value && currentSound != null) {
      audioSeamlessly.resume();
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
