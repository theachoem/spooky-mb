import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:convert';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';
import 'package:spooky/widgets/sp_toolbar/sp_move_cursor_button.dart';

class DateBlockEmbed extends quill.CustomBlockEmbed {
  static const String blockType = 'date';

  const DateBlockEmbed(String value) : super(blockType, value);
  static DateBlockEmbed fromDocument(quill.Document document) {
    return DateBlockEmbed(
      jsonEncode(document.toDelta().toJson()),
    );
  }

  quill.Document get document {
    return quill.Document.fromJson(jsonDecode(data));
  }

  static void update({
    required quill.QuillController controller,
    required DateTime initDate,
    required BuildContext context,
    required quill.Document document,
  }) async {
    DateTime? pathDate = await SpDatePicker.showDatePicker(
      context,
      initDate,
    );

    if (pathDate != null) {
      final block = quill.BlockEmbed.custom(
        DateBlockEmbed.fromDocument(
          quill.Document.fromDelta(
            quill.Delta()..insert("${pathDate.toIso8601String()}\n"),
          ),
        ),
      );
      final offset = quill.getEmbedNode(controller, controller.selection.start).offset;
      controller.replaceText(offset, 1, block, TextSelection.collapsed(offset: offset));
    }
  }

  static void add({
    required quill.QuillController controller,
    required DateTime initDate,
  }) {
    final block = quill.BlockEmbed.custom(
      DateBlockEmbed.fromDocument(
        quill.Document.fromDelta(
          quill.Delta()..insert("${initDate.toIso8601String()}\n"),
        ),
      ),
    );

    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;
    controller.replaceText(index, length, block, null);

    SpMoveCursurButton.moveCursor(1, controller);
  }
}
