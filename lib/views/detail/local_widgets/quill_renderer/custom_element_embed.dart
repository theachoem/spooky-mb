import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:spooky/views/detail/detail_view_model.dart';
import 'package:spooky/views/detail/local_widgets/quill_renderer/date_block_embed.dart';
import 'package:spooky/views/detail/local_widgets/quill_renderer/date_block_embed_builder.dart';

class CustomElementEmbed extends StatelessWidget {
  const CustomElementEmbed({
    Key? key,
    required this.controller,
    required this.block,
    required this.readOnly,
    this.onVideoInit,
    required this.viewModel,
  }) : super(key: key);

  final quill.QuillController controller;
  final quill.CustomBlockEmbed block;
  final bool readOnly;
  final void Function(GlobalKey videoContainerKey)? onVideoInit;
  final DetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    switch (block.type) {
      case DateBlockEmbed.blockType:
        return DateBlockEmbedBuilder(
          block: block,
          readOnly: readOnly,
          controller: controller,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
