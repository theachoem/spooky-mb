import 'package:audioplayers/audioplayers.dart';

class AudioService {
  // Assets.sounds.pageFlip01a
  static Future<AudioPlayer> play(String asset) async {
    AudioCache cache = AudioCache(prefix: '');
    return await cache.play(asset);
  }
}
