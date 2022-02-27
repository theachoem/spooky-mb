import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spooky/core/file_manager/story_writers/base_story_writer.dart';
import 'package:spooky/core/file_manager/story_writers/objects/update_page_object.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/core/types/response_code_type.dart';

class UpdatePageWriter extends BaseStoryWriter<UpdatePageObject> {
  @override
  ResponseCodeType? validate(UpdatePageObject object) {
    return null;
  }

  @override
  void onSaved({
    required StoryModel? story,
    required FileSystemEntity? file,
    required ResponseCodeType responseCode,
    required String message,
  }) {
    BuildContext? context = super.context;
    if (context == null || story == null) return;

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Navigator.of(context).pushReplacementNamed(
        SpRouteConfig.detail,
        arguments: DetailArgs(
          initialStory: story,
          intialFlow: DetailViewFlowType.update,
        ),
      );
    });
  }

  @override
  StoryModel buildStory(UpdatePageObject object) {
    StoryContentModel content = object.info.currentContent;
    content.pages = object.pages;

    StoryModel story;
    switch (object.info.flowType) {
      case DetailViewFlowType.create:
        story = object.info.currentStory.copyWith(changes: [content]);
        break;
      case DetailViewFlowType.update:
        story = object.info.currentStory..addChange(content);
        break;
    }

    return story;
  }

  @override
  String buildMessage(ResponseCodeType responseCode) {
    return "";
  }
}
