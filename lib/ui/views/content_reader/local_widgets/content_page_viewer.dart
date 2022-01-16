import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as editor;
import 'package:spooky/utils/constants/config_constant.dart';

class ContentPageViewer extends StatefulWidget {
  const ContentPageViewer({
    Key? key,
    required this.document,
  }) : super(key: key);

  final List<dynamic>? document;

  @override
  State<ContentPageViewer> createState() => ContentPageViewerState();
}

class ContentPageViewerState extends State<ContentPageViewer> {
  late editor.QuillController controller;
  late ScrollController scrollController;

  @override
  void initState() {
    controller = getDocumentController();
    super.initState();
  }

  editor.QuillController getDocumentController() {
    try {
      if (widget.document != null && widget.document?.isNotEmpty == true) {
        return editor.QuillController(
          document: editor.Document.fromJson(widget.document!),
          selection: const TextSelection.collapsed(offset: 0),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("ERROR: getDocumentController $e");
      }
    }
    return editor.QuillController.basic();
  }

  @override
  Widget build(BuildContext context) {
    return editor.QuillEditor(
      controller: controller,
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: FocusNode(),
      autoFocus: true,
      readOnly: true,
      expands: false,
      padding: const EdgeInsets.symmetric(
        horizontal: ConfigConstant.margin2,
        vertical: ConfigConstant.margin2 + 8.0,
      ),
    );
  }
}
