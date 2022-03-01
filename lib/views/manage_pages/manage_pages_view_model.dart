import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:flutter_quill/flutter_quill.dart' as editor;

class DocumentKeyModel {
  final int key;
  final editor.Document document;
  DocumentKeyModel({
    required this.key,
    required this.document,
  });
}

class ManagePagesViewModel extends BaseViewModel {
  late final ValueNotifier<bool> hasChangeNotifier;
  final StoryContentModel content;
  List<DocumentKeyModel> documents = [];

  bool get _hasChange {
    return jsonEncode(content.pages) != jsonEncode(documents.map((e) => e.document.toDelta().toJson()).toList());
  }

  ManagePagesViewModel(this.content) {
    _load();
    hasChangeNotifier = ValueNotifier(_hasChange);
  }

  void reload() {
    _load();
    notifyListeners();
  }

  void _load() {
    documents.clear();
    if (content.pages == null) return;
    for (int i = 0; i < content.pages!.length; i++) {
      List<dynamic> page = content.pages![i];
      editor.Document document;
      try {
        document = editor.Document.fromJson(page);
      } catch (e) {
        document = editor.Document();
      }
      documents.add(
        DocumentKeyModel(
          key: i,
          document: document,
        ),
      );
    }
  }

  /// call "updateUnfinishState" after this index is delete on screen
  bool deleteAt(int index) {
    if (documents.length <= 1) return false;
    documents.removeAt(index);
    return true;
  }

  void reordered(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final DocumentKeyModel item = documents.removeAt(oldIndex);
    documents.insert(newIndex, item);
    setHasChange();
  }

  void setHasChange() {
    hasChangeNotifier.value = _hasChange;
  }

  void updateUnfinishState() {
    notifyListeners();
  }

  StoryContentModel save() {
    final newContent = content.copyWith(pages: documents.map((e) => e.document.toDelta().toJson()).toList());
    return newContent;
  }

  @override
  void notifyListeners() {
    setHasChange();
    super.notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      hasChangeNotifier.dispose();
    });
  }
}
