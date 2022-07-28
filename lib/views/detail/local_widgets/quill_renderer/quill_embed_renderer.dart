// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:spooky/views/detail/local_widgets/quill_renderer/quill_image_renderer.dart';
import 'package:spooky/views/detail/local_widgets/quill_renderer/quill_unsupported_embed.dart';

class QuillEmbedRenderer extends StatelessWidget {
  const QuillEmbedRenderer({
    Key? key,
    required this.controller,
    required this.node,
    required this.readOnly,
  }) : super(key: key);

  final quill.QuillController controller;
  final quill.Embed node;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    switch (node.value.type) {
      case quill.BlockEmbed.imageType:
        return QuillImageRenderer(
          node: node,
          controller: controller,
          readOnly: readOnly,
        );
      default:
        return const QuillUnsupportedEmbed();
    }
  }
}
