import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';
import 'package:spooky/widgets/sp_toolbar/sp_move_cursor_button.dart';

class DateBlockEmbed extends CustomBlockEmbed {
  static const String blockType = 'date';

  const DateBlockEmbed(String value) : super(blockType, value);
  static DateBlockEmbed fromDocument(Document document) {
    return DateBlockEmbed(
      jsonEncode(document.toDelta().toJson()),
    );
  }

  Document get document {
    return Document.fromJson(jsonDecode(data));
  }

  static void update({
    required QuillController controller,
    required DateTime initDate,
    required BuildContext context,
    required Document document,
  }) async {
    DateTime? pathDate = await SpDatePicker.showDatePicker(
      context,
      initDate,
    );

    if (pathDate != null) {
      final block = BlockEmbed.custom(
        DateBlockEmbed.fromDocument(
          Document.fromDelta(
            Delta()..insert("${pathDate.toIso8601String()}\n"),
          ),
        ),
      );
      final offset = getEmbedNode(controller, controller.selection.start).item1;
      controller.replaceText(offset, 1, block, TextSelection.collapsed(offset: offset));
    }
  }

  static void add({
    required QuillController controller,
    required DateTime initDate,
  }) {
    final block = BlockEmbed.custom(
      DateBlockEmbed.fromDocument(
        Document.fromDelta(
          Delta()..insert("${initDate.toIso8601String()}\n"),
        ),
      ),
    );

    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;
    controller.replaceText(index, length, block, null);

    SpMoveCursurButton.moveCursor(1, controller);
  }
}
