import 'package:flutter_quill/flutter_quill.dart' as editor;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

editor.Document _buildDocument(List<dynamic>? document) {
  if (document != null && document.isNotEmpty) return editor.Document.fromJson(document);
  return editor.Document();
}

class EditorWrapper extends StatelessWidget {
  const EditorWrapper({
    Key? key,
    this.document,
    required this.builder,
  }) : super(key: key);

  final List<dynamic>? document;
  final Widget Function(editor.Document) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<editor.Document?>(
      future: compute(_buildDocument, document),
      builder: (context, snapshot) {
        editor.Document? data = snapshot.data;
        return Visibility(
          visible: data != null,
          child: data != null ? builder(data) : const SizedBox.shrink(),
        );
      },
    );
  }
}
