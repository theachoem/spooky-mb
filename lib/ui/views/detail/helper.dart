import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';

class DetailViewModelHelper {
  static StoryModel buildStory(
    StoryModel currentStory,
    StoryContentModel currentContent,
    DetailViewFlow flowType,
    Map<int, QuillController> quillControllers,
    TextEditingController titleController,
  ) {
    StoryModel story;
    currentContent = currentContent.copyWith(
      title: titleController.text,
      plainText: quillControllers.values.first.document.toPlainText(),
      pages: pagesData(currentContent, quillControllers).values.toList(),
    );

    switch (flowType) {
      case DetailViewFlow.create:
        story = currentStory.copyWith(
          changes: [currentContent],
        );
        break;
      case DetailViewFlow.update:
        currentStory.addChange(currentContent);
        story = currentStory;
        break;
    }

    return story;
  }

  static Map<int, List<dynamic>> pagesData(
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
