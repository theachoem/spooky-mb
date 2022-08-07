import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class SpMoveCursurButton extends StatelessWidget {
  final bool isRight;
  final QuillController controller;
  final QuillIconTheme? iconTheme;
  final double iconSize;

  const SpMoveCursurButton({
    required this.controller,
    required this.iconSize,
    this.iconTheme,
    this.isRight = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuillIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: iconSize * kIconButtonFactor,
      borderRadius: iconTheme?.borderRadius ?? 2,
      icon: Icon(
        isRight ? Icons.arrow_right : Icons.arrow_left,
      ),
      onPressed: () {
        moveCursor(1, controller, isRight);
      },
    );
  }

  static void moveCursor(
    int value,
    QuillController controller, [
    bool toRight = true,
  ]) {
    final offsetLeft = controller.selection.baseOffset - value;
    final offsetRight = controller.selection.baseOffset + value;
    controller.updateSelection(
      TextSelection.fromPosition(
        TextPosition(offset: max(toRight ? offsetRight : offsetLeft, 0)),
      ),
      ChangeSource.LOCAL,
    );
  }
}
