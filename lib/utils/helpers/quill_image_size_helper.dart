// ignore_for_file: implementation_imports
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/src/utils/string.dart';
import 'package:tuple/tuple.dart';

class QuillImageResizeHelper {
  final quill.Embed node;

  QuillImageResizeHelper({
    required this.node,
  });

  Tuple2<double?, double?>? fetchSize() {
    quill.Attribute<dynamic>? style = node.style.attributes['style'];
    if (style == null) return null;

    Map<String, String> attrs = parseKeyValuePairs(style.value.toString(), {
      quill.Attribute.mobileWidth,
      quill.Attribute.mobileHeight,
      quill.Attribute.mobileMargin,
      quill.Attribute.mobileAlignment,
    });

    double? w = double.tryParse(attrs[quill.Attribute.mobileWidth]!);
    double? h = double.tryParse(attrs[quill.Attribute.mobileHeight]!);

    Tuple2<double?, double?>? widthHeight = Tuple2(w, h);
    return widthHeight;
  }
}
