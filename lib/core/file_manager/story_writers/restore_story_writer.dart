import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spooky/core/file_manager/story_writers/default_story_writer.dart';
import 'package:spooky/core/file_manager/story_writers/objects/restore_story_object.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/core/types/response_code_type.dart';

class RestoreStoryWriter extends DefaultStoryWriter<RestoreStoryObject> {
  @override
  String buildMessage(ResponseCodeType responseCode) {
    switch (responseCode) {
      case ResponseCodeType.success:
        return "Restored";
      case ResponseCodeType.noChange:
        return "Document has no changes";
      case ResponseCodeType.fail:
        return "Restore unsuccessfully!";
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
        SpRouteConfig.detail,
        arguments: DetailArgs(
          initialStory: story,
          intialFlow: DetailViewFlowType.update,
        ),
      );
    });
  }

  @override
  StoryModel buildStory(RestoreStoryObject object) {
    StoryModel story = super.buildStory(object);
    StoryContentModel content = object.viewModel.currentContent;
    story.removeChangeById(content.id);
    story.addChange(content.restore(content));
    return story;
  }
}
