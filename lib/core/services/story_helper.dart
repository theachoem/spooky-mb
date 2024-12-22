import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/services/quill_service.dart';

class StoryHelper {
  static T? getElementAtIndex<T>(Iterable<T> list, int index) {
    if (index >= 0 && list.length > index) return list.toList()[index];
    return null;
  }

  static Future<StoryContentDbModel> buildContent(
    StoryContentDbModel draftContent,
    Map<int, QuillController> quillControllers,
  ) async {
    final pages = pagesData(draftContent, quillControllers).values.toList();
    return await compute(_buildContent, {
      'draft_content': draftContent,
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
    StoryContentDbModel draftContent,
    Map<int, QuillController> quillControllers,
  ) {
    Map<int, List<dynamic>> documents = {};
    if (draftContent.pages != null) {
      for (int pageIndex = 0; pageIndex < draftContent.pages!.length; pageIndex++) {
        List<dynamic>? quillDocument =
            quillControllers.containsKey(pageIndex) ? quillControllers[pageIndex]!.document.toDelta().toJson() : null;
        documents[pageIndex] = quillDocument ?? draftContent.pages![pageIndex];
      }
    }
    return documents;
  }

  static StoryContentDbModel _buildContent(Map<String, dynamic> params) {
    StoryContentDbModel draftContent = params['draft_content'];
    List<List<dynamic>> updatedPages = params['updated_pages'];

    final metadata = [
      draftContent.title,
      ...updatedPages.map((e) => Document.fromJson(e).toPlainText()),
    ].join("\n");

    return draftContent.copyWith(
      plainText: QuillService.toPlainText(Document.fromJson(updatedPages.first).root),
      pages: updatedPages,
      metadata: metadata,
    );
  }

  static Future<Map<int, QuillController>> buildQuillControllers(
    StoryContentDbModel content, {
    required bool readOnly,
  }) async {
    final Map<int, QuillController> quillControllers = {};
    List<Document> documents = await StoryHelper.buildDocuments(content.pages);
    for (int i = 0; i < documents.length; i++) {
      quillControllers[i] = QuillController(
        document: documents[i],
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: readOnly,
      );
    }

    return quillControllers;
  }

  static Future<Document> buildDocument(List<dynamic>? document) async {
    return compute(_buildDocument, document);
  }

  static Future<List<Document>> buildDocuments(List<List<dynamic>>? pages) {
    return compute(_buildDocuments, pages);
  }

  static Document _buildDocument(List<dynamic>? document) {
    if (document != null && document.isNotEmpty) return Document.fromJson(document);
    return Document();
  }

  static List<Document> _buildDocuments(List<List<dynamic>>? pages) {
    if (pages == null || pages.isEmpty == true) return [];
    return pages.map((page) => _buildDocument(page)).toList();
  }
}
