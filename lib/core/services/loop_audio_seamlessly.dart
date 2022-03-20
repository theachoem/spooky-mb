import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:spooky/core/file_manager/managers/sound_file_manager.dart';
import 'package:spooky/core/models/sound_model.dart';

class LoopAudioSeamlessly {
  int? currentSoundDuration;
  SoundModel? currentSound;
  File? currentFile;

  final SoundFileManager manager = SoundFileManager();

  late final AudioPlayer player1;
  late final AudioPlayer player2;

  LoopAudioSeamlessly() {
    player1 = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER, playerId: "player1");
    player2 = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER, playerId: "player2");
    player1.onAudioPositionChanged.listen((event) => listen(event, player1.playerId));
    player2.onAudioPositionChanged.listen((event) => listen(event, player2.playerId));
  }

  void listen(Duration event, String playerId) async {
    if (currentSoundDuration != null && currentSound != null) {
      int currentDuration = event.inMilliseconds;
      int maxDuration = currentSoundDuration!;
      int substractSomePercents = maxDuration * (100 - 1) ~/ 100;
      if (currentDuration >= substractSomePercents && currentFile != null) {
        switch (playerId) {
          case "player1":
            switch (player2.state) {
              case PlayerState.COMPLETED:
              case PlayerState.STOPPED:
                player2.play(currentFile!.path, isLocal: true);
                break;
              default:
                break;
            }
            break;
          case "player2":
            switch (player1.state) {
              case PlayerState.COMPLETED:
              case PlayerState.STOPPED:
                player1.play(currentFile!.path, isLocal: true);
                break;
              default:
                break;
            }
            break;
        }
      }
    }
  }

  void play(SoundModel sound) async {
    currentSound = sound;
    currentFile = await manager.get(currentSound!);
    if (currentFile != null) {
      await player1.play(currentFile!.path, isLocal: true);
      currentSoundDuration = await player1.getDuration();
    }
  }

  void resume() {
    _resume(player1);
    _resume(player2);
  }

  void _resume(AudioPlayer player) {
    switch (player.state) {
      case PlayerState.PAUSED:
        player.resume();
        break;
      case PlayerState.PLAYING:
      case PlayerState.STOPPED:
      case PlayerState.COMPLETED:
        break;
    }
  }

  void pause() {
    _pause(player1);
    _pause(player2);
  }

  void _pause(AudioPlayer player) {
    switch (player.state) {
      case PlayerState.PLAYING:
        player.pause();
        break;
      case PlayerState.STOPPED:
      case PlayerState.PAUSED:
      case PlayerState.COMPLETED:
        break;
    }
  }

  void dispose() {
    player1.dispose();
    player2.dispose();
  }

  Future<void> stop() async {
    currentSound = null;
    currentFile = null;
    currentSoundDuration = null;
    await Future.wait([
      player1.stop(),
      player2.stop(),
    ]);
  }
}
