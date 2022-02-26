import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';

class StoryWriteHelper {
  static StoryContentModel buildContent(
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
