import 'dart:async';

import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/story_writers/draft_story_writer.dart';
import 'package:spooky/core/notification/channels/auto_save_channel.dart';
import 'package:spooky/core/types/response_code_type.dart';

class AutoSaveStoryWriter extends DraftStoryWriter {
  @override
  void onSaved({
    required StoryDbModel? story,
    required ResponseCodeType responseCode,
    required String message,
  }) {
    DateTime? createdAt = story?.changes.isNotEmpty == true ? story?.changes.last.createdAt : story?.createdAt;
    if (createdAt == null) return;

    switch (responseCode) {
      case ResponseCodeType.success:
        AutoSaveChannel().show(
          id: createdAt.hashCode,
          groupKey: story?.createdAt.hashCode.toString(),
          title: message,
          body: "Saved",
          payload: AutoSavePayload(story?.id.toString()),
        );
        break;
      case ResponseCodeType.noChange:
        break;
      case ResponseCodeType.fail:
        AutoSaveChannel().show(
          id: createdAt.hashCode,
          groupKey: story?.createdAt.hashCode.toString(),
          title: message,
          body: "Error",
          payload: AutoSavePayload(story?.id.toString()),
        );
        break;
    }
  }

  // TO SKIP ALERT
  // DURING PICKING IMAGE
  AutoSaveStoryWriter._();
  static final instance = AutoSaveStoryWriter._();

  bool get skipAlert => _skipNotification;
  bool _skipNotification = false;

  Timer? _timer;
  void _setTimer() {
    _resetTimer();
    _timer = Timer(const Duration(seconds: 60), () {
      _skipNotification = false;
    });
  }

  void _resetTimer() {
    if (_timer?.isActive == true) _timer?.cancel();
  }

  void skipNotification() {
    _skipNotification = true;
    _setTimer();
  }

  void allowNotification() {
    _skipNotification = false;
    _resetTimer();
  }
}
