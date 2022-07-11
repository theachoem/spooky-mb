// ignore_for_file: implementation_imports
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/src/widgets/embeds/image.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/util_widgets/quill_image_resizer.dart';
import 'package:spooky/widgets/sp_floating_popup_button.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/cupertino.dart';
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
      dyGetter: (double dy) => kToolbarHeight + 16.0,
      floatBuilder: (callback) {
        final screenSize = MediaQuery.of(context).size;
        return QuillImageResizer(
          onImageResize: (w, h) {
            Tuple2<int, quill.Embed> res = getImageNode(controller, controller.selection.start);
            String attr = replaceStyleString(getImageStyleString(controller), w, h);
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
          backgroundColor: M3Color.of(context).readOnly.surface5,
          icon: const Icon(CommunityMaterialIcons.resize),
          onPressed: () {
            callback();
          },
        );
      },
    );
  }
}
