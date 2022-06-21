import 'package:flutter/material.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/story_writers/default_story_writer.dart';
import 'package:spooky/core/story_writers/objects/update_page_object.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/core/types/response_code_type.dart';

class UpdatePageWriter extends DefaultStoryWriter<UpdatePageObject> {
  @override
  String? validate(UpdatePageObject object) {
    return null;
  }

  @override
  void onSaved({
    required StoryDbModel? story,
    required ResponseCodeType responseCode,
    required String message,
  }) {
    BuildContext? context = super.context;
    if (context == null || story == null) return;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.of(context).pushReplacementNamed(
        SpRouter.detail.path,
        arguments: DetailArgs(
          initialStory: story,
          intialFlow: DetailViewFlowType.update,
        ),
      );
    });
  }

  @override
  Future<StoryDbModel> buildStory(UpdatePageObject object) async {
    StoryDbModel story = await super.buildStory(object);
    StoryContentDbModel newContent = story.changes.last;

    // update pages
    newContent.pages = object.pages;
    story.removeChangeById(newContent.id);
    story.addChange(newContent);

    return story;
  }

  @override
  String buildMessage(ResponseCodeType responseCode) {
    return "";
  }
}
