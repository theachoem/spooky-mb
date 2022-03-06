import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/story_writers/default_story_writer.dart';
import 'package:spooky/core/story_writers/objects/restore_story_object.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/core/types/response_code_type.dart';

class RestoreStoryWriter extends DefaultStoryWriter<RestoreStoryObject> {
  @override
  String? validate(RestoreStoryObject object) {
    return null;
  }

  @override
  String buildMessage(ResponseCodeType responseCode) {
    switch (responseCode) {
      case ResponseCodeType.success:
        return "Restored";
      case ResponseCodeType.fail:
        return "Restore unsuccessfully!";
      default:
        return buildMessage(responseCode);
    }
  }

  @override
  void onSaved({
    required StoryModel? story,
    required FileSystemEntity? file,
    required ResponseCodeType responseCode,
    required String message,
  }) {
    super.onSaved(
      story: story,
      file: file,
      responseCode: responseCode,
      message: message,
    );

    BuildContext? context = super.context;
    if (context == null || story == null) return;

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Navigator.of(context).popAndPushNamed(
        SpRouter.detail.path,
        arguments: DetailArgs(
          initialStory: story,
          intialFlow: DetailViewFlowType.update,
        ),
      );
    });
  }

  @override
  StoryModel buildStory(RestoreStoryObject object) {
    StoryModel story = object.info.currentStory;
    Iterable<StoryContentModel> selected = object.info.currentStory.changes.where((e) => e.id == object.contentId);
    if (selected.isNotEmpty) {
      StoryContentModel content = selected.last;
      story.removeChangeById(content.id);
      story.addChange(content.restore(content));
      return story;
    } else {
      return story;
    }
  }
}
