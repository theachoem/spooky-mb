import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky_mb/core/base/base_view_model.dart';
import 'package:spooky_mb/views/page_editor/page_editor_view.dart';

Document _buildDocument(List<dynamic>? document) {
  if (document != null && document.isNotEmpty) return Document.fromJson(document);
  return Document();
}

class PageEditorViewModel extends BaseViewModel {
  final PageEditorView params;

  PageEditorViewModel({
    required this.params,
  }) {
    load();
  }

  QuillController? controller;

  Future<void> load() async {
    Document document = await compute(_buildDocument, params.initialDocument);
    controller = QuillController(document: document, selection: const TextSelection.collapsed(offset: 0));
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    Navigator.of(context).pop(
      controller!.document,
    );
  }
}
