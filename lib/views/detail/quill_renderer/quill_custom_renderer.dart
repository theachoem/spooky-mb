import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:spooky/views/detail/quill_renderer/custom_date_block_renderer.dart';
import 'package:spooky/views/detail/quill_renderer/quill_unsupported_renderer.dart';
import 'package:spooky/views/detail/quill_renderer_helper/date_block_embed.dart';

// TODO: seperate this renderer
class QuillCustomRenderer extends quill.EmbedBuilder {
  @override
  String get key => DateBlockEmbed.blockType;

  @override
  Widget build(BuildContext context, quill.QuillController controller, quill.Embed node, bool readOnly) {
    quill.Embeddable block = node.value;

    switch (block.type) {
      case DateBlockEmbed.blockType:
        return CustomDateBlockRenderer(
          block: block as quill.CustomBlockEmbed,
          readOnly: readOnly,
          controller: controller,
        );
      default:
        return const QuillUnsupportedRenderer();
    }
  }
}
