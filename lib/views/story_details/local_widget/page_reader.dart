import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

Document _buildDocument(List<dynamic>? document) {
  if (document != null && document.isNotEmpty) return Document.fromJson(document);
  return Document();
}

class PageReader extends StatefulWidget {
  const PageReader({
    super.key,
    required this.pageDocuments,
    required this.onSelectionChanged,
  });

  final List<dynamic> pageDocuments;
  final void Function(TextSelection selection) onSelectionChanged;

  @override
  State<PageReader> createState() => _PageReaderState();
}

class _PageReaderState extends State<PageReader> {
  QuillController? controller;

  @override
  void didUpdateWidget(covariant PageReader oldWidget) {
    super.didUpdateWidget(oldWidget);

    load();
  }

  @override
  void initState() {
    super.initState();

    load();
  }

  Future<void> load() async {
    Document document = await compute(_buildDocument, widget.pageDocuments);

    controller = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
      onSelectionChanged: (textSelection) => widget.onSelectionChanged(textSelection),
    );

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    return QuillEditor.basic(
      controller: controller,
      configurations: const QuillEditorConfigurations(
        padding: EdgeInsets.all(16.0),
        checkBoxReadOnly: true,
        autoFocus: false,
        expands: true,
      ),
    );
  }
}
