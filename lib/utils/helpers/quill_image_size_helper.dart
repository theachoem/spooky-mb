// ignore_for_file: implementation_imports

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/src/utils/string.dart';
import 'package:spooky/utils/util_widgets/quill_image_resizer.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_quill/src/widgets/embeds/image.dart';

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

  void resize(BuildContext context, quill.QuillController controller) {
    Tuple2<double?, double?>? size = fetchSize();
    showModal(
      context: context,
      builder: (context) {
        final screenSize = MediaQuery.of(context).size;
        return QuillImageResizer(
          onImageResize: (w, h) {
            Tuple2<int, quill.Embed> res = getImageNode(controller, controller.selection.start);
            String attr = replaceStyleString(getImageStyleString(controller), w, h);
            controller.formatText(
              res.item1,
              1,
              quill.StyleAttribute(attr),
            );
          },
          imageWidth: size?.item1,
          imageHeight: size?.item2,
          maxWidth: screenSize.width,
          maxHeight: screenSize.height,
        );
      },
    );
  }
}
