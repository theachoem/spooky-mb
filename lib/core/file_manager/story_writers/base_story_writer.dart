import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/file_manager/managers/story_manager.dart';
import 'package:spooky/core/file_manager/story_writers/objects/base_writer_object.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/types/response_code_type.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';

abstract class BaseStoryWriter<T extends BaseWriterObject> {
  BuildContext? get context => App.navigatorKey.currentContext;
  final StoryManager storyManager = StoryManager();

  StoryModel buildStory(T object);
  String buildMessage(ResponseCodeType responseCode);

  /// `story` is story that is re-fetch after saved.
  void onSaved({
    required StoryModel? story,
    required FileSystemEntity? file,
    required ResponseCodeType responseCode,
    required String message,
  });

  /// `writeStory` story we used to write
  Future<StoryModel?> _next(
    StoryModel writeStory,
    FileSystemEntity? result,
  ) async {
    if (result != null && result is File) {
      ResponseCodeType responseCode = ResponseCodeType.success;
      StoryModel? story = await storyManager.fetchOne(result);
      onSaved(
        story: story,
        file: result,
        responseCode: responseCode,
        message: buildMessage(responseCode),
      );
      return story;
    } else {
      ResponseCodeType responseCode = ResponseCodeType.success;
      onSaved(story: null, file: result, responseCode: responseCode, message: buildMessage(responseCode));
      return null;
    }
  }

  Future<StoryModel?> save(T object) async {
    StoryModel story = buildStory(object);
    FileSystemEntity? result = await storyManager.write(story.writableFile, story);
    if (kDebugMode) {
      print("+++ Write +++");
      print("Message: ${storyManager.error}");
      print("Path: ${result?.absolute.path}");
    }
    return _next(story, result);
  }

  StoryContentModel buildContent(
    StoryContentModel currentContent,
    Map<int, QuillController> quillControllers,
    TextEditingController titleController,
    DateTime openOn,
  ) {
    final pages = pagesData(currentContent, quillControllers).values.toList();
    final root = AppHelper.listItem(quillControllers.values, 0)?.document.root ?? Document.fromJson(pages.first).root;
    return currentContent.copyWith(
      id: openOn.millisecondsSinceEpoch.toString(),
      title: titleController.text,
      plainText: QuillHelper.toPlainText(root),
      pages: pages,
      createdAt: DateTime.now(),
    );
  }

  Map<int, List<dynamic>> pagesData(
    StoryContentModel currentContent,
    Map<int, QuillController> quillControllers,
  ) {
    Map<int, List<dynamic>> documents = {};
    if (currentContent.pages != null) {
      for (int pageIndex = 0; pageIndex < currentContent.pages!.length; pageIndex++) {
        List<dynamic>? quillDocument =
            quillControllers.containsKey(pageIndex) ? quillControllers[pageIndex]!.document.toDelta().toJson() : null;
        documents[pageIndex] = quillDocument ?? currentContent.pages![pageIndex];
      }
    }
    return documents;
  }
}
