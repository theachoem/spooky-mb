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
    Future.delayed(ConfigConstant.fadeDuration).then((_) {
      switch (responseCode) {
        case ResponseCodeType.success:
          AutoSaveChannel().show(
            title: message,
            body: "Saved",
            // TODO: have a look at this to make sure nothing
            // payload: AutoSavePayload(story?.file?.path ?? story?.path.toFullPath() ?? ""),
            payload: AutoSavePayload(story?.id.toString()),
          );
          break;
        case ResponseCodeType.noChange:
          break;
        case ResponseCodeType.fail:
          AutoSaveChannel().show(
            title: message,
            body: "Error",
            // payload: AutoSavePayload(story?.file?.path ?? story?.path.toFullPath() ?? ""),
            payload: AutoSavePayload(story?.id.toString()),
          );
          break;
      }
    });
  }
}
