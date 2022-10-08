// ignore_for_file: implementation_imports
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:spooky/utils/helpers/quill_extensions.dart' as ext;
import 'package:spooky/utils/util_widgets/quill_image_resizer.dart';
import 'package:spooky/widgets/sp_floating_popup_button.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_quill/src/utils/string.dart';

class ImageResizeButton extends StatelessWidget {
  const ImageResizeButton({
    Key? key,
    required this.controller,
    required this.size,
  }) : super(key: key);

  final quill.QuillController controller;
  final Tuple2<double?, double?>? size;

  @override
  Widget build(BuildContext context) {
    return SpFloatingPopUpButton(
      cacheFloatingSize: 216.0,
      bottomToTop: false,
      dyGetter: (double dy) => dy - 48.0 * 2 - 8,
      floatBuilder: (callback) {
        final screenSize = MediaQuery.of(context).size;
        return QuillImageResizer(
          onImageResize: (w, h) {
            final res = quill.getEmbedNode(controller, controller.selection.start);
            final attr = replaceStyleString(ext.getImageStyleString(controller), w, h);
            controller.formatText(res.item1, 1, quill.StyleAttribute(attr));
          },
          imageWidth: size?.item1,
          imageHeight: size?.item2,
          maxWidth: screenSize.width,
          maxHeight: screenSize.height,
        );
      },
      builder: (callback) {
        return SpIconButton(
          key: key,
          icon: const Icon(CommunityMaterialIcons.resize),
          onPressed: () {
            callback();
          },
        );
      },
    );
  }
}
