import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/story_writers/draft_story_writer.dart';
import 'package:spooky/core/notification/channels/auto_save_channel.dart';
import 'package:spooky/core/types/response_code_type.dart';
import 'package:spooky/utils/constants/config_constant.dart';

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
}
