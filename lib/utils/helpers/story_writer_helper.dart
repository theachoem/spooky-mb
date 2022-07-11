import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';

// ignore: implementation_imports
import 'package:flutter_quill/src/models/documents/nodes/node.dart' as doc;

class StoryWriteHelper {
  static Future<StoryContentDbModel> buildContent(
    StoryContentDbModel currentContent,
    Map<int, QuillController> quillControllers,
    String title,
    DateTime openOn, {
    bool draft = false,
  }) async {
    final pages = pagesData(currentContent, quillControllers).values.toList();
    final metadata = [
      title,
      quillControllers.entries.map((e) => e.value.getPlainText()).join("\n"),
    ].join("\n");

    final root = AppHelper.listItem(quillControllers.values, 0)?.document.root;
    return await compute(_buildContent, {
      'title': title,
      'open_on': openOn,
      'current_content': currentContent,
      'pages': pages,
      'root': root,
      'draft': draft,
      'metadata': metadata,
    });
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
  String title = params['title'];
  DateTime openOn = params['open_on'];
  StoryContentDbModel currentContent = params['current_content'];
  List<List<dynamic>> pages = params['pages'];
  bool draft = params['draft'];
  String metadata = params['metadata'];
  doc.Root root = params['root'] ?? Document.fromJson(pages.first).root;

  return currentContent.copyWith(
    id: openOn.millisecondsSinceEpoch,
    title: title,
    plainText: QuillHelper.toPlainText(root),
    pages: pages,
    createdAt: DateTime.now(),
    draft: draft,
    metadata: metadata,
  );
}
