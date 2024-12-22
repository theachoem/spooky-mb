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
  ) async {
    final pages = pagesData(currentContent, quillControllers).values.toList();
    return await compute(_buildContent, {
      'current_content': currentContent,
      'updated_pages': pages,
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

  static StoryContentDbModel _buildContent(Map<String, dynamic> params) {
    StoryContentDbModel currentContent = params['current_content'];
    List<List<dynamic>> updatedPages = params['updated_pages'];

    DateTime createdAt = DateTime.now();

    final metadata = [
      currentContent.title,
      ...updatedPages.map((e) => Document.fromJson(e).toPlainText()),
    ].join("\n");

    return currentContent.copyWith(
      id: createdAt.millisecondsSinceEpoch,
      plainText: QuillService.toPlainText(Document.fromJson(updatedPages.first).root),
      pages: updatedPages,
      createdAt: createdAt,
      metadata: metadata,
    );
  }
}
