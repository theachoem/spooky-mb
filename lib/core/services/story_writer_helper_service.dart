import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/services/quill_service.dart';

class StoryWriteHelper {
  static T? getElementAtIndex<T>(Iterable<T> list, int index) {
    if (index >= 0 && list.length > index) return list.toList()[index];
    return null;
  }

  static Future<StoryContentDbModel> buildContent(
    StoryContentDbModel currentContent,
    Map<int, QuillController> quillControllers,
    String? title, {
    required int currentPageIndex,
    bool draft = false,
  }) async {
    final pages = pagesData(currentContent, quillControllers).values.toList();
    final metadata = [
      if (title != null) title,
      quillControllers.values.map((controller) => controller.document.toPlainText()).join("\n"),
    ].join("\n");

    final root = getElementAtIndex(quillControllers.values, 0)?.document.root;
    return await compute(_buildContent, {
      'title': title,
      'current_content': currentContent,
      'pages': pages,
      'root': root,
      'draft': draft,
      'metadata': metadata,
    });
  }

  static String plainText(MapEntry<int, QuillController> e) {
    try {
      return e.value.getPlainText();
    } catch (e) {
      return "";
    }
  }

  static Map<int, List<dynamic>> pagesData(
    StoryContentDbModel currentContent,
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

StoryContentDbModel _buildContent(Map<String, dynamic> params) {
  String? title = params['title'];
  StoryContentDbModel currentContent = params['current_content'];
  List<List<dynamic>> pages = params['pages'];
  bool draft = params['draft'];
  String metadata = params['metadata'];
  Root root = params['root'] ?? Document.fromJson(pages.first);
  DateTime createdAt = DateTime.now();

  return currentContent.copyWith(
    id: createdAt.millisecondsSinceEpoch,
    title: title,
    plainText: QuillService.toPlainText(root),
    pages: pages,
    createdAt: createdAt,
    draft: draft,
    metadata: metadata,
  );
}
