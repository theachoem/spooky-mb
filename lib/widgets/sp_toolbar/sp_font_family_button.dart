// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/src/widgets/toolbar/quill_font_family_button.dart';

class SpFontFamilyButton extends StatelessWidget {
  const SpFontFamilyButton({
    required this.controller,
    this.toolbarIconSize = quill.kDefaultIconSize,
    this.iconTheme,
    Key? key,
  }) : super(key: key);

  final double toolbarIconSize;
  final quill.QuillController controller;
  final quill.QuillIconTheme? iconTheme;

  @override
  Widget build(BuildContext context) {
    final fontFamilies = {
      'Sans Serif': 'sans-serif',
      'Serif': 'serif',
      'Monospace': 'monospace',
      'Clear': 'Clear',
    };

    return QuillFontFamilyButton(
      iconTheme: iconTheme,
      iconSize: toolbarIconSize,
      attribute: quill.Attribute.font,
      controller: controller,
      items: [
        for (MapEntry<String, String> fontFamily in fontFamilies.entries)
          PopupMenuItem<String>(
            key: ValueKey(fontFamily.key),
            value: fontFamily.value,
            child: Text(fontFamily.key.toString(),
                style: TextStyle(color: fontFamily.value == 'Clear' ? Colors.red : null)),
          ),
      ],
      onSelected: (newFont) {
        controller.formatSelection(quill.Attribute.fromKeyValue('font', newFont == 'Clear' ? null : newFont));
      },
      rawItemsMap: fontFamilies,
    );
  }
}
