// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/src/utils/font.dart';

class SpFontSizeButton extends StatelessWidget {
  const SpFontSizeButton({
    required this.controller,
    this.iconSize = quill.kDefaultIconSize,
    this.iconTheme,
    Key? key,
  }) : super(key: key);

  final double iconSize;
  final quill.QuillController controller;
  final quill.QuillIconTheme? iconTheme;

  @override
  Widget build(BuildContext context) {
    //default font size values
    final fontSizes = {
      'Small': 'small',
      'Large': 'large',
      'Huge': 'huge',
      'Clear': '0',
    };

    return quill.QuillFontSizeButton(
      iconTheme: iconTheme,
      iconSize: iconSize,
      attribute: quill.Attribute.size,
      controller: controller,
      rawItemsMap: fontSizes,
      items: [
        for (MapEntry<String, String> fontSize in fontSizes.entries)
          PopupMenuItem<String>(
            key: ValueKey(fontSize.key),
            value: fontSize.value,
            child: Text(fontSize.key.toString(), style: TextStyle(color: fontSize.value == '0' ? Colors.red : null)),
          ),
      ],
      onSelected: (newSize) {
        controller.formatSelection(
          quill.Attribute.fromKeyValue(
            'size',
            newSize == '0' ? null : getFontSize(newSize),
          ),
        );
      },
    );
  }
}
