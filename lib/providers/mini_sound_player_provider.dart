import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:spooky/core/file_manager/managers/sound_file_manager.dart';
import 'package:spooky/core/models/sound_model.dart';
import 'package:spooky/core/notification/channels/play_sound_channel.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/loop_audio_seamlessly.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/storages/local_storages/background_sound_storage.dart';
import 'package:spooky/core/types/sound_type.dart';
import 'package:spooky/utils/extensions/string_extension.dart';

class MiniSoundPlayerProvider extends ChangeNotifier with WidgetsBindingObserver {
  final SoundFileManager manager = SoundFileManager();
  late final Map<SoundType, LoopAudioSeamlessly> audioPlayers;
  late final ValueNotifier<double> playerExpandProgressNotifier;
  late final MiniplayerController controller;

  final miniplayerPercentageDeclaration = 0.2;
  final double playerMinHeight = 48 + 16 * 2;
  final double playerMaxHeight = 232;

  bool _currentlyPlaying = false;
  bool get currentlyPlaying => _currentlyPlaying;

  List<SoundModel> get currentSounds {
    List<SoundModel> sounds = [];
    for (SoundType type in SoundType.values) {
      SoundModel? sound = currentSound(type);
      if (sound != null) {
        sounds.add(sound);
      }
    }
    return sounds;
  }

  String? get imageUrl {
    for (SoundType type in SoundType.values) {
      String? imageUrl = currentSound(type)?.imageUrl.url;
      if (imageUrl != null && imageUrl.trim().isNotEmpty) return imageUrl;
    }
    return null;
  }

  SoundModel? currentSound(SoundType type) => audioPlayers[type]?.currentSound;
  // SoundType get baseSoundType => SoundType.sound;

  MiniSoundPlayerProvider() {
    playerExpandProgressNotifier = ValueNotifier(playerMinHeight);
    controller = MiniplayerController();
    load();
    initPlayers();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    playerExpandProgressNotifier.dispose();
    controller.dispose();
    audioPlayers.forEach((key, value) => value.dispose());
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  void initPlayers() {
    audioPlayers = {};
    for (SoundType type in SoundType.values) {
      audioPlayers[type] = LoopAudioSeamlessly((listener) {
        if (hasPlaying != _currentlyPlaying) {
          _currentlyPlaying = hasPlaying;
          notifyListeners();
        }
      });
    }
  }

  List<SoundModel>? downloadedSounds;
  Future<void> load() async {
    downloadedSounds = await manager.downloadedSound();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }

  void play(SoundModel sound) async {
    audioPlayers[sound.type]?.play(sound);
  }

  void playPreviousNext({
    required BuildContext context,
    required bool previous,
  }) {
    for (SoundType type in SoundType.values) {
      if (currentSound(type) != null) {
        _playPreviousNext(
          type: type,
          context: context,
          previous: previous,
        );
      }
    }
  }

  void _playPreviousNext({
    required SoundType type,
    required BuildContext context,
    required bool previous,
  }) {
    List<SoundModel>? sounds = downloadedSounds?.where((e) => e.type == type).toList();
    if (sounds?.isNotEmpty == true) {
      int index = sounds!.indexWhere((e) => currentSound(type)?.fileName == e.fileName);
      int validatedIndex = (previous ? index - 1 : index + 1) % sounds.length;
      play(sounds[validatedIndex]);
      notifyListeners();
    }
  }

  void onDismissed() {
    // avoid show barier
    playerExpandProgressNotifier.value = playerMinHeight;
    for (SoundType e in SoundType.values) {
      stop(e);
    }
  }

  void togglePlayPause() {
    if (_currentlyPlaying) {
      for (SoundType type in SoundType.values) {
        pause(type);
      }
    } else {
      for (SoundType type in SoundType.values) {
        resume(type);
      }
    }
  }

  void stop(SoundType type) {
    if (currentSound(type) != null) {
      audioPlayers[type]?.stop();
    }
  }

  void pause(SoundType type) {
    if (currentSound(type) != null) {
      audioPlayers[type]?.pause();
    }
  }

  void resume(SoundType type) {
    if (currentSound(type) != null) {
      audioPlayers[type]?.resume();
    }
  }

  bool get hasPlaying {
    return SoundType.values.map((type) {
      return audioPlayers[type]?.playing == true;
    }).where((playing) {
      return playing;
    }).isNotEmpty;
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

  WeatherType get weatherType {
    WeatherType? type;
    for (SoundType soundType in SoundType.values) {
      SoundModel? _type = currentSound(soundType);
      if (_type != null) {
        type = _type.weatherType;
        break;
      }
    }
    return type ?? WeatherType.heavyRainy;
  }

  String get soundTitle {
    List<String> names = [];

    for (SoundType type in SoundType.values) {
      SoundModel? _name = currentSound(type);
      if (_name != null) {
        names.add(_name.soundName.capitalize);
      }
    }

    return names.isNotEmpty ? names.join(", ") : "Unknown";
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        for (SoundType type in SoundType.values) {
          resume(type);
        }
        break;
      case AppLifecycleState.paused:
        BackgroundSoundStorage().read().then((on) {
          if (on == true) {
            if (hasPlaying) {
              PlaySoundChannel().show(
                title: soundTitle,
                body: null,
                bigPicture: imageUrl,
                payload: null,
                notificationLayout: NotificationLayout.BigPicture,
              );
            }
          } else {
            for (SoundType type in SoundType.values) {
              pause(type);
            }
          }
        });
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }
}
