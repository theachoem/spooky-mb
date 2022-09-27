import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/views/detail/quill_renderer_helper/date_block_embed.dart';

class SpDateButton extends StatelessWidget {
  const SpDateButton({
    Key? key,
    required this.iconSize,
    this.iconTheme,
    this.fillColor,
    required this.controller,
  }) : super(key: key);

  final double iconSize;
  final Color? fillColor;
  final quill.QuillIconTheme? iconTheme;
  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconColor = iconTheme?.iconUnselectedColor ?? theme.iconTheme.color;
    final iconFillColor = iconTheme?.iconUnselectedFillColor ?? (fillColor ?? theme.canvasColor);

    return quill.QuillIconButton(
      icon: Icon(CommunityMaterialIcons.calendar_plus, size: iconSize - 2, color: iconColor),
      highlightElevation: 0,
      hoverElevation: 0,
      size: iconSize * 1.77,
      fillColor: iconFillColor,
      onPressed: () {
        DateBlockEmbed.add(
          controller: controller,
          initDate: DateTime.now(),
        );
      },
    );
  }
}
