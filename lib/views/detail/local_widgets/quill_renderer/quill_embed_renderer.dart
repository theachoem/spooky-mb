// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/detail/local_widgets/quill_renderer/quill_image_renderer.dart';

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
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
          padding: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
          decoration: BoxDecoration(
            color: M3Color.of(context).tertiaryContainer,
            borderRadius: ConfigConstant.circlarRadius2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: const [
              Icon(Icons.error),
              ConfigConstant.sizedBoxH1,
              Text('Unsupported embed type'),
            ],
          ),
        );
    }
  }
}
