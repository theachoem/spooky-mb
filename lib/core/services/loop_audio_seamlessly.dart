import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:spooky/core/file_manager/managers/sound_file_manager.dart';
import 'package:spooky/core/models/sound_model.dart';

class LoopAudioSeamlessly {
  SoundModel? currentSound;
  File? currentFile;

  final SoundFileManager manager = SoundFileManager();
  late final AudioPlayer player;

  bool get playing => player.playing;

  LoopAudioSeamlessly() {
    player = AudioPlayer();
    player.setLoopMode(LoopMode.one);
  }

  void play(SoundModel sound) async {
    currentSound = sound;
    currentFile = await manager.get(currentSound!);
    if (currentFile != null) {
      await player.setFilePath(currentFile!.path);
      player.play();
    }
  }

  void resume() {
    player.play();
  }

  void pause() {
    player.pause();
  }

  void dispose() {
    player.dispose();
  }

  Future<void> stop() async {
    currentSound = null;
    currentFile = null;
    player.stop();
  }
}
