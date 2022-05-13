// ignore_for_file: implementation_imports

import 'package:flutter/foundation.dart';
import 'package:flutter_quill/src/models/documents/attribute.dart' as attribute;
import 'package:flutter_quill/src/models/documents/nodes/block.dart' as block;
import 'package:flutter_quill/src/models/documents/nodes/node.dart' as node;

class QuillHelper {
  static List<String> imagesFromJson(List document) {
    List<String> images = [];
    try {
      for (dynamic e in document) {
        final insert = e['insert'];
        if (insert is Map) {
          for (MapEntry<dynamic, dynamic> e in insert.entries) {
            if (e.value != null && e.value.isNotEmpty) {
              images.add(e.value);
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      }
    }
    return images;
  }

  static String toPlainText(node.Root root) {
    final plainText = root.children.map((node.Node e) {
      final atts = e.style.attributes;
      attribute.Attribute? att = atts['list'] ?? atts['blockquote'] ?? atts['code-block'];

      if (e is block.Block) {
        int index = 0;
        String result = "";
        for (node.Node entry in e.children) {
          if (att?.key == "blockquote") {
            String text = entry.toPlainText();
            text = text.replaceFirst(RegExp('\n'), '', text.length - 1);
            result += "\n︳$text";
          } else if (att?.key == "code-block") {
            result += '︳${entry.toPlainText()}';
          } else {
            if (att?.value == "checked") {
              result += "☒\t${entry.toPlainText()}";
            } else if (att?.value == "unchecked") {
              result += "☐\t${entry.toPlainText()}";
            } else if (att?.value == "ordered") {
              index++;
              result += "$index.\t${entry.toPlainText()}";
            } else if (att?.value == "bullet") {
              result += "•\t${entry.toPlainText()}";
            }
          }
        }
        return result;
      } else {
        return e.toPlainText();
      }
    }).join();

    // replace all image object to empty
    return plainText.replaceAll("\uFFFC", "");
  }
}
